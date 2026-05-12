// PlantLocalization.swift
// Seedly

import Foundation

struct PlantLocalization {
    
    // Localized plant names dictionary
    // In production, this would be loaded from Localizable.strings
    private static let localizedNames: [String: [String: String]] = [
        "plant_tomato": [
            "en": "Tomatoes",
            "pl": "Pomidory",
            "es": "Tomates",
            "de": "Tomaten",
            "fr": "Tomates",
            "it": "Pomodori",
            "pt": "Tomates",
            "nl": "Tomaten",
            "ja": "トマト",
            "ko": "토마토",
            "zh": "番茄",
            "ar": "طماطم",
            "hi": "टमाटर",
            "uk": "Помідори",
            "ru": "Помидоры"
        ],
        "plant_carrot": [
            "en": "Carrots",
            "pl": "Marchew",
            "es": "Zanahorias",
            "de": "Karotten",
            "fr": "Carottes",
            "it": "Carote",
            "pt": "Cenouras",
            "nl": "Wortelen",
            "ja": "ニンジン",
            "ko": "당근",
            "zh": "胡萝卜",
            "ar": "جزر",
            "hi": "गाजर",
            "uk": "Морква",
            "ru": "Морковь"
        ],
        "plant_lettuce": [
            "en": "Lettuce",
            "pl": "Sałata",
            "es": "Lechuga",
            "de": "Kopfsalat",
            "fr": "Laitue",
            "it": "Lattuga",
            "pt": "Alface",
            "nl": "Sla",
            "ja": "レタス",
            "ko": "상추",
            "zh": "生菜",
            "ar": "خس",
            "hi": "लेटस",
            "uk": "Салат",
            "ru": "Салат"
        ],
        "plant_basil": [
            "en": "Basil",
            "pl": "Bazylia",
            "es": "Albahaca",
            "de": "Basilikum",
            "fr": "Basilic",
            "it": "Basilico",
            "pt": "Manjericão",
            "nl": "Basilicum",
            "ja": "バジル",
            "ko": "바질",
            "zh": "罗勒",
            "ar": "ريحان",
            "hi": "तुलसी",
            "uk": "Базилік",
            "ru": "Базилик"
        ],
        "plant_pepper": [
            "en": "Peppers",
            "pl": "Papryka",
            "es": "Pimientos",
            "de": "Paprika",
            "fr": "Poivrons",
            "it": "Peperoni",
            "pt": "Pimentões",
            "nl": "Paprika",
            "ja": "ピーマン",
            "ko": "피망",
            "zh": "辣椒",
            "ar": "فلفل",
            "hi": "शिमला मिर्च",
            "uk": "Перець",
            "ru": "Перец"
        ],
        "plant_cucumber": [
            "en": "Cucumbers",
            "pl": "Ogórki",
            "es": "Pepinos",
            "de": "Gurken",
            "fr": "Concombres",
            "it": "Cetrioli",
            "pt": "Pepinos",
            "nl": "Komkommers",
            "ja": "キュウリ",
            "ko": "오이",
            "zh": "黄瓜",
            "ar": "خيار",
            "hi": "खीरा",
            "uk": "Огірки",
            "ru": "Огурцы"
        ],
        "plant_strawberry": [
            "en": "Strawberries",
            "pl": "Truskawki",
            "es": "Fresas",
            "de": "Erdbeeren",
            "fr": "Fraises",
            "it": "Fragole",
            "pt": "Morangos",
            "nl": "Aardbeien",
            "ja": "イチゴ",
            "ko": "딸기",
            "zh": "草莓",
            "ar": "فراولة",
            "hi": "स्ट्रॉबेरी",
            "uk": "Полуниця",
            "ru": "Клубника"
        ],
        "plant_spinach": [
            "en": "Spinach",
            "pl": "Szpinak",
            "es": "Espinacas",
            "de": "Spinat",
            "fr": "Épinards",
            "it": "Spinaci",
            "pt": "Espinafre",
            "nl": "Spinazie",
            "ja": "ほうれん草",
            "ko": "시금치",
            "zh": "菠菜",
            "ar": "سبانخ",
            "hi": "पालक",
            "uk": "Шпинат",
            "ru": "Шпинат"
        ],
        "plant_onion": [
            "en": "Onions",
            "pl": "Cebula",
            "es": "Cebollas",
            "de": "Zwiebeln",
            "fr": "Oignons",
            "it": "Cipolle",
            "pt": "Cebolas",
            "nl": "Uien",
            "ja": "タマネギ",
            "ko": "양파",
            "zh": "洋葱",
            "ar": "بصل",
            "hi": "प्याज",
            "uk": "Цибуля",
            "ru": "Лук"
        ],
        "plant_sunflower": [
            "en": "Sunflower",
            "pl": "Słonecznik",
            "es": "Girasol",
            "de": "Sonnenblume",
            "fr": "Tournesol",
            "it": "Girasole",
            "pt": "Girassol",
            "nl": "Zonnebloem",
            "ja": "ヒマワリ",
            "ko": "해바라기",
            "zh": "向日葵",
            "ar": "دوار الشمس",
            "hi": "सूरजमुखी",
            "uk": "Соняшник",
            "ru": "Подсолнух"
        ],
        "plant_mint": [
            "en": "Mint",
            "pl": "Mięta",
            "es": "Menta",
            "de": "Minze",
            "fr": "Menthe",
            "it": "Menta",
            "pt": "Hortelã",
            "nl": "Munt",
            "ja": "ミント",
            "ko": "민트",
            "zh": "薄荷",
            "ar": "نعناع",
            "hi": "पुदीना",
            "uk": "М'ята",
            "ru": "Мята"
        ],
        "plant_lavender": [
            "en": "Lavender",
            "pl": "Lawenda",
            "es": "Lavanda",
            "de": "Lavendel",
            "fr": "Lavande",
            "it": "Lavanda",
            "pt": "Lavanda",
            "nl": "Lavendel",
            "ja": "ラベンダー",
            "ko": "라벤더",
            "zh": "薰衣草",
            "ar": "لافندر",
            "hi": "लैवेंडर",
            "uk": "Лаванда",
            "ru": "Лаванда"
        ]
    ]
    
