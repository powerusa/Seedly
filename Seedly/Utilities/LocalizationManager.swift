// LocalizationManager.swift
// Seedly

import SwiftUI
import Combine

@MainActor
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @AppStorage("selectedLanguage") var currentLanguage: String = "en" {
        didSet {
            objectWillChange.send()
        }
    }
    
    private init() {}
    
    // MARK: - Main UI Strings
    
    var todayInYourGarden: String {
        switch currentLanguage {
        case "pl": return "Dziś w Twoim ogrodzie"
        case "es": return "Hoy en tu jardín"
        case "de": return "Heute in Ihrem Garten"
        case "fr": return "Aujourd'hui dans votre jardin"
        case "it": return "Oggi nel tuo giardino"
        case "pt": return "Hoje no seu jardim"
        case "ja": return "今日のお庭"
        case "ko": return "오늘의 정원"
        case "zh": return "今日花园"
        case "ar": return "اليوم في حديقتك"
        case "uk": return "Сьогодні у вашому саду"
        case "ru": return "Сегодня в вашем саду"
        case "nl": return "Vandaag in je tuin"
        case "hi": return "आज आपके बगीचे में"
        default: return "Today in Your Garden"
        }
    }
    
    var todaysHighlights: String {
        switch currentLanguage {
        case "pl": return "Dzisiejsze informacje"
        case "es": return "Destacados de hoy"
        case "de": return "Heutige Highlights"
        case "fr": return "Points forts du jour"
        case "it": return "In evidenza oggi"
        case "pt": return "Destaques de hoje"
        case "ja": return "今日のハイライト"
        case "ko": return "오늘의 하이라이트"
        case "zh": return "今日亮点"
        case "ar": return "أبرز أحداث اليوم"
        case "uk": return "Сьогоднішні новини"
        case "ru": return "Сегодняшние новости"
        case "nl": return "Hoogtepunten van vandaag"
        case "hi": return "आज की मुख्य बातें"
        default: return "Today's Highlights"
        }
    }
    
    var comingUp: String {
        switch currentLanguage {
        case "pl": return "Nadchodzące"
        case "es": return "Próximamente"
        case "de": return "Demnächst"
        case "fr": return "À venir"
        case "it": return "In arrivo"
        case "pt": return "Em breve"
        case "ja": return "もうすぐ"
        case "ko": return "곧 다가오는"
        case "zh": return "即将到来"
        case "ar": return "قريباً"
        case "uk": return "Найближчим часом"
        case "ru": return "Скоро"
        case "nl": return "Binnenkort"
        case "hi": return "आगामी"
        default: return "Coming Up"
        }
    }
    
    var viewAll: String {
        switch currentLanguage {
        case "pl": return "Zobacz wszystko"
        case "es": return "Ver todo"
        case "de": return "Alle anzeigen"
        case "fr": return "Voir tout"
        case "it": return "Vedi tutto"
        case "pt": return "Ver tudo"
        case "ja": return "すべて見る"
        case "ko": return "모두 보기"
        case "zh": return "查看全部"
        case "ar": return "عرض الكل"
        case "uk": return "Показати все"
        case "ru": return "Показать все"
        case "nl": return "Alles bekijken"
        case "hi": return "सभी देखें"
        default: return "View all"
        }
    }
    
    var frostForecast: String {
        switch currentLanguage {
        case "pl": return "Prognoza"
        case "es": return "Pronóstico"
        case "de": return "Vorhersage"
        case "fr": return "Prévisions"
        case "it": return "Previsioni"
        case "pt": return "Previsão"
        case "ja": return "予報"
        case "ko": return "예보"
        case "zh": return "预报"
        case "ar": return "التوقعات"
        case "uk": return "Прогноз"
        case "ru": return "Прогноз"
        case "nl": return "Voorspelling"
        case "hi": return "पूर्वानुमान"
        default: return "Forecast"
        }
    }
    
    var rainTomorrow: String {
        switch currentLanguage {
        case "pl": return "Deszcz jutro"
        case "es": return "Lluvia mañana"
        case "de": return "Regen morgen"
        case "fr": return "Pluie demain"
        case "it": return "Pioggia domani"
        case "ja": return "明日は雨"
        default: return "Rain tomorrow"
        }
    }
    
    // MARK: - Insights
    
    var insightPlantingPerfect: String {
        switch currentLanguage {
        case "pl": return "Doskonały tydzień na sadzenie sałaty, szpinaku i marchewki."
        case "es": return "Semana perfecta para plantar lechuga, espinacas y zanahorias."
        case "de": return "Perfekte Woche zum Pflanzen von Salat, Spinat und Karotten."
        case "fr": return "Semaine parfaite pour planter laitue, épinards et carottes."
        case "ja": return "レタス、ほうれん草、にんじんを植えるのに最適な週です。"
        default: return "Perfect week to plant lettuce, spinach and carrots."
        }
    }
    
    var insightFrostRisk: String {
        switch currentLanguage {
        case "pl": return "Ryzyko przymrozku dziś w nocy."
        case "es": return "Riesgo de heladas esta noche."
        case "de": return "Frostgefahr heute Nacht."
        case "fr": return "Risque de gel cette nuit."
        case "ja": return "今夜霜の危険。"
        default: return "Frost risk tonight."
        }
    }
    
    var insightFrostSubtitle: String {
        switch currentLanguage {
        case "pl": return "Chroń wrażliwe rośliny."
        case "es": return "Protege las plantas sensibles."
        case "de": return "Empfindliche Pflanzen schützen."
        case "fr": return "Protégez les plantes sensibles."
        case "ja": return "繊細な植物を保護してください。"
        default: return "Protect sensitive plants."
        }
    }
    
    var insightRainExpected: String {
        switch currentLanguage {
        case "pl": return "Deszcz spodziewany jutro."
        case "es": return "Lluvia esperada mañana."
        case "de": return "Regen morgen erwartet."
        case "fr": return "Pluie attendue demain."
        case "ja": return "明日雨の予報。"
        default: return "Rain expected tomorrow."
        }
    }
    
    var insightRainSubtitle: String {
        switch currentLanguage {
        case "pl": return "Pomiń podlewanie."
        case "es": return "No riegues hoy."
        case "de": return "Heute nicht gießen."
        case "fr": return "Pas besoin d'arroser."
        case "ja": return "水やりは不要です。"
        default: return "Skip watering."
        }
    }
    
    var insightStartIndoors: String {
        switch currentLanguage {
        case "pl": return "Zacznij sadzić paprykę w domu w tym tygodniu."
        case "es": return "Empieza a sembrar pimientos en interior esta semana."
        case "de": return "Starten Sie Paprikasamen diese Woche drinnen."
        case "fr": return "Commencez les semis de poivrons à l'intérieur cette semaine."
        case "ja": return "今週からピーマンの室内栽培を始めましょう。"
        default: return "Start pepper seeds indoors this week."
        }
    }
    
    // MARK: - Plant Recommendations
    
    func safePlantIn(days: Int) -> String {
        switch currentLanguage {
        case "pl": return "Bezpiecznie sadzić za \(days) dni"
        case "es": return "Seguro para plantar en \(days) días"
        case "de": return "Sicher zu pflanzen in \(days) Tagen"
        case "fr": return "Plantation possible dans \(days) jours"
        case "ja": return "\(days)日後に植え付け可能"
        default: return "Safe to plant in \(days) days"
        }
    }
    
    var startIndoorsNow: String {
        switch currentLanguage {
        case "pl": return "Zacznij w domu teraz"
        case "es": return "Empezar en interior ahora"
        case "de": return "Jetzt drinnen starten"
        case "fr": return "Commencer à l'intérieur maintenant"
        case "ja": return "今すぐ室内で開始"
        default: return "Start indoors now"
        }
    }
    
    // MARK: - Tabs
    
    var tabToday: String {
        switch currentLanguage {
        case "pl": return "Dziś"
        case "es": return "Hoy"
        case "de": return "Heute"
        case "fr": return "Aujourd'hui"
        case "it": return "Oggi"
        case "ja": return "今日"
        case "ko": return "오늘"
        case "zh": return "今天"
        case "ar": return "اليوم"
        case "uk": return "Сьогодні"
        case "ru": return "Сегодня"
        default: return "Today"
        }
    }
    
    var tabCalendar: String {
        switch currentLanguage {
        case "pl": return "Kalendarz"
        case "es": return "Calendario"
        case "de": return "Kalender"
        case "fr": return "Calendrier"
        case "it": return "Calendario"
        case "ja": return "カレンダー"
        case "ko": return "캘린더"
        case "zh": return "日历"
        case "ar": return "التقويم"
        case "uk": return "Календар"
        case "ru": return "Календарь"
        default: return "Calendar"
        }
    }
    
    var tabPlants: String {
        switch currentLanguage {
        case "pl": return "Rośliny"
        case "es": return "Plantas"
        case "de": return "Pflanzen"
        case "fr": return "Plantes"
        case "it": return "Piante"
        case "ja": return "植物"
        case "ko": return "식물"
        case "zh": return "植物"
        case "ar": return "النباتات"
        case "uk": return "Рослини"
        case "ru": return "Растения"
        default: return "Plants"
        }
    }
    
    var tabTasks: String {
        switch currentLanguage {
        case "pl": return "Zadania"
        case "es": return "Tareas"
        case "de": return "Aufgaben"
        case "fr": return "Tâches"
        case "it": return "Compiti"
        case "ja": return "タスク"
        case "ko": return "작업"
        case "zh": return "任务"
        case "ar": return "المهام"
        case "uk": return "Завдання"
        case "ru": return "Задачи"
        default: return "Tasks"
        }
    }
    
    var tabMore: String {
        switch currentLanguage {
        case "pl": return "Więcej"
        case "es": return "Más"
        case "de": return "Mehr"
        case "fr": return "Plus"
        case "it": return "Altro"
        case "ja": return "その他"
        case "ko": return "더보기"
        case "zh": return "更多"
        case "ar": return "المزيد"
        case "uk": return "Більше"
        case "ru": return "Ещё"
        default: return "More"
        }
    }
    
    // MARK: - Tasks
    
    var tasks: String {
        switch currentLanguage {
        case "pl": return "Zadania"
        case "es": return "Tareas"
        case "de": return "Aufgaben"
        case "fr": return "Tâches"
        case "ja": return "タスク"
        default: return "Tasks"
        }
    }
    
    var allCaughtUp: String {
        switch currentLanguage {
        case "pl": return "Wszystko zrobione!"
        case "es": return "¡Todo al día!"
        case "de": return "Alles erledigt!"
        case "fr": return "Tout est fait !"
        case "ja": return "すべて完了！"
        default: return "All caught up!"
        }
    }
    
    // MARK: - Plants
    
    var plants: String {
        switch currentLanguage {
        case "pl": return "Rośliny"
        case "es": return "Plantas"
        case "de": return "Pflanzen"
        case "fr": return "Plantes"
        case "ja": return "植物"
        default: return "Plants"
        }
    }
    
    var allPlants: String {
        switch currentLanguage {
        case "pl": return "Wszystkie"
        case "es": return "Todas"
        case "de": return "Alle"
        case "fr": return "Toutes"
        case "ja": return "すべて"
        default: return "All Plants"
        }
    }
    
    var favorites: String {
        switch currentLanguage {
        case "pl": return "Ulubione"
        case "es": return "Favoritos"
        case "de": return "Favoriten"
        case "fr": return "Favoris"
        case "ja": return "お気に入り"
        default: return "Favorites"
        }
    }
    
    var addToFavorites: String {
        switch currentLanguage {
        case "pl": return "Dodaj do ulubionych"
        case "es": return "Añadir a favoritos"
        case "de": return "Zu Favoriten hinzufügen"
        case "fr": return "Ajouter aux favoris"
        case "it": return "Aggiungi ai preferiti"
        case "pt": return "Adicionar aos favoritos"
        case "nl": return "Toevoegen aan favorieten"
        case "ja": return "お気に入りに追加"
        case "ko": return "즐겨찾기에 추가"
        case "zh": return "添加到收藏"
        case "ar": return "أضف إلى المفضلة"
        case "hi": return "पसंदीदा में जोड़ें"
        case "uk": return "Додати до улюблених"
        case "ru": return "В избранное"
        default: return "Add to Favorites"
        }
    }
    
    var browsePlants: String {
        switch currentLanguage {
        case "pl": return "Przeglądaj rośliny"
        case "es": return "Explorar plantas"
        case "de": return "Pflanzen durchsuchen"
        case "fr": return "Parcourir les plantes"
        case "it": return "Sfoglia piante"
        case "pt": return "Explorar plantas"
        case "nl": return "Planten bekijken"
        case "ja": return "植物を見る"
        case "ko": return "식물 찾아보기"
        case "zh": return "浏览植物"
        case "ar": return "تصفح النباتات"
        case "hi": return "पौधे देखें"
        case "uk": return "Переглянути рослини"
        case "ru": return "Просмотр растений"
        default: return "Browse Plants"
        }
    }
    
    var removeFromFavorites: String {
        switch currentLanguage {
        case "pl": return "Usuń z ulubionych"
        case "es": return "Quitar de favoritos"
        case "de": return "Aus Favoriten entfernen"
        case "fr": return "Retirer des favoris"
        case "it": return "Rimuovi dai preferiti"
        case "pt": return "Remover dos favoritos"
        case "nl": return "Uit favorieten verwijderen"
        case "ja": return "お気に入りから削除"
        case "ko": return "즐겨찾기에서 제거"
        case "zh": return "从收藏中删除"
        case "ar": return "إزالة من المفضلة"
        case "hi": return "पसंदीदा से हटाएँ"
        case "uk": return "Видалити з улюблених"
        case "ru": return "Удалить из избранного"
        default: return "Remove from Favorites"
        }
    }
    
    // MARK: - Calendar
    
    var calendar: String {
        switch currentLanguage {
        case "pl": return "Kalendarz"
        case "es": return "Calendario"
        case "de": return "Kalender"
        case "fr": return "Calendrier"
        case "ja": return "カレンダー"
        default: return "Calendar"
        }
    }
    
    var whatToPlant: String {
        switch currentLanguage {
        case "pl": return "Co sadzić"
        case "es": return "Qué plantar"
        case "de": return "Was pflanzen"
        case "fr": return "Quoi planter"
        case "ja": return "何を植える"
        default: return "What to Plant"
        }
    }
    
    // MARK: - More / Settings
    
    var more: String {
        switch currentLanguage {
        case "pl": return "Więcej"
        case "es": return "Más"
        case "de": return "Mehr"
        case "fr": return "Plus"
        case "it": return "Altro"
        case "ja": return "その他"
        default: return "More"
        }
    }
    
    var settings: String {
        switch currentLanguage {
        case "pl": return "Ustawienia"
        case "es": return "Ajustes"
        case "de": return "Einstellungen"
        case "fr": return "Paramètres"
        case "it": return "Impostazioni"
        case "ja": return "設定"
        default: return "Settings"
        }
    }
    
    var myGardens: String {
        switch currentLanguage {
        case "pl": return "Moje ogrody"
        case "es": return "Mis jardines"
        case "de": return "Meine Gärten"
        case "fr": return "Mes jardins"
        case "it": return "I miei giardini"
        case "ja": return "マイガーデン"
        default: return "My Gardens"
        }
    }
    
    var location: String {
        switch currentLanguage {
        case "pl": return "Lokalizacja"
        case "es": return "Ubicación"
        case "de": return "Standort"
        case "fr": return "Localisation"
        case "it": return "Posizione"
        case "ja": return "位置情報"
        default: return "Location"
        }
    }
    
    var climateZone: String {
        switch currentLanguage {
        case "pl": return "Strefa klimatyczna"
        case "es": return "Zona climática"
        case "de": return "Klimazone"
        case "fr": return "Zone climatique"
        case "it": return "Zona climatica"
        case "ja": return "気候帯"
        default: return "Climate Zone"
        }
    }
    
    var preferences: String {
        switch currentLanguage {
        case "pl": return "Preferencje"
        case "es": return "Preferencias"
        case "de": return "Einstellungen"
        case "fr": return "Préférences"
        case "it": return "Preferenze"
        case "ja": return "設定"
        default: return "Preferences"
        }
    }
    
    var temperature: String {
        switch currentLanguage {
        case "pl": return "Temperatura"
        case "es": return "Temperatura"
        case "de": return "Temperatur"
        case "fr": return "Température"
        case "it": return "Temperatura"
        case "ja": return "温度"
        default: return "Temperature"
        }
    }
    
    var measurements: String {
        switch currentLanguage {
        case "pl": return "Jednostki"
        case "es": return "Medidas"
        case "de": return "Maßeinheiten"
        case "fr": return "Mesures"
        case "it": return "Misure"
        case "ja": return "単位"
        default: return "Measurements"
        }
    }
    
    var language: String {
        switch currentLanguage {
        case "pl": return "Język"
        case "es": return "Idioma"
        case "de": return "Sprache"
        case "fr": return "Langue"
        case "it": return "Lingua"
        case "ja": return "言語"
        default: return "Language"
        }
    }
    
    var notifications: String {
        switch currentLanguage {
        case "pl": return "Powiadomienia"
        case "es": return "Notificaciones"
        case "de": return "Benachrichtigungen"
        case "fr": return "Notifications"
        case "it": return "Notifiche"
        case "ja": return "通知"
        default: return "Notifications"
        }
    }
    
    var frostAlerts: String {
        switch currentLanguage {
        case "pl": return "Alerty mrozu"
        case "es": return "Alertas de heladas"
        case "de": return "Frostwarnungen"
        case "fr": return "Alertes gel"
        case "it": return "Avvisi gelo"
        case "ja": return "霜アラート"
        default: return "Frost Alerts"
        }
    }
    
    var aboutSeedly: String {
        switch currentLanguage {
        case "pl": return "O Simple Seeds"
        case "es": return "Acerca de Simple Seeds"
        case "de": return "Über Simple Seeds"
        case "fr": return "À propos de Simple Seeds"
        case "it": return "Informazioni su Simple Seeds"
        case "ja": return "Simple Seedsについて"
        default: return "About Simple Seeds"
        }
    }
    
    var garden: String {
        switch currentLanguage {
        case "pl": return "Ogród"
        case "es": return "Jardín"
        case "de": return "Garten"
        case "fr": return "Jardin"
        case "it": return "Giardino"
        case "ja": return "庭"
        default: return "Garden"
        }
    }
    
    var alerts: String {
        switch currentLanguage {
        case "pl": return "Alerty"
        case "es": return "Alertas"
        case "de": return "Warnungen"
        case "fr": return "Alertes"
        case "it": return "Avvisi"
        case "ja": return "アラート"
        default: return "Alerts"
        }
    }
    
    // MARK: - Notifications text
    
    var notifFrostTitle: String {
        switch currentLanguage {
        case "pl": return "⚠️ Uwaga na mróz!"
        case "es": return "⚠️ ¡Alerta de heladas!"
        case "de": return "⚠️ Frostwarnung!"
        case "fr": return "⚠️ Alerte gel !"
        case "ja": return "⚠️ 霜注意報！"
        default: return "⚠️ Frost Alert!"
        }
    }
    
    var notifFrostBody: String {
        switch currentLanguage {
        case "pl": return "Dziś w nocy spodziewany mróz. Chroń wrażliwe rośliny."
        case "es": return "Se esperan heladas esta noche. Protege las plantas sensibles."
        case "de": return "Heute Nacht wird Frost erwartet. Schützen Sie empfindliche Pflanzen."
        case "fr": return "Gel attendu cette nuit. Protégez les plantes sensibles."
        case "ja": return "今夜霜が予想されます。繊細な植物を保護してください。"
        default: return "Frost expected tonight. Protect sensitive plants."
        }
    }
    
    var notifWateringTitle: String {
        switch currentLanguage {
        case "pl": return "💧 Czas podlewania"
        case "es": return "💧 Hora de regar"
        case "de": return "💧 Zeit zum Gießen"
        case "fr": return "💧 Heure d'arrosage"
        case "ja": return "💧 水やりの時間"
        default: return "💧 Time to Water"
        }
    }
    
    var notifWateringBody: String {
        switch currentLanguage {
        case "pl": return "Twoje rośliny potrzebują wody. Sprawdź ogród."
        case "es": return "Tus plantas necesitan agua. Revisa tu jardín."
        case "de": return "Ihre Pflanzen brauchen Wasser. Überprüfen Sie Ihren Garten."
        case "fr": return "Vos plantes ont besoin d'eau. Vérifiez votre jardin."
        case "ja": return "植物に水が必要です。庭を確認してください。"
        default: return "Your plants need water. Check your garden."
        }
    }
    
    var notifPlantingTitle: String {
        switch currentLanguage {
        case "pl": return "🌱 Czas sadzenia!"
        case "es": return "🌱 ¡Hora de plantar!"
        case "de": return "🌱 Pflanzzeit!"
        case "fr": return "🌱 C'est l'heure de planter !"
        case "ja": return "🌱 植え付けの時間！"
        default: return "🌱 Planting Time!"
        }
    }
    
    // MARK: - Navigation Titles
    
    var myGarden: String {
        switch currentLanguage {
        case "pl": return "Mój ogród"
        case "es": return "Mi jardín"
        case "de": return "Mein Garten"
        case "fr": return "Mon jardin"
        case "it": return "Il mio giardino"
        case "ja": return "マイガーデン"
        default: return "My Garden"
        }
    }
    
    var searchPlants: String {
        switch currentLanguage {
        case "pl": return "Szukaj roślin..."
        case "es": return "Buscar plantas..."
        case "de": return "Pflanzen suchen..."
        case "fr": return "Rechercher des plantes..."
        case "it": return "Cerca piante..."
        case "ja": return "植物を検索..."
        default: return "Search plants..."
        }
    }
    
    var edit: String {
        switch currentLanguage {
        case "pl": return "Edytuj"
        case "es": return "Editar"
        case "de": return "Bearbeiten"
        case "fr": return "Modifier"
        case "it": return "Modifica"
        case "ja": return "編集"
        default: return "Edit"
        }
    }
    
    var today: String {
        switch currentLanguage {
        case "pl": return "Dziś"
        case "es": return "Hoy"
        case "de": return "Heute"
        case "fr": return "Aujourd'hui"
        case "ja": return "今日"
        default: return "Today"
        }
    }
    
    var upcoming: String {
        switch currentLanguage {
        case "pl": return "Nadchodzące"
        case "es": return "Próximos"
        case "de": return "Demnächst"
        case "fr": return "À venir"
        case "ja": return "今後"
        default: return "Upcoming"
        }
    }
    
    var completed: String {
        switch currentLanguage {
        case "pl": return "Ukończone"
        case "es": return "Completados"
        case "de": return "Erledigt"
        case "fr": return "Terminés"
        case "ja": return "完了"
        default: return "Completed"
        }
    }
    
    var excellent: String {
        switch currentLanguage {
        case "pl": return "Doskonale"
        case "es": return "Excelente"
        case "de": return "Ausgezeichnet"
        case "fr": return "Excellent"
        case "it": return "Eccellente"
        case "ja": return "最適"
        default: return "Excellent"
        }
    }
    
    var good: String {
        switch currentLanguage {
        case "pl": return "Dobrze"
        case "es": return "Bueno"
        case "de": return "Gut"
        case "fr": return "Bon"
        case "it": return "Buono"
        case "ja": return "良い"
        default: return "Good"
        }
    }
    
    var chooseLanguage: String {
        switch currentLanguage {
        case "pl": return "Wybierz język"
        case "es": return "Elige tu idioma"
        case "de": return "Sprache wählen"
        case "fr": return "Choisissez votre langue"
        case "ja": return "言語を選択"
        default: return "Choose Your Language"
        }
    }
}
