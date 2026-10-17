# Changelog

## 3.0 — 2026-10-17

- Unify main screens, navigation destinations and forms with the green home gradient and a dark color scheme.
- Add manual city search and coordinate entry, persist the chosen location, retain coordinates when reverse geocoding fails, and handle denied location access.
- Apply the selected language to native date controls and right-to-left layout; add Polish translations for plant details and forms.
- Expand the offline catalog to 77 plants with bundled photos and credits for the 10 newly added images.
- Persist tasks, completion and recurrence; implement editable plant notes.
- Replace fabricated weather and fixed dashboard recommendations with actual data or an unavailable state.
- Fix calendar year navigation, frost-week dates, temperature units and custom-plant filters.
- Re-read active StoreKit entitlements on transaction updates, including revocations.

Validation: iOS Simulator build, regression checks in `Checks/run-regressions.sh`, catalog/image checks in `Checks/check-catalog.py`, and simulator checks of GPS, manual city selection and English/Polish language switching.

Known limitations: climate estimates still use simplified rules; full notification scheduling and multi-garden membership need implementation; several secondary strings fall back to English in languages other than Polish; WeatherKit and StoreKit require production-account testing. This update does not claim full App Store submission readiness.
