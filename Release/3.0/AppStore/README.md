# Seedly 3.0 — materiały aktualizacji

Wersja aplikacji: **3.0**, numer kompilacji: **3**.

- `pl/` — 5 rzeczywistych screenshotów polskiej aplikacji.
- `en/` — 5 rzeczywistych screenshotów angielskiej aplikacji.
- `header-pl.png`, `header-en.png` — dodatkowe grafiki nagłówkowe 1600 × 900. To materiały promocyjne; nie są screenshotami do slotu iPhone w App Store Connect.
- `whats-new-pl.txt`, `whats-new-en.txt` — tekst „Co nowego” / „What's New” do wersji 3.0.

Screenshoty zapisano bez ramek i modyfikacji zawartości, bezpośrednio z iPhone 18 Pro Simulator. Rozdzielczość **1206 × 2622 px**, PNG RGB bez przezroczystości. W App Store Connect należy wybrać kategorię **iPhone with Dynamic Island (medium display)**. Rozdzielczość jest wymieniona w [specyfikacji Apple](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications). Jeśli konkretny slot wymaga dużego ekranu, potrzebny będzie osobny zestaw z symulatora Pro Max; obecne pliki są opisane zgodnie z faktycznym urządzeniem.

## Co potwierdzono

- GPS: testowe współrzędne Warszawy 52.2297, 21.0122 zostały rozpoznane jako Warsaw, Poland.
- Wyszukiwanie miasta: Krakow, Poland ustawiło Kraków i strefę Europe/Warsaw, także po zmianie języka.
- Ręczna lokalizacja oraz język zachowały się po ponownym uruchomieniu aplikacji.
- Zmiana polski ↔ angielski działa w menu, zakładkach, kalendarzu, szczegółach i nazwach roślin; naprawiono odświeżanie wcześniej otwartych kart.
- Testy programowe sprawdzają 15 wyborów języka i podstawowe etykiety. To nie jest potwierdzenie kompletnego tłumaczenia wszystkich ekranów na wszystkie 15 języków; część tekstów pomocniczych nadal używa angielskiego.
- Kompilacja iOS Simulator i testy regresji przeszły.

Do zrzutów użyto wyłącznie publicznych, przykładowych lokalizacji. Kalendarz pokazuje wybrany kwiecień 2027, co demonstruje planowanie i przejście między latami. Prognoza WeatherKit nie została sfabrykowana. Testy na fizycznym iPhonie, podpisana kompilacja dystrybucyjna, działanie produkcyjnego WeatherKit/StoreKit i wysłanie do App Store Connect pozostają osobnymi krokami.

## Zapis na GitHub

Kod i kolejne poprawki są wysyłane do `powerusa/Seedly`, gałąź `main`. Kopia tego pakietu znajduje się w `Release/3.0/AppStore/`. Generator nagłówka jest w `Release/3.0/Tools/render-header.swift`.
