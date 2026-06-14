// MyGardenView.swift
// Seedly

import SwiftUI
import SwiftData

struct MyGardenView: View {
    @Query private var gardens: [Garden]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddGarden = false
    
    var body: some View {
        NavigationStack {
            Group {
                if gardens.isEmpty {
                    EmptyStateView(
                        icon: "leaf.circle",
                        title: "No Gardens Yet",
                        message: "Create your first garden to start tracking your plants and get personalized recommendations.",
                        actionTitle: "Create Garden"
                    ) {
                        showAddGarden = true
                    }
                } else {
                    gardenList
                }
            }
            .navigationTitle("My Gardens")
            .toolbar {
                if !gardens.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showAddGarden = true }) {
                            Image(systemName: "plus")
                                .foregroundStyle(SeedlyTheme.primaryGreen)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddGarden) {
                AddGardenSheet()
            }
        }
    }
    
    private var gardenList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(gardens) { garden in
                    GardenCard(garden: garden)
                }
            }
            .padding(.horizontal, SeedlyTheme.paddingLarge)
            .padding(.top, SeedlyTheme.paddingMedium)
        }
    }
}

// MARK: - Garden Card

struct GardenCard: View {
    let garden: Garden
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(garden.name)
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                    
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption2)
                        Text("\(garden.city), \(garden.country)")
                            .font(.system(.caption, design: .rounded))
                    }
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                if garden.isActive {
                    Text("Active")
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                        .foregroundStyle(SeedlyTheme.accentGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(SeedlyTheme.accentGreen.opacity(0.1))
                        )
                }
            }
            
            HStack(spacing: 16) {
                GardenStat(icon: "leaf.fill", value: "\(garden.plants?.count ?? 0)", label: "Plants")
                GardenStat(icon: "checklist", value: "\(garden.tasks?.count ?? 0)", label: "Tasks")
                GardenStat(icon: "cloud.sun", value: garden.climateZoneId.prefix(3).uppercased(), label: "Zone")
            }
        }
        .padding(SeedlyTheme.paddingMedium)
        .background(
            RoundedRectangle(cornerRadius: SeedlyTheme.cornerRadius)
                .fill(Color(.systemBackground))
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
}

struct GardenStat: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(SeedlyTheme.accentGreen)
            VStack(alignment: .leading, spacing: 1) {
                Text(value)
                    .font(.system(.caption, design: .rounded, weight: .semibold))
                Text(label)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: - Add Garden Sheet

struct AddGardenSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var gardenName = ""
    @State private var gardenType = "in-ground"
    @State private var useCurrentLocation = true
    
    private let gardenTypes = ["in-ground", "raised bed", "container", "greenhouse", "balcony"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Garden Name") {
                    TextField("My Garden", text: $gardenName)
                }
                
                Section("Type") {
                    Picker("Garden Type", selection: $gardenType) {
                        ForEach(gardenTypes, id: \.self) { type in
                            Text(type.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Location") {
                    Toggle("Use Current Location", isOn: $useCurrentLocation)
                    
                    if !useCurrentLocation {
                        TextField("City", text: .constant(""))
                        TextField("Country", text: .constant(""))
                    }
                }
            }
            .navigationTitle("New Garden")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        createGarden()
                        dismiss()
                    }
                    .font(.system(.body, weight: .semibold))
                    .foregroundStyle(SeedlyTheme.primaryGreen)
                    .disabled(gardenName.isEmpty)
                }
            }
        }
    }
    
    private func createGarden() {
        let location = appState.currentLocation
        let climateZone = location.map { ClimateEngine().determineZone(for: $0) }
        
        let garden = Garden(
            name: gardenName,
            locationLatitude: location?.latitude ?? 0,
            locationLongitude: location?.longitude ?? 0,
            city: location?.city ?? "Unknown",
            country: location?.country ?? "Unknown",
            climateZoneId: climateZone?.id ?? "unknown",
            gardenType: gardenType
        )
        modelContext.insert(garden)
    }
}

#Preview {
    MyGardenView()
        .modelContainer(for: Garden.self, inMemory: true)
}
