import SwiftUI

struct PlantPhotoCredit: Decodable, Identifiable {
    let plantId: String
    let file: String
    let source: String
    let author: String
    let license: String
    let licenseURL: String
    let changes: String
    var id: String { plantId }

    var plainAuthor: String {
        author.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&#160;", with: " ")
    }
}

struct PlantPhotoCreditsView: View {
    @EnvironmentObject var localization: LocalizationManager
    private var isPolish: Bool { localization.currentLanguage == "pl" }
    private let credits: [PlantPhotoCredit] = {
        guard let url = Bundle.main.url(forResource: "PlantPhotoCredits", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let credits = try? JSONDecoder().decode([PlantPhotoCredit].self, from: data) else { return [] }
        return credits
    }()

    var body: some View {
        List {
            Section {
                Text(isPolish ? "Źródła nowych zdjęć katalogowych. Zdjęcia dołączono offline bez edycji, jako miniatury udostępnione przez Wikimedia Commons." : "Credits for the new catalog photos. Unedited thumbnails from Wikimedia Commons are bundled for offline use.")
            }
            ForEach(credits) { credit in
                Section(PlantDatabase.shared.plant(byId: credit.plantId)?.localizedName(for: localization.currentLanguage) ?? credit.plantId) {
                    Text(credit.file).font(.caption)
                    Text(credit.plainAuthor).font(.subheadline)
                    if let url = URL(string: credit.source) {
                        Link(isPolish ? "Źródło zdjęcia" : "Photo source", destination: url)
                    }
                    if let url = URL(string: credit.licenseURL), !credit.licenseURL.isEmpty {
                        Link(credit.license, destination: url)
                    } else {
                        Text(credit.license)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(SeedlyTheme.homeGradient.ignoresSafeArea())
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationTitle(isPolish ? "Autorzy zdjęć" : "Photo credits")
    }
}