    static func localizedName(for key: String, locale: String) -> String {
        // Check main dictionary first, then additional translations
        if let name = localizedNames[key]?[locale] {
            return name
        }
        if let name = additionalLocalizedNames[key]?[locale] {
            return name
        }
        // Fallback to English
        return localizedNames[key]?["en"] ?? additionalLocalizedNames[key]?["en"] ?? key.replacingOccurrences(of: "plant_", with: "").capitalized
    }
    
    static var supportedLanguages: [SupportedLanguage] {
        [
            SupportedLanguage(code: "en", name: "English", nativeName: "English"),
            SupportedLanguage(code: "pl", name: "Polish", nativeName: "Polski"),
            SupportedLanguage(code: "es", name: "Spanish", nativeName: "Español"),
            SupportedLanguage(code: "de", name: "German", nativeName: "Deutsch"),
            SupportedLanguage(code: "fr", name: "French", nativeName: "Français"),
            SupportedLanguage(code: "it", name: "Italian", nativeName: "Italiano"),
            SupportedLanguage(code: "pt", name: "Portuguese", nativeName: "Português"),
            SupportedLanguage(code: "nl", name: "Dutch", nativeName: "Nederlands"),
            SupportedLanguage(code: "ja", name: "Japanese", nativeName: "日本語"),
            SupportedLanguage(code: "ko", name: "Korean", nativeName: "한국어"),
            SupportedLanguage(code: "zh", name: "Chinese", nativeName: "中文"),
            SupportedLanguage(code: "ar", name: "Arabic", nativeName: "العربية"),
            SupportedLanguage(code: "hi", name: "Hindi", nativeName: "हिन्दी"),
            SupportedLanguage(code: "uk", name: "Ukrainian", nativeName: "Українська"),
            SupportedLanguage(code: "ru", name: "Russian", nativeName: "Русский"),
        ]
    }
}

struct SupportedLanguage: Identifiable, Hashable {
    let code: String
    let name: String
    let nativeName: String
    
    var id: String { code }
    
    var isRTL: Bool {
        code == "ar"
    }
}
