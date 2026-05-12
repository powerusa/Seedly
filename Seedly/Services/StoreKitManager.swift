// StoreKitManager.swift
// Seedly
//
// StoreKit 2 integration for one-time purchase only.
// NO subscriptions. NO recurring billing. NO ads.
// "Buy once. Garden forever."

import Foundation
import StoreKit

@MainActor
final class StoreKitManager: ObservableObject {
    
    // MARK: - Product IDs
    static let appPurchaseID = "com.seedly.app.fullversion"
    
    // Optional future expansion packs
    static let greenhousePackID = "com.seedly.pack.greenhouse"
    static let tropicalPackID = "com.seedly.pack.tropical"
    static let orchardPackID = "com.seedly.pack.orchard"
    static let professionalPackID = "com.seedly.pack.professional"
    
    static let allProductIDs: Set<String> = [
        appPurchaseID,
        greenhousePackID,
        tropicalPackID,
        orchardPackID,
        professionalPackID
    ]
    
    // MARK: - Published Properties
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: StoreError?
    
    // MARK: - Computed Properties
    var hasFullAccess: Bool {
        purchasedProductIDs.contains(Self.appPurchaseID)
    }
    
    var hasGreenhousePack: Bool {
        purchasedProductIDs.contains(Self.greenhousePackID)
    }
    
    var hasTropicalPack: Bool {
        purchasedProductIDs.contains(Self.tropicalPackID)
    }
    
    // MARK: - Private
    private var updateListenerTask: Task<Void, Error>?
    
    init() {
        updateListenerTask = listenForTransactions()
        Task { await loadProducts() }
        Task { await updatePurchasedProducts() }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Load Products
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            products = try await Product.products(for: Self.allProductIDs)
                .sorted { $0.price < $1.price }
        } catch {
            self.error = .failedToLoadProducts
        }
    }
    
    // MARK: - Purchase
    func purchase(_ product: Product) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                return true
                
            case .userCancelled:
                return false
                
            case .pending:
                return false
                
            @unknown default:
                return false
            }
        } catch {
            self.error = .purchaseFailed
            return false
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }
        
        try? await AppStore.sync()
        await updatePurchasedProducts()
    }
    
    // MARK: - Transaction Listener
    private func listenForTransactions() -> Task<Void, Error> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    guard let transaction = try self?.checkVerifiedDetached(result) else { continue }
                    let productID = transaction.productID
                    await self?.markPurchased(productID)
                    await transaction.finish()
                } catch {
                    // Transaction verification failed
                }
            }
        }
    }
    
    private func markPurchased(_ productID: String) {
        purchasedProductIDs.insert(productID)
    }
    
    private nonisolated func checkVerifiedDetached(_ result: VerificationResult<Transaction>) throws -> Transaction {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Update Purchased Products
    private func updatePurchasedProducts() async {
        var purchased: Set<String> = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                purchased.insert(transaction.productID)
            } catch {
                // Skip unverified transactions
            }
        }
        
        purchasedProductIDs = purchased
    }
    
    // MARK: - Verification
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}

// MARK: - Store Error

enum StoreError: Error, LocalizedError {
    case failedToLoadProducts
    case purchaseFailed
    case verificationFailed
    case noProductFound
    
    var errorDescription: String? {
        switch self {
        case .failedToLoadProducts: return "Unable to load products."
        case .purchaseFailed: return "Purchase failed. Please try again."
        case .verificationFailed: return "Transaction verification failed."
        case .noProductFound: return "Product not found."
        }
    }
}
