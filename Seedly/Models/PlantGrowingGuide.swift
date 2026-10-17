import Foundation

extension Plant {
    /// These plants need bulb/rootstock-specific seasons rather than the annual seed model.
    var usesSeasonalGuide: Bool {
        category == .tree || ["daffodil", "peony"].contains(id)
    }

    var growingGuide: String? {
        let polish = UserDefaults.standard.string(forKey: "selectedLanguage") == "pl"
        let guides: [String: (String, String)] = [
            "kohlrabi": ("Sow in spring or late summer. Keep soil evenly moist and harvest young, tender swollen stems. Typical harvest: 6–12 weeks; variety and weather affect timing.", "Siej wiosną lub pod koniec lata. Utrzymuj równomierną wilgotność i zbieraj młode, delikatne zgrubienia. Zbiór zwykle po 6–12 tygodniach, zależnie od odmiany i pogody."),
            "fennel": ("This is perennial herb fennel, grown for leaves and seeds, not Florence bulb fennel. Grow in sun with drainage and allow room for tall stems. Leaf harvest depends on establishment.", "Wieloletni koper włoski na liście i nasiona, nie odmiana bulwiasta. Wybierz słoneczne stanowisko z odpływem wody i miejsce na wysokie pędy. Termin zbioru liści zależy od przyjęcia się rośliny."),
            "tarragon": ("For culinary French tarragon, buy a plant or use cuttings/division: it does not reliably grow from seed. Russian tarragon can be seed-grown. Keep roots well drained, especially in winter.", "Estragon francuski kup jako sadzonkę lub rozmnażaj przez podział; nie uzyskuje się go wiarygodnie z nasion. Estragon rosyjski można siać. Zapewnij odpływ wody, szczególnie zimą."),
            "daffodil": ("Plant bulbs in autumn, around three bulb-heights deep in well-drained soil. Flowers appear in spring; leave foliage until it yellows. Ornamental only: bulbs are toxic and must not be eaten.", "Sadź cebule jesienią na głębokość około trzech wysokości cebuli, w przepuszczalnej glebie. Kwitnie wiosną; pozostaw liście do zżółknięcia. Roślina ozdobna: cebule są trujące, niejadalne."),
            "pansy": ("Sow for the flowering season of your chosen variety. Summer sowing can provide spring bedding the following year. Water regularly and remove spent flowers. No food-harvest date is calculated.", "Termin siewu dopasuj do odmiany i planowanego kwitnienia. Siew latem może dać kwiaty następnej wiosny. Podlewaj i usuwaj przekwitłe kwiaty. Aplikacja nie wylicza zbioru jadalnego."),
            "peony": ("Plant bare roots in autumn with eyes no deeper than about 2.5 cm. Choose sun and good drainage. Plants can need several years to flower reliably. Avoid moving established plants.", "Sadź kłącza jesienią, z pąkami nie głębiej niż około 2,5 cm. Wybierz słońce i przepuszczalną glebę. Regularne kwitnienie może rozpocząć się po kilku latach. Unikaj przesadzania."),
            "appleTree": ("Plant a grafted nursery tree. Bare-root trees are planted while dormant, avoiding frozen or waterlogged soil. Rootstock controls spacing and container suitability. Check pollination partners. First fruit takes years, not weeks; timing varies by cultivar and rootstock.", "Sadź szczepione drzewko ze szkółki. Drzewka z odkrytym korzeniem sadź w spoczynku, unikając gleby zamarzniętej i podmokłej. Rozstaw i uprawa w donicy zależą od podkładki. Sprawdź zapylacz. Pierwsze owoce po latach, zależnie od odmiany i podkładki."),
            "pearTree": ("Plant a grafted tree in sun with well-drained soil. Plant bare-root trees while dormant. Many cultivars need a compatible pollination partner. Spacing and first crop depend on rootstock and cultivar; the app does not predict an exact harvest date.", "Sadź szczepione drzewko w słońcu i przepuszczalnej glebie. Odkryty korzeń sadź w spoczynku. Wiele odmian wymaga zgodnego zapylacza. Rozstaw i pierwszy zbiór zależą od podkładki i odmiany; aplikacja nie przewiduje dokładnej daty zbioru."),
            "cherryTree": ("Sweet cherries need sun and drainage. Choose a self-fertile cultivar or a compatible pollinator. Water newly planted trees during dry spells. Rootstock controls final size; allow several years for fruiting. No exact first-harvest date is predicted.", "Czereśnia potrzebuje słońca i przepuszczalnej gleby. Wybierz odmianę samopłodną lub zgodny zapylacz. Podlewaj młode drzewka podczas suszy. Podkładka określa wielkość drzewa; na owocowanie czeka się kilka lat. Bez prognozy dokładnej daty pierwszego zbioru.")
        ]
        guard let guide = guides[id] else { return nil }
        return polish ? guide.1 : guide.0
    }
}
