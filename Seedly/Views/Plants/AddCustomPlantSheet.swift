// AddCustomPlantSheet.swift
// Simple Seeds
//
// Lets the user create their own plant entry with a photo (camera or library),
// name, scientific name, category and notes. Saved to GardenStore.

import SwiftUI
import PhotosUI

struct AddCustomPlantSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localization: LocalizationManager
    @EnvironmentObject var garden: GardenStore
    
    @State private var name = ""
    @State private var scientificName = ""
    @State private var notes = ""
    @State private var category: PlantCategory = .vegetable
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var photoData: Data?
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // MARK: Photo
                Section(localization.photo) {
                    photoSection
                }
                
                // MARK: Details
                Section(localization.taskDetails) {
                    TextField(localization.plantName, text: $name)
                    TextField(localization.scientificName, text: $scientificName)
                        .italic()
                    Picker(localization.category, selection: $category) {
                        ForEach(PlantCategory.allCases) { cat in
                            Label(localization.categoryName(cat), systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                }
                
                // MARK: Notes
                Section(localization.notes) {
                    TextField(localization.notes, text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(localization.newPlant)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(localization.cancel) { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(localization.save) { save() }
                        .font(.system(.body, weight: .semibold))
                        .foregroundStyle(SeedlyTheme.primaryGreen)
                        .disabled(!canSave)
                }
            }
            .onChange(of: pickerItem) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        photoData = compress(data)
                    }
                }
            }
        }
    }
    
    // MARK: - Photo Section
    
    @ViewBuilder
    private var photoSection: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .frame(width: 100, height: 100)
                
                if let data = photoData, let ui = UIImage(data: data) {
                    Image(uiImage: ui)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            
            let choosePhotoTitle = localization.choosePhoto
            PhotosPicker(
                selection: $pickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label(choosePhotoTitle, systemImage: "photo")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Save
    
    private func save() {
        let plant = CustomPlant.new(
            name: name.trimmingCharacters(in: .whitespaces),
            scientificName: scientificName.trimmingCharacters(in: .whitespaces),
            notes: notes,
            category: category,
            photoData: photoData
        )
        garden.addCustom(plant)
        dismiss()
    }
    
    // MARK: - Image compression
    
    /// Resize/compress the chosen image so we don't bloat UserDefaults.
    private func compress(_ data: Data) -> Data {
        guard let image = UIImage(data: data) else { return data }
        let maxDimension: CGFloat = 1024
        let size = image.size
        let scale = min(1, maxDimension / max(size.width, size.height))
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.8) ?? data
    }
}

#Preview {
    AddCustomPlantSheet()
        .environmentObject(LocalizationManager.shared)
        .environmentObject(GardenStore.shared)
}
