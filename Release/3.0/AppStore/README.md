# Seedly 3.0 — materiały aktualizacji

Wersja aplikacji: **3.0**, numer kompilacji: **4**.

- `pl/` — 6 rzeczywistych screenshotów polskiej aplikacji, w tym działająca pogoda MET Norway.
- `en/` — 6 rzeczywistych screenshotów angielskiej aplikacji, w tym działająca pogoda MET Norway.
- `header-pl.png`, `header-en.png` — nagłówki do slotu Header Apple: **5244 × 2950 px**. Warianty `header-en-3840x1646.png` i `header-pl-3840x1646.png` mają drugi obsługiwany rozmiar **3840 × 1646 px**. Nie należy ich dodawać do slotu screenshotów iPhone.
- `whats-new-pl.txt`, `whats-new-en.txt` — tekst „Co nowego” / „What's New” do wersji 3.0.

Screenshoty zapisano bez ramek i modyfikacji zawartości, bezpośrednio z iPhone 18 Pro Simulator. Rozdzielczość **1206 × 2622 px**, PNG RGB bez przezroczystości. W App Store Connect należy wybrać kategorię **iPhone with Dynamic Island (medium display)**. Rozdzielczość jest wymieniona w [specyfikacji Apple](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications). Jeśli konkretny slot wymaga dużego ekranu, potrzebny będzie osobny zestaw z symulatora Pro Max; obecne pliki są opisane zgodnie z faktycznym urządzeniem.

## Co potwierdzono

- GPS: testowe współrzędne Warszawy 52.2297, 21.0122 zostały rozpoznane jako Warsaw, Poland.
- Wyszukiwanie miasta: Krakow, Poland ustawiło Kraków i strefę Europe/Warsaw, także po zmianie języka.
- Ręczna lokalizacja oraz język zachowały się po ponownym uruchomieniu aplikacji.
- Zmiana polski ↔ angielski działa w menu, zakładkach, kalendarzu, szczegółach i nazwach roślin; naprawiono odświeżanie wcześniej otwartych kart.
- Testy programowe sprawdzają 15 wyborów języka i podstawowe etykiety. To nie jest potwierdzenie kompletnego tłumaczenia wszystkich ekranów na wszystkie 15 języków; część tekstów pomocniczych nadal używa angielskiego.
- Kompilacja iOS Simulator i testy regresji przeszły.

Do zrzutów użyto wyłącznie publicznych, przykładowych lokalizacji. Kalendarz pokazuje wybrany kwiecień 2027, co demonstruje planowanie i przejście między latami. Nowy ekran pogody pokazuje rzeczywiste dane modelowe MET Norway dla wybranej lokalizacji. Nie korzysta z odczytów czujnika telefonu ani systemowej aplikacji Pogoda. Testy na fizycznym iPhonie, podpisana kompilacja dystrybucyjna, działanie produkcyjnego StoreKit i wysłanie do App Store Connect pozostają osobnymi krokami.

## Zapis na GitHub

Kod i kolejne poprawki są wysyłane do `powerusa/Seedly`, gałąź `main`. Kopia tego pakietu znajduje się w `Release/3.0/AppStore/`. Generator nagłówka jest w `Release/3.0/Tools/render-header.swift`.

## Pogoda w kompilacji 4

Źródło: [MET Norway Locationforecast](https://api.met.no/doc/License), CC BY 4.0. Zapytania nie wymagają klucza API ani uprawnień WeatherKit. Aplikacja wysyła współrzędne zaokrąglone do czterech miejsc dziesiętnych; dostawca otrzymuje również adres IP. Dane modelowe są łączone w prognozy dobowe. Nowa prognoza przeszła testy jednostek, czasu lokalnego, brakujących pól, równoległych zapytań, cache i limitów API. Przy dużej skali dystrybucji potrzebny jest współdzielony serwer cache zgodnie z zasadami dostawcy.
