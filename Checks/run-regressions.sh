#!/bin/zsh
set -eu
cd "$(dirname "$0")/.."
mkdir -p ../work/checks
xcrun swiftc -parse-as-library -target arm64-apple-macosx15.0 \
    Seedly/Models/{Plant,ClimateZone,Garden,GardenTask,WeatherData,PlantGrowingGuide}.swift \
    Seedly/Services/{PlantDatabase,PlantDataExpansion,PlantDatabaseFull,PlantCatalogAdditions,PlantingEngine,ClimateEngine,LocationService}.swift \
    Seedly/Utilities/{PlantLocalization,PlantLocalizationFull,LocalizationManager}.swift \
    Seedly/ViewModels/{TasksViewModel,CalendarViewModel}.swift \
    Checks/RegressionChecks.swift -o ../work/checks/seedly-regressions
../work/checks/seedly-regressions
