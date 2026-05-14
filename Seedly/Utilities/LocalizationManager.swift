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
    
    // MARK: - Weather / Forecast
    
    /// Short weekday name (e.g. "Mon" / "Pon") for the given date in the selected language.
    func shortWeekday(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: currentLanguage)
        formatter.dateFormat = "EEE"
        let raw = formatter.string(from: date)
        return raw.prefix(1).localizedCapitalized + raw.dropFirst()
    }
    
    var tonight: String {
        switch currentLanguage {
        case "pl": return "Dziś wieczorem"; case "es": return "Esta noche"; case "de": return "Heute Abend"
        case "fr": return "Ce soir"; case "it": return "Stasera"; case "pt": return "Hoje à noite"
        case "nl": return "Vanavond"; case "ja": return "今夜"; case "ko": return "오늘 밤"
        case "zh": return "今晚"; case "ar": return "الليلة"; case "hi": return "आज रात"
        case "uk": return "Сьогодні ввечері"; case "ru": return "Сегодня вечером"; default: return "Tonight"
        }
    }
    
    var humidity: String {
        switch currentLanguage {
        case "pl": return "Wilgotność"; case "es": return "Humedad"; case "de": return "Feuchtigkeit"
        case "fr": return "Humidité"; case "it": return "Umidità"; case "pt": return "Humidade"
        case "nl": return "Vochtigheid"; case "ja": return "湿度"; case "ko": return "습도"
        case "zh": return "湿度"; case "ar": return "الرطوبة"; case "hi": return "नमी"
        case "uk": return "Вологість"; case "ru": return "Влажность"; default: return "Humidity"
        }
    }
    var wind: String {
        switch currentLanguage {
        case "pl": return "Wiatr"; case "es": return "Viento"; case "de": return "Wind"
        case "fr": return "Vent"; case "it": return "Vento"; case "pt": return "Vento"
        case "nl": return "Wind"; case "ja": return "風"; case "ko": return "바람"
        case "zh": return "风"; case "ar": return "الرياح"; case "hi": return "हवा"
        case "uk": return "Вітер"; case "ru": return "Ветер"; default: return "Wind"
        }
    }
    var uvIndex: String {
        switch currentLanguage {
        case "pl": return "UV"; case "es": return "UV"; case "de": return "UV"
        case "fr": return "UV"; case "it": return "UV"; case "pt": return "UV"
        case "nl": return "UV"; case "ja": return "UV"; case "ko": return "자외선"
        case "zh": return "紫外线"; case "ar": return "الأشعة"; case "hi": return "UV"
        case "uk": return "УФ"; case "ru": return "УФ"; default: return "UV"
        }
    }
    var rain: String {
        switch currentLanguage {
        case "pl": return "Deszcz"; case "es": return "Lluvia"; case "de": return "Regen"
        case "fr": return "Pluie"; case "it": return "Pioggia"; case "pt": return "Chuva"
        case "nl": return "Regen"; case "ja": return "雨"; case "ko": return "비"
        case "zh": return "雨"; case "ar": return "مطر"; case "hi": return "बारिश"
        case "uk": return "Дощ"; case "ru": return "Дождь"; default: return "Rain"
        }
    }
    var safePlantingMessage: String {
        switch currentLanguage {
        case "pl": return "Bezpieczne sadzenie w najbliższych dniach"
        case "es": return "Siembra segura en los próximos días"
        case "de": return "Sicheres Pflanzen in den nächsten Tagen"
        case "fr": return "Plantation sécurisée dans les jours à venir"
        case "it": return "Semina sicura nei prossimi giorni"
        case "pt": return "Plantio seguro nos próximos dias"
        case "nl": return "Veilig planten in de komende dagen"
        case "ja": return "今後数日間は安全に植え付け可能"
        case "ko": return "앞으로 며칠간 안전한 심기 가능"
        case "zh": return "未来几天可安全种植"
        case "ar": return "الزراعة آمنة في الأيام القادمة"
        case "hi": return "अगले कुछ दिनों में सुरक्षित रोपण"
        case "uk": return "Безпечна посадка найближчими днями"
        case "ru": return "Безопасная посадка в ближайшие дни"
        default: return "Safe planting in the coming days"
        }
    }
    
    var loading: String {
        switch currentLanguage {
        case "pl": return "Ładowanie..."; case "es": return "Cargando..."; case "de": return "Lädt..."
        case "fr": return "Chargement..."; case "it": return "Caricamento..."; case "pt": return "A carregar..."
        case "nl": return "Laden..."; case "ja": return "読み込み中..."; case "ko": return "로딩 중..."
        case "zh": return "加载中..."; case "ar": return "جارٍ التحميل..."; case "hi": return "लोड हो रहा है..."
        case "uk": return "Завантаження..."; case "ru": return "Загрузка..."; default: return "Loading..."
        }
    }
    
    // MARK: - Task Types
    
    func taskTypeName(_ type: TaskType) -> String {
        switch type {
        case .watering: return taskWatering
        case .fertilizing: return taskFertilizing
        case .pruning: return taskPruning
        case .harvesting: return taskHarvesting
        case .seedStarting: return taskSeedStarting
        case .transplanting: return taskTransplanting
        case .pestInspection: return taskPestInspection
        case .weeding: return taskWeeding
        case .mulching: return taskMulching
        case .soilTesting: return taskSoilTesting
        }
    }
    
    /// Verb form used when building dynamic titles like "Water Tomatoes".
    func taskVerb(_ type: TaskType) -> String {
        switch type {
        case .watering:
            switch currentLanguage {
            case "pl": return "Podlej"; case "es": return "Regar"; case "de": return "Bewässere"
            case "fr": return "Arroser"; case "it": return "Annaffia"; case "pt": return "Regar"
            case "nl": return "Besproei"; case "ja": return "水やり"; case "ko": return "물주기"
            case "zh": return "浇水"; case "ar": return "اسقِ"; case "hi": return "पानी दें"
            case "uk": return "Полий"; case "ru": return "Полей"; default: return "Water"
            }
        case .fertilizing:
            switch currentLanguage {
            case "pl": return "Nawoź"; case "es": return "Fertilizar"; case "de": return "Dünge"
            case "fr": return "Fertiliser"; case "it": return "Concima"; case "pt": return "Fertilizar"
            case "nl": return "Bemest"; case "ja": return "肥料"; case "ko": return "비료주기"
            case "zh": return "施肥"; case "ar": return "سمِّد"; case "hi": return "खाद दें"
            case "uk": return "Удобри"; case "ru": return "Удобри"; default: return "Fertilize"
            }
        case .pruning:
            switch currentLanguage {
            case "pl": return "Przytnij"; case "es": return "Podar"; case "de": return "Beschneide"
            case "fr": return "Tailler"; case "it": return "Pota"; case "pt": return "Podar"
            case "nl": return "Snoei"; case "ja": return "剪定"; case "ko": return "가지치기"
            case "zh": return "修剪"; case "ar": return "قلِّم"; case "hi": return "छंटाई करें"
            case "uk": return "Обріж"; case "ru": return "Обрежь"; default: return "Prune"
            }
        case .harvesting:
            switch currentLanguage {
            case "pl": return "Zbierz"; case "es": return "Cosechar"; case "de": return "Ernte"
            case "fr": return "Récolter"; case "it": return "Raccogli"; case "pt": return "Colher"
            case "nl": return "Oogst"; case "ja": return "収穫"; case "ko": return "수확"
            case "zh": return "收获"; case "ar": return "احصد"; case "hi": return "फसल काटें"
            case "uk": return "Збери"; case "ru": return "Собери"; default: return "Harvest"
            }
        case .seedStarting:
            switch currentLanguage {
            case "pl": return "Posiej"; case "es": return "Siembra"; case "de": return "Säe"
            case "fr": return "Semer"; case "it": return "Semina"; case "pt": return "Semear"
            case "nl": return "Zaai"; case "ja": return "種まき"; case "ko": return "씨앗 심기"
            case "zh": return "播种"; case "ar": return "ازرع"; case "hi": return "बीज बोएं"
            case "uk": return "Посій"; case "ru": return "Посей"; default: return "Start"
            }
        case .transplanting:
            switch currentLanguage {
            case "pl": return "Przesadź"; case "es": return "Trasplantar"; case "de": return "Pflanze um"
            case "fr": return "Transplanter"; case "it": return "Trapianta"; case "pt": return "Transplantar"
            case "nl": return "Verplant"; case "ja": return "植え替え"; case "ko": return "이식"
            case "zh": return "移植"; case "ar": return "انقل"; case "hi": return "प्रत्यारोपण"
            case "uk": return "Пересади"; case "ru": return "Пересади"; default: return "Transplant"
            }
        case .pestInspection:
            switch currentLanguage {
            case "pl": return "Sprawdź szkodniki"; case "es": return "Revisar plagas"; case "de": return "Schädlinge prüfen"
            case "fr": return "Vérifier les parasites"; case "it": return "Controlla parassiti"; case "pt": return "Verificar pragas"
            case "nl": return "Controleer op plagen"; case "ja": return "害虫チェック"; case "ko": return "해충 점검"
            case "zh": return "检查害虫"; case "ar": return "افحص الآفات"; case "hi": return "कीट जांच"
            case "uk": return "Перевір шкідників"; case "ru": return "Проверь вредителей"; default: return "Check for pests"
            }
        case .weeding:
            switch currentLanguage {
            case "pl": return "Wypiel chwasty"; case "es": return "Quitar malezas"; case "de": return "Jäte Unkraut"
            case "fr": return "Désherber"; case "it": return "Diserba"; case "pt": return "Tirar ervas daninhas"
            case "nl": return "Wied"; case "ja": return "雑草取り"; case "ko": return "잡초 제거"
            case "zh": return "除草"; case "ar": return "انزع الأعشاب"; case "hi": return "खरपतवार हटाएं"
            case "uk": return "Прополи"; case "ru": return "Пропалывай"; default: return "Weed"
            }
        case .mulching:
            switch currentLanguage {
            case "pl": return "Ściółkuj"; case "es": return "Colocar mantillo"; case "de": return "Mulche"
            case "fr": return "Pailler"; case "it": return "Pacciama"; case "pt": return "Cobrir com palha"
            case "nl": return "Mulch"; case "ja": return "マルチング"; case "ko": return "멀칭"
            case "zh": return "覆盖"; case "ar": return "غطِّ التربة"; case "hi": return "मल्च करें"
            case "uk": return "Замульчуй"; case "ru": return "Замульчируй"; default: return "Mulch"
            }
        case .soilTesting:
            switch currentLanguage {
            case "pl": return "Zbadaj glebę"; case "es": return "Probar suelo"; case "de": return "Boden testen"
            case "fr": return "Tester le sol"; case "it": return "Testa il terreno"; case "pt": return "Testar solo"
            case "nl": return "Grondtest"; case "ja": return "土壌検査"; case "ko": return "토양 검사"
            case "zh": return "土壤检测"; case "ar": return "افحص التربة"; case "hi": return "मिट्टी परीक्षण"
            case "uk": return "Перевір ґрунт"; case "ru": return "Проверь почву"; default: return "Test soil"
            }
        }
    }
    
    var taskWatering: String {
        switch currentLanguage {
        case "pl": return "Podlewanie"; case "es": return "Riego"; case "de": return "Bewässerung"
        case "fr": return "Arrosage"; case "it": return "Irrigazione"; case "pt": return "Rega"
        case "nl": return "Water geven"; case "ja": return "水やり"; case "ko": return "물주기"
        case "zh": return "浇水"; case "ar": return "الري"; case "hi": return "पानी देना"
        case "uk": return "Полив"; case "ru": return "Полив"; default: return "Watering"
        }
    }
    var taskFertilizing: String {
        switch currentLanguage {
        case "pl": return "Nawożenie"; case "es": return "Fertilización"; case "de": return "Düngung"
        case "fr": return "Fertilisation"; case "it": return "Concimazione"; case "pt": return "Fertilização"
        case "nl": return "Bemesten"; case "ja": return "施肥"; case "ko": return "비료주기"
        case "zh": return "施肥"; case "ar": return "التسميد"; case "hi": return "खाद देना"
        case "uk": return "Удобрення"; case "ru": return "Удобрение"; default: return "Fertilizing"
        }
    }
    var taskPruning: String {
        switch currentLanguage {
        case "pl": return "Przycinanie"; case "es": return "Poda"; case "de": return "Beschneiden"
        case "fr": return "Taille"; case "it": return "Potatura"; case "pt": return "Poda"
        case "nl": return "Snoeien"; case "ja": return "剪定"; case "ko": return "가지치기"
        case "zh": return "修剪"; case "ar": return "التقليم"; case "hi": return "छंटाई"
        case "uk": return "Обрізка"; case "ru": return "Обрезка"; default: return "Pruning"
        }
    }
    var taskHarvesting: String {
        switch currentLanguage {
        case "pl": return "Zbieranie"; case "es": return "Cosecha"; case "de": return "Ernte"
        case "fr": return "Récolte"; case "it": return "Raccolta"; case "pt": return "Colheita"
        case "nl": return "Oogsten"; case "ja": return "収穫"; case "ko": return "수확"
        case "zh": return "收获"; case "ar": return "الحصاد"; case "hi": return "फसल"
        case "uk": return "Збирання"; case "ru": return "Сбор урожая"; default: return "Harvesting"
        }
    }
    var taskSeedStarting: String {
        switch currentLanguage {
        case "pl": return "Siew"; case "es": return "Siembra"; case "de": return "Aussaat"
        case "fr": return "Semis"; case "it": return "Semina"; case "pt": return "Semeadura"
        case "nl": return "Zaaien"; case "ja": return "種まき"; case "ko": return "씨앗 심기"
        case "zh": return "播种"; case "ar": return "زرع البذور"; case "hi": return "बीज बोना"
        case "uk": return "Посів"; case "ru": return "Посев"; default: return "Seed Starting"
        }
    }
    var taskTransplanting: String {
        switch currentLanguage {
        case "pl": return "Przesadzanie"; case "es": return "Trasplante"; case "de": return "Umpflanzen"
        case "fr": return "Transplantation"; case "it": return "Trapianto"; case "pt": return "Transplante"
        case "nl": return "Verplanten"; case "ja": return "植え替え"; case "ko": return "이식"
        case "zh": return "移植"; case "ar": return "النقل"; case "hi": return "प्रत्यारोपण"
        case "uk": return "Пересадка"; case "ru": return "Пересадка"; default: return "Transplanting"
        }
    }
    var taskPestInspection: String {
        switch currentLanguage {
        case "pl": return "Kontrola szkodników"; case "es": return "Control de plagas"; case "de": return "Schädlingskontrolle"
        case "fr": return "Contrôle des parasites"; case "it": return "Controllo parassiti"; case "pt": return "Controle de pragas"
        case "nl": return "Plaagbeheersing"; case "ja": return "害虫検査"; case "ko": return "해충 점검"
        case "zh": return "害虫检查"; case "ar": return "فحص الآفات"; case "hi": return "कीट निरीक्षण"
        case "uk": return "Контроль шкідників"; case "ru": return "Контроль вредителей"; default: return "Pest Inspection"
        }
    }
    var taskWeeding: String {
        switch currentLanguage {
        case "pl": return "Pielenie"; case "es": return "Deshierbe"; case "de": return "Jäten"
        case "fr": return "Désherbage"; case "it": return "Diserbo"; case "pt": return "Capina"
        case "nl": return "Wieden"; case "ja": return "除草"; case "ko": return "잡초 제거"
        case "zh": return "除草"; case "ar": return "إزالة الأعشاب"; case "hi": return "खरपतवार"
        case "uk": return "Прополювання"; case "ru": return "Прополка"; default: return "Weeding"
        }
    }
    var taskMulching: String {
        switch currentLanguage {
        case "pl": return "Ściółkowanie"; case "es": return "Acolchado"; case "de": return "Mulchen"
        case "fr": return "Paillage"; case "it": return "Pacciamatura"; case "pt": return "Cobertura morta"
        case "nl": return "Mulchen"; case "ja": return "マルチング"; case "ko": return "멀칭"
        case "zh": return "覆盖"; case "ar": return "التغطية"; case "hi": return "मल्चिंग"
        case "uk": return "Мульчування"; case "ru": return "Мульчирование"; default: return "Mulching"
        }
    }
    var taskSoilTesting: String {
        switch currentLanguage {
        case "pl": return "Badanie gleby"; case "es": return "Prueba de suelo"; case "de": return "Bodentest"
        case "fr": return "Test du sol"; case "it": return "Test del suolo"; case "pt": return "Teste do solo"
        case "nl": return "Grondtest"; case "ja": return "土壌検査"; case "ko": return "토양 검사"
        case "zh": return "土壤检测"; case "ar": return "فحص التربة"; case "hi": return "मिट्टी परीक्षण"
        case "uk": return "Аналіз ґрунту"; case "ru": return "Анализ почвы"; default: return "Soil Testing"
        }
    }
    
    // MARK: - Tasks UI
    
    var noTasksInCategory: String {
        switch currentLanguage {
        case "pl": return "Brak zadań w tej kategorii. Dodaj nowe zadania ogrodowe, aby być na bieżąco."
        case "es": return "No hay tareas en esta categoría. Añade nuevas tareas de jardín para estar al día."
        case "de": return "Keine Aufgaben in dieser Kategorie. Füge neue Gartenaufgaben hinzu, um auf Kurs zu bleiben."
        case "fr": return "Aucune tâche dans cette catégorie. Ajoutez de nouvelles tâches pour rester organisé."
        case "it": return "Nessuna attività in questa categoria. Aggiungi nuove attività di giardinaggio per restare al passo."
        case "pt": return "Nenhuma tarefa nesta categoria. Adicione novas tarefas de jardim para se manter em dia."
        case "nl": return "Geen taken in deze categorie. Voeg nieuwe tuintaken toe om bij te blijven."
        case "ja": return "このカテゴリにタスクはありません。新しい園芸タスクを追加しましょう。"
        case "ko": return "이 카테고리에 작업이 없습니다. 새 정원 작업을 추가하세요."
        case "zh": return "此类别中没有任务。添加新的园艺任务以保持进度。"
        case "ar": return "لا توجد مهام في هذه الفئة. أضف مهام جديدة للبستنة للبقاء على المسار."
        case "hi": return "इस श्रेणी में कोई कार्य नहीं है। ट्रैक पर रहने के लिए नए बागवानी कार्य जोड़ें।"
        case "uk": return "Немає завдань у цій категорії. Додайте нові садові завдання."
        case "ru": return "В этой категории нет задач. Добавьте новые садовые задачи."
        default: return "No tasks in this category. Add new gardening tasks to stay on track."
        }
    }
    
    var newTask: String {
        switch currentLanguage {
        case "pl": return "Nowe zadanie"; case "es": return "Nueva tarea"; case "de": return "Neue Aufgabe"
        case "fr": return "Nouvelle tâche"; case "it": return "Nuova attività"; case "pt": return "Nova tarefa"
        case "nl": return "Nieuwe taak"; case "ja": return "新しいタスク"; case "ko": return "새 작업"
        case "zh": return "新任务"; case "ar": return "مهمة جديدة"; case "hi": return "नया कार्य"
        case "uk": return "Нове завдання"; case "ru": return "Новая задача"; default: return "New Task"
        }
    }
    var taskDetails: String {
        switch currentLanguage {
        case "pl": return "Szczegóły zadania"; case "es": return "Detalles de la tarea"; case "de": return "Aufgabendetails"
        case "fr": return "Détails de la tâche"; case "it": return "Dettagli attività"; case "pt": return "Detalhes da tarefa"
        case "nl": return "Taakdetails"; case "ja": return "タスクの詳細"; case "ko": return "작업 세부정보"
        case "zh": return "任务详情"; case "ar": return "تفاصيل المهمة"; case "hi": return "कार्य विवरण"
        case "uk": return "Деталі завдання"; case "ru": return "Детали задачи"; default: return "Task Details"
        }
    }
    var taskNameField: String {
        switch currentLanguage {
        case "pl": return "Nazwa zadania"; case "es": return "Nombre de la tarea"; case "de": return "Aufgabenname"
        case "fr": return "Nom de la tâche"; case "it": return "Nome attività"; case "pt": return "Nome da tarefa"
        case "nl": return "Taaknaam"; case "ja": return "タスク名"; case "ko": return "작업 이름"
        case "zh": return "任务名称"; case "ar": return "اسم المهمة"; case "hi": return "कार्य नाम"
        case "uk": return "Назва завдання"; case "ru": return "Название задачи"; default: return "Task name"
        }
    }
    var taskTypeField: String {
        switch currentLanguage {
        case "pl": return "Typ"; case "es": return "Tipo"; case "de": return "Typ"
        case "fr": return "Type"; case "it": return "Tipo"; case "pt": return "Tipo"
        case "nl": return "Type"; case "ja": return "種類"; case "ko": return "유형"
        case "zh": return "类型"; case "ar": return "النوع"; case "hi": return "प्रकार"
        case "uk": return "Тип"; case "ru": return "Тип"; default: return "Type"
        }
    }
    var dueDate: String {
        switch currentLanguage {
        case "pl": return "Termin"; case "es": return "Fecha límite"; case "de": return "Fällig am"
        case "fr": return "Échéance"; case "it": return "Scadenza"; case "pt": return "Data de vencimento"
        case "nl": return "Vervaldatum"; case "ja": return "期限"; case "ko": return "기한"
        case "zh": return "截止日期"; case "ar": return "تاريخ الاستحقاق"; case "hi": return "नियत तिथि"
        case "uk": return "Термін"; case "ru": return "Срок"; default: return "Due Date"
        }
    }
    var dueTime: String {
        switch currentLanguage {
        case "pl": return "Godzina"; case "es": return "Hora"; case "de": return "Uhrzeit"
        case "fr": return "Heure"; case "it": return "Ora"; case "pt": return "Hora"
        case "nl": return "Tijd"; case "ja": return "時刻"; case "ko": return "시간"
        case "zh": return "时间"; case "ar": return "الوقت"; case "hi": return "समय"
        case "uk": return "Час"; case "ru": return "Время"; default: return "Time"
        }
    }
    var recurring: String {
        switch currentLanguage {
        case "pl": return "Powtarzające się"; case "es": return "Recurrente"; case "de": return "Wiederkehrend"
        case "fr": return "Récurrent"; case "it": return "Ricorrente"; case "pt": return "Recorrente"
        case "nl": return "Terugkerend"; case "ja": return "繰り返し"; case "ko": return "반복"
        case "zh": return "重复"; case "ar": return "متكرر"; case "hi": return "आवर्ती"
        case "uk": return "Повторюване"; case "ru": return "Повторяющееся"; default: return "Recurring"
        }
    }
    var cancel: String {
        switch currentLanguage {
        case "pl": return "Anuluj"; case "es": return "Cancelar"; case "de": return "Abbrechen"
        case "fr": return "Annuler"; case "it": return "Annulla"; case "pt": return "Cancelar"
        case "nl": return "Annuleer"; case "ja": return "キャンセル"; case "ko": return "취소"
        case "zh": return "取消"; case "ar": return "إلغاء"; case "hi": return "रद्द करें"
        case "uk": return "Скасувати"; case "ru": return "Отмена"; default: return "Cancel"
        }
    }
    var add: String {
        switch currentLanguage {
        case "pl": return "Dodaj"; case "es": return "Añadir"; case "de": return "Hinzufügen"
        case "fr": return "Ajouter"; case "it": return "Aggiungi"; case "pt": return "Adicionar"
        case "nl": return "Voeg toe"; case "ja": return "追加"; case "ko": return "추가"
        case "zh": return "添加"; case "ar": return "إضافة"; case "hi": return "जोड़ें"
        case "uk": return "Додати"; case "ru": return "Добавить"; default: return "Add"
        }
    }
    
    // MARK: - Plant Categories
    
    func categoryName(_ category: PlantCategory) -> String {
        switch category {
        case .vegetable: return categoryVegetable
        case .fruit: return categoryFruit
        case .herb: return categoryHerb
        case .flower: return categoryFlower
        case .berry: return categoryBerry
        case .tree: return categoryTree
        case .tropical: return categoryTropical
        case .greenhouse: return categoryGreenhouse
        }
    }
    
    var categoryAll: String {
        switch currentLanguage {
        case "pl": return "Wszystkie"
        case "es": return "Todas"
        case "de": return "Alle"
        case "fr": return "Toutes"
        case "it": return "Tutte"
        case "pt": return "Todas"
        case "nl": return "Alle"
        case "ja": return "すべて"
        case "ko": return "전체"
        case "zh": return "全部"
        case "ar": return "الكل"
        case "hi": return "सभी"
        case "uk": return "Усі"
        case "ru": return "Все"
        default: return "All"
        }
    }
    
    var categoryVegetable: String {
        switch currentLanguage {
        case "pl": return "Warzywa"
        case "es": return "Verduras"
        case "de": return "Gemüse"
        case "fr": return "Légumes"
        case "it": return "Verdure"
        case "pt": return "Vegetais"
        case "nl": return "Groenten"
        case "ja": return "野菜"
        case "ko": return "채소"
        case "zh": return "蔬菜"
        case "ar": return "خضروات"
        case "hi": return "सब्जियाँ"
        case "uk": return "Овочі"
        case "ru": return "Овощи"
        default: return "Vegetable"
        }
    }
    
    var categoryFruit: String {
        switch currentLanguage {
        case "pl": return "Owoce"
        case "es": return "Frutas"
        case "de": return "Obst"
        case "fr": return "Fruits"
        case "it": return "Frutta"
        case "pt": return "Frutas"
        case "nl": return "Fruit"
        case "ja": return "果物"
        case "ko": return "과일"
        case "zh": return "水果"
        case "ar": return "فواكه"
        case "hi": return "फल"
        case "uk": return "Фрукти"
        case "ru": return "Фрукты"
        default: return "Fruit"
        }
    }
    
    var categoryHerb: String {
        switch currentLanguage {
        case "pl": return "Zioła"
        case "es": return "Hierbas"
        case "de": return "Kräuter"
        case "fr": return "Herbes"
        case "it": return "Erbe"
        case "pt": return "Ervas"
        case "nl": return "Kruiden"
        case "ja": return "ハーブ"
        case "ko": return "허브"
        case "zh": return "香草"
        case "ar": return "أعشاب"
        case "hi": return "जड़ी-बूटियाँ"
        case "uk": return "Трави"
        case "ru": return "Травы"
        default: return "Herb"
        }
    }
    
    var categoryFlower: String {
        switch currentLanguage {
        case "pl": return "Kwiaty"
        case "es": return "Flores"
        case "de": return "Blumen"
        case "fr": return "Fleurs"
        case "it": return "Fiori"
        case "pt": return "Flores"
        case "nl": return "Bloemen"
        case "ja": return "花"
        case "ko": return "꽃"
        case "zh": return "花卉"
        case "ar": return "زهور"
        case "hi": return "फूल"
        case "uk": return "Квіти"
        case "ru": return "Цветы"
        default: return "Flower"
        }
    }
    
    var categoryBerry: String {
        switch currentLanguage {
        case "pl": return "Jagody"
        case "es": return "Bayas"
        case "de": return "Beeren"
        case "fr": return "Baies"
        case "it": return "Bacche"
        case "pt": return "Frutos vermelhos"
        case "nl": return "Bessen"
        case "ja": return "ベリー"
        case "ko": return "베리"
        case "zh": return "浆果"
        case "ar": return "توت"
        case "hi": return "बेरी"
        case "uk": return "Ягоди"
        case "ru": return "Ягоды"
        default: return "Berry"
        }
    }
    
    var categoryTree: String {
        switch currentLanguage {
        case "pl": return "Drzewa"
        case "es": return "Árboles"
        case "de": return "Bäume"
        case "fr": return "Arbres"
        case "it": return "Alberi"
        case "pt": return "Árvores"
        case "nl": return "Bomen"
        case "ja": return "木"
        case "ko": return "나무"
        case "zh": return "树木"
        case "ar": return "أشجار"
        case "hi": return "पेड़"
        case "uk": return "Дерева"
        case "ru": return "Деревья"
        default: return "Tree"
        }
    }
    
    var categoryTropical: String {
        switch currentLanguage {
        case "pl": return "Tropikalne"
        case "es": return "Tropicales"
        case "de": return "Tropisch"
        case "fr": return "Tropicales"
        case "it": return "Tropicali"
        case "pt": return "Tropicais"
        case "nl": return "Tropisch"
        case "ja": return "熱帯"
        case "ko": return "열대"
        case "zh": return "热带"
        case "ar": return "استوائي"
        case "hi": return "उष्णकटिबंधीय"
        case "uk": return "Тропічні"
        case "ru": return "Тропические"
        default: return "Tropical"
        }
    }
    
    var categoryGreenhouse: String {
        switch currentLanguage {
        case "pl": return "Szklarnia"
        case "es": return "Invernadero"
        case "de": return "Gewächshaus"
        case "fr": return "Serre"
        case "it": return "Serra"
        case "pt": return "Estufa"
        case "nl": return "Kas"
        case "ja": return "温室"
        case "ko": return "온실"
        case "zh": return "温室"
        case "ar": return "دفيئة"
        case "hi": return "ग्रीनहाउस"
        case "uk": return "Теплиця"
        case "ru": return "Теплица"
        default: return "Greenhouse"
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
    
    // MARK: - Notifications & Buttons
    
    var done: String {
        switch currentLanguage {
        case "pl": return "Gotowe"; case "es": return "Listo"; case "de": return "Fertig"
        case "fr": return "Terminé"; case "it": return "Fatto"; case "pt": return "Concluído"
        case "nl": return "Klaar"; case "ja": return "完了"; case "ko": return "완료"
        case "zh": return "完成"; case "ar": return "تم"; case "hi": return "हो गया"
        case "uk": return "Готово"; case "ru": return "Готово"; default: return "Done"
        }
    }
    
    var weatherAlerts: String {
        switch currentLanguage {
        case "pl": return "Alerty pogodowe"; case "es": return "Alertas meteorológicas"; case "de": return "Wetterwarnungen"
        case "fr": return "Alertes météo"; case "it": return "Avvisi meteo"; case "pt": return "Alertas meteorológicos"
        case "nl": return "Weerwaarschuwingen"; case "ja": return "天気アラート"; case "ko": return "날씨 알림"
        case "zh": return "天气警报"; case "ar": return "تنبيهات الطقس"; case "hi": return "मौसम अलर्ट"
        case "uk": return "Сповіщення про погоду"; case "ru": return "Погодные оповещения"; default: return "Weather Alerts"
        }
    }
    
    var heatAlerts: String {
        switch currentLanguage {
        case "pl": return "Alerty upału"; case "es": return "Alertas de calor"; case "de": return "Hitzewarnungen"
        case "fr": return "Alertes chaleur"; case "it": return "Avvisi caldo"; case "pt": return "Alertas de calor"
        case "nl": return "Hittewaarschuwingen"; case "ja": return "暑さアラート"; case "ko": return "더위 알림"
        case "zh": return "高温警报"; case "ar": return "تنبيهات الحرارة"; case "hi": return "गर्मी अलर्ट"
        case "uk": return "Сповіщення про спеку"; case "ru": return "Оповещения о жаре"; default: return "Heat Alerts"
        }
    }
    
    var severeWeather: String {
        switch currentLanguage {
        case "pl": return "Niebezpieczna pogoda"; case "es": return "Clima severo"; case "de": return "Unwetter"
        case "fr": return "Météo dangereuse"; case "it": return "Maltempo"; case "pt": return "Clima severo"
        case "nl": return "Onweer"; case "ja": return "悪天候"; case "ko": return "악천후"
        case "zh": return "恶劣天气"; case "ar": return "طقس قاسي"; case "hi": return "गंभीर मौसम"
        case "uk": return "Небезпечна погода"; case "ru": return "Опасная погода"; default: return "Severe Weather"
        }
    }
    
    var reminders: String {
        switch currentLanguage {
        case "pl": return "Przypomnienia"; case "es": return "Recordatorios"; case "de": return "Erinnerungen"
        case "fr": return "Rappels"; case "it": return "Promemoria"; case "pt": return "Lembretes"
        case "nl": return "Herinneringen"; case "ja": return "リマインダー"; case "ko": return "알림"
        case "zh": return "提醒"; case "ar": return "تذكيرات"; case "hi": return "अनुस्मारक"
        case "uk": return "Нагадування"; case "ru": return "Напоминания"; default: return "Reminders"
        }
    }
    
    var wateringReminders: String {
        switch currentLanguage {
        case "pl": return "Podlewanie"; case "es": return "Riego"; case "de": return "Bewässerung"
        case "fr": return "Arrosage"; case "it": return "Irrigazione"; case "pt": return "Rega"
        case "nl": return "Water geven"; case "ja": return "水やり"; case "ko": return "물주기"
        case "zh": return "浇水提醒"; case "ar": return "تذكير الري"; case "hi": return "पानी देना"
        case "uk": return "Полив"; case "ru": return "Полив"; default: return "Watering Reminders"
        }
    }
    
    var plantingReminders: String {
        switch currentLanguage {
        case "pl": return "Sadzenie"; case "es": return "Siembra"; case "de": return "Pflanzen"
        case "fr": return "Plantation"; case "it": return "Semina"; case "pt": return "Plantio"
        case "nl": return "Planten"; case "ja": return "植え付け"; case "ko": return "심기"
        case "zh": return "种植提醒"; case "ar": return "تذكير الزراعة"; case "hi": return "रोपण"
        case "uk": return "Посадка"; case "ru": return "Посадка"; default: return "Planting Reminders"
        }
    }
    
    var harvestReminders: String {
        switch currentLanguage {
        case "pl": return "Zbiory"; case "es": return "Cosecha"; case "de": return "Ernte"
        case "fr": return "Récolte"; case "it": return "Raccolta"; case "pt": return "Colheita"
        case "nl": return "Oogst"; case "ja": return "収穫"; case "ko": return "수확"
        case "zh": return "收获提醒"; case "ar": return "تذكير الحصاد"; case "hi": return "फसल"
        case "uk": return "Збір врожаю"; case "ru": return "Сбор урожая"; default: return "Harvest Reminders"
        }
    }
    
    var reminderTime: String {
        switch currentLanguage {
        case "pl": return "Godzina przypomnień"; case "es": return "Hora del recordatorio"; case "de": return "Erinnerungszeit"
        case "fr": return "Heure de rappel"; case "it": return "Ora promemoria"; case "pt": return "Hora do lembrete"
        case "nl": return "Herinneringstijd"; case "ja": return "リマインダー時刻"; case "ko": return "알림 시간"
        case "zh": return "提醒时间"; case "ar": return "وقت التذكير"; case "hi": return "अनुस्मारक समय"
        case "uk": return "Час нагадування"; case "ru": return "Время напоминания"; default: return "Reminder Time"
        }
    }
    
    // MARK: - About / Privacy / Acknowledgments
    
    var privacyPolicy: String {
        switch currentLanguage {
        case "pl": return "Polityka prywatności"
        case "es": return "Política de privacidad"
        case "de": return "Datenschutzerklärung"
        case "fr": return "Politique de confidentialité"
        case "it": return "Informativa sulla privacy"
        case "pt": return "Política de privacidade"
        case "nl": return "Privacybeleid"
        case "ja": return "プライバシーポリシー"
        case "ko": return "개인정보 처리방침"
        case "zh": return "隐私政策"
        case "ar": return "سياسة الخصوصية"
        case "hi": return "गोपनीयता नीति"
        case "uk": return "Політика конфіденційності"
        case "ru": return "Политика конфиденциальности"
        default: return "Privacy Policy"
        }
    }
    
    var acknowledgments: String {
        switch currentLanguage {
        case "pl": return "Podziękowania"
        case "es": return "Agradecimientos"
        case "de": return "Danksagungen"
        case "fr": return "Remerciements"
        case "it": return "Ringraziamenti"
        case "pt": return "Agradecimentos"
        case "nl": return "Dankbetuigingen"
        case "ja": return "謝辞"
        case "ko": return "감사의 글"
        case "zh": return "致谢"
        case "ar": return "شكر وتقدير"
        case "hi": return "आभार"
        case "uk": return "Подяки"
        case "ru": return "Благодарности"
        default: return "Acknowledgments"
        }
    }
    
    var appTagline: String {
        switch currentLanguage {
        case "pl": return "Kup raz. Uprawiaj wiecznie."
        case "es": return "Compra una vez. Cultiva para siempre."
        case "de": return "Einmal kaufen. Ewig gärtnern."
        case "fr": return "Achetez une fois. Jardinez pour toujours."
        case "it": return "Acquista una volta. Coltiva per sempre."
        case "pt": return "Compre uma vez. Cultive para sempre."
        case "nl": return "Eenmaal kopen. Voor altijd tuinieren."
        case "ja": return "一度購入すれば、ずっとガーデニング。"
        case "ko": return "한 번 구매로 평생 정원 가꾸기."
        case "zh": return "一次购买，永久园艺。"
        case "ar": return "اشترِ مرة واحدة. ازرع للأبد."
        case "hi": return "एक बार खरीदें। हमेशा बागवानी करें।"
        case "uk": return "Купи раз. Сади вічно."
        case "ru": return "Купи раз. Садоводствуй вечно."
        default: return "Buy once. Garden forever."
        }
    }
    
    var appDescription: String {
        switch currentLanguage {
        case "pl": return "Simple Seeds to Twój osobisty asystent ogrodniczy. Otrzymuj spersonalizowane kalendarze sadzenia, ostrzeżenia o przymrozkach, prognozy pogody dla ogrodu i przypomnienia o zadaniach — wszystko dopasowane do Twojej strefy klimatycznej i wybranych roślin."
        case "de": return "Simple Seeds ist Ihr persönlicher Gartenassistent. Erhalten Sie personalisierte Pflanzkalender, Frostwarnungen, Wettervorhersagen für den Garten und Aufgabenerinnerungen — alles abgestimmt auf Ihre Klimazone und Pflanzen."
        case "fr": return "Simple Seeds est votre assistant de jardin personnel. Recevez des calendriers de plantation personnalisés, des alertes de gel, des prévisions météo pour le jardin et des rappels de tâches — tout adapté à votre zone climatique et à vos plantes."
        case "es": return "Simple Seeds es tu asistente personal de jardinería. Recibe calendarios de plantación personalizados, alertas de heladas, pronósticos meteorológicos para el jardín y recordatorios de tareas, todo adaptado a tu zona climática y tus plantas."
        case "it": return "Simple Seeds è il tuo assistente personale per il giardino. Ricevi calendari di semina personalizzati, allerte gelo, previsioni meteo per il giardino e promemoria delle attività, tutto adattato alla tua zona climatica e alle tue piante."
        case "uk": return "Simple Seeds — це ваш персональний помічник садівника. Отримуйте персоналізовані календарі посадки, оповіщення про заморозки, прогнози погоди для саду та нагадування про завдання — усе адаптоване до вашої кліматичної зони та рослин."
        case "ru": return "Simple Seeds — ваш персональный садовый помощник. Получайте персонализированные календари посадки, оповещения о заморозках, прогнозы погоды для сада и напоминания о задачах — всё подобрано под вашу климатическую зону и растения."
        default: return "Simple Seeds is your personal gardening assistant. Get personalized planting calendars, frost alerts, garden weather forecasts, and task reminders — all tailored to your climate zone and chosen plants."
        }
    }
    
    var privacyPolicyContent: String {
        switch currentLanguage {
        case "pl": return """
Simple Seeds szanuje Twoją prywatność.

Dane lokalizacji
Używamy Twojej lokalizacji wyłącznie do obliczania prognozy pogody, dat przymrozków i kalendarza sadzenia. Dane lokalizacji są przetwarzane lokalnie na Twoim urządzeniu i nie są przesyłane na nasze serwery.

Brak konta
Aplikacja nie wymaga rejestracji ani konta użytkownika. Wszystkie ustawienia, ogrody i zadania są przechowywane lokalnie na Twoim urządzeniu.

Brak śledzenia
Nie używamy narzędzi analitycznych ani reklamowych. Nie udostępniamy Twoich danych żadnym stronom trzecim.

Powiadomienia
Powiadomienia o przymrozkach, podlewaniu i zbiorach są generowane lokalnie na Twoim urządzeniu na podstawie Twoich ustawień.

Kontakt
Pytania dotyczące prywatności? Napisz do nas: powersatellite@yahoo.com
"""
        default: return """
Simple Seeds respects your privacy.

Location Data
We use your location solely to compute weather forecasts, frost dates, and planting calendars. Location data is processed locally on your device and is not transmitted to our servers.

No Account
The app does not require registration or a user account. All your settings, gardens, and tasks are stored locally on your device.

No Tracking
We use no analytics or advertising tools. We do not share your data with any third parties.

Notifications
Frost, watering, and harvest notifications are generated locally on your device based on your settings.

Contact
Questions about privacy? Email us: powersatellite@yahoo.com
"""
        }
    }
    
    var acknowledgmentsContent: String {
        switch currentLanguage {
        case "pl": return """
Dziękujemy społeczności open source.

Apple
• SwiftUI, SwiftData, MapKit, Core Location, WeatherKit
• SF Symbols — biblioteka ikon

Dane klimatyczne
• Klasyfikacja klimatu Köppen-Geigera
• Strefy mrozoodporności USDA
• Pogoda Open-Meteo (open-meteo.com)

Baza roślin
Informacje agronomiczne pochodzą z publicznie dostępnych źródeł rolniczych, w tym uniwersyteckich stacji rolniczych i open-source ogrodniczych baz wiedzy.

Tłumaczenia
Tłumaczenia społecznościowe na 15 języków.

Specjalne podziękowania
Dla każdego ogrodnika, który dzieli się swoją pasją.
"""
        default: return """
Thanks to the open source community.

Apple
• SwiftUI, SwiftData, MapKit, Core Location, WeatherKit
• SF Symbols — icon library

Climate Data
• Köppen–Geiger climate classification
• USDA Hardiness Zones
• Open-Meteo weather (open-meteo.com)

Plant Database
Agronomic information sourced from publicly available agricultural references, including university extension services and open-source gardening knowledge bases.

Translations
Community translations into 15 languages.

Special Thanks
To every gardener who shares their passion.
"""
        }
    }
    
    var version: String {
        switch currentLanguage {
        case "pl": return "Wersja"
        case "es": return "Versión"
        case "de": return "Version"
        case "fr": return "Version"
        case "it": return "Versione"
        case "pt": return "Versão"
        case "nl": return "Versie"
        case "ja": return "バージョン"
        case "ko": return "버전"
        case "zh": return "版本"
        case "ar": return "الإصدار"
        case "hi": return "संस्करण"
        case "uk": return "Версія"
        case "ru": return "Версия"
        default: return "Version"
        }
    }
    
    var refreshLocation: String {
        switch currentLanguage {
        case "pl": return "Odśwież lokalizację"
        case "de": return "Standort aktualisieren"
        case "fr": return "Actualiser la position"
        case "es": return "Actualizar ubicación"
        case "it": return "Aggiorna posizione"
        case "uk": return "Оновити місцезнаходження"
        case "ru": return "Обновить местоположение"
        default: return "Refresh Location"
        }
    }
    
    var latitude: String {
        switch currentLanguage {
        case "pl": return "Szerokość geograficzna"
        case "de": return "Breitengrad"
        case "fr": return "Latitude"
        case "es": return "Latitud"
        case "it": return "Latitudine"
        case "uk": return "Широта"
        case "ru": return "Широта"
        default: return "Latitude"
        }
    }
    
    var longitude: String {
        switch currentLanguage {
        case "pl": return "Długość geograficzna"
        case "de": return "Längengrad"
        case "fr": return "Longitude"
        case "es": return "Longitud"
        case "it": return "Longitudine"
        case "uk": return "Довгота"
        case "ru": return "Долгота"
        default: return "Longitude"
        }
    }
    
    var locationNotAvailable: String {
        switch currentLanguage {
        case "pl": return "Lokalizacja niedostępna"
        case "de": return "Standort nicht verfügbar"
        case "fr": return "Position non disponible"
        case "es": return "Ubicación no disponible"
        case "it": return "Posizione non disponibile"
        case "uk": return "Місцезнаходження недоступне"
        case "ru": return "Местоположение недоступно"
        default: return "Location not available"
        }
    }
    
    var locationDescription: String {
        switch currentLanguage {
        case "pl": return "Twoja lokalizacja jest używana do obliczenia kalendarza sadzenia, dat przymrozków i prognoz pogody. Dane nigdy nie opuszczają Twojego urządzenia."
        case "de": return "Ihr Standort wird zur Berechnung von Pflanzkalender, Frostdaten und Wettervorhersagen verwendet. Daten verlassen niemals Ihr Gerät."
        case "fr": return "Votre position est utilisée pour calculer le calendrier de plantation, les dates de gel et les prévisions météo. Les données ne quittent jamais votre appareil."
        case "es": return "Tu ubicación se usa para calcular el calendario de siembra, las fechas de heladas y los pronósticos meteorológicos. Los datos nunca salen de tu dispositivo."
        case "it": return "La tua posizione viene usata per calcolare il calendario di semina, le date di gelo e le previsioni meteo. I dati non lasciano mai il tuo dispositivo."
        case "uk": return "Ваше місцезнаходження використовується для розрахунку календаря посадки, дат заморозків і прогнозів погоди. Дані ніколи не залишають ваш пристрій."
        case "ru": return "Ваше местоположение используется для расчёта календаря посадки, дат заморозков и прогнозов погоды. Данные никогда не покидают ваше устройство."
        default: return "Your location is used to calculate the planting calendar, frost dates, and weather forecasts. Data never leaves your device."
        }
    }
    
    var growingSeason: String {
        switch currentLanguage {
        case "pl": return "Sezon wegetacyjny"
        case "de": return "Vegetationsperiode"
        case "fr": return "Saison de croissance"
        case "es": return "Temporada de cultivo"
        case "it": return "Stagione di crescita"
        case "uk": return "Вегетаційний період"
        case "ru": return "Вегетационный период"
        default: return "Growing Season"
        }
    }
    
    var weeks: String {
        switch currentLanguage {
        case "pl": return "tygodni"
        case "de": return "Wochen"
        case "fr": return "semaines"
        case "es": return "semanas"
        case "it": return "settimane"
        case "uk": return "тижнів"
        case "ru": return "недель"
        default: return "weeks"
        }
    }
    
    var firstFrost: String {
        switch currentLanguage {
        case "pl": return "Pierwszy przymrozek"
        case "de": return "Erster Frost"
        case "fr": return "Premier gel"
        case "es": return "Primera helada"
        case "it": return "Prima gelata"
        case "uk": return "Перший заморозок"
        case "ru": return "Первый заморозок"
        default: return "First Frost"
        }
    }
    
    var lastFrost: String {
        switch currentLanguage {
        case "pl": return "Ostatni przymrozek"
        case "de": return "Letzter Frost"
        case "fr": return "Dernier gel"
        case "es": return "Última helada"
        case "it": return "Ultima gelata"
        case "uk": return "Останній заморозок"
        case "ru": return "Последний заморозок"
        default: return "Last Frost"
        }
    }
    
    var climateZoneDescription: String {
        switch currentLanguage {
        case "pl": return "Twoja strefa klimatyczna jest automatycznie obliczana na podstawie lokalizacji. Decyduje o tym, jakie rośliny mogą się u Ciebie udać i kiedy najlepiej je sadzić."
        case "de": return "Ihre Klimazone wird automatisch anhand Ihres Standorts berechnet. Sie bestimmt, welche Pflanzen bei Ihnen gedeihen und wann sie am besten gepflanzt werden."
        case "fr": return "Votre zone climatique est calculée automatiquement à partir de votre position. Elle détermine quelles plantes peuvent prospérer chez vous et quand les planter."
        case "es": return "Tu zona climática se calcula automáticamente a partir de tu ubicación. Determina qué plantas pueden prosperar en tu zona y cuándo plantarlas."
        case "it": return "La tua zona climatica viene calcolata automaticamente in base alla tua posizione. Determina quali piante possono prosperare e quando piantarle."
        case "uk": return "Ваша кліматична зона обчислюється автоматично на основі місцезнаходження. Вона визначає, які рослини можуть рости у вас та коли їх найкраще садити."
        case "ru": return "Ваша климатическая зона рассчитывается автоматически на основе местоположения. Она определяет, какие растения могут расти у вас и когда их лучше сажать."
        default: return "Your climate zone is calculated automatically from your location. It determines which plants can thrive in your area and the best time to plant them."
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
