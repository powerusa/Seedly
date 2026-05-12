// PlantLocalizationFull.swift
// Seedly
//
// Full plant name translations for all plants in the database.

import Foundation

extension PlantLocalization {
    
    static let additionalLocalizedNames: [String: [String: String]] = [
        // ═══════════════════════════════════════
        // VEGETABLES
        // ═══════════════════════════════════════
        "plant_potato": [
            "en": "Potatoes", "pl": "Ziemniaki", "es": "Patatas", "de": "Kartoffeln",
            "fr": "Pommes de terre", "it": "Patate", "pt": "Batatas", "nl": "Aardappelen",
            "ja": "ジャガイモ", "ko": "감자", "zh": "土豆", "ar": "بطاطس",
            "hi": "आलू", "uk": "Картопля", "ru": "Картофель"
        ],
        "plant_sweetPotato": [
            "en": "Sweet Potatoes", "pl": "Bataty", "es": "Batatas", "de": "Süßkartoffeln",
            "fr": "Patates douces", "it": "Patate dolci", "pt": "Batata-doce", "nl": "Zoete aardappelen",
            "ja": "サツマイモ", "ko": "고구마", "zh": "红薯", "ar": "بطاطا حلوة",
            "hi": "शकरकंद", "uk": "Батат", "ru": "Батат"
        ],
        "plant_corn": [
            "en": "Corn", "pl": "Kukurydza", "es": "Maíz", "de": "Mais",
            "fr": "Maïs", "it": "Mais", "pt": "Milho", "nl": "Maïs",
            "ja": "トウモロコシ", "ko": "옥수수", "zh": "玉米", "ar": "ذرة",
            "hi": "मक्का", "uk": "Кукурудза", "ru": "Кукуруза"
        ],
        "plant_bean": [
            "en": "Beans", "pl": "Fasola", "es": "Judías", "de": "Bohnen",
            "fr": "Haricots", "it": "Fagioli", "pt": "Feijões", "nl": "Bonen",
            "ja": "インゲン", "ko": "강낭콩", "zh": "豆角", "ar": "فاصوليا",
            "hi": "फलियाँ", "uk": "Квасоля", "ru": "Фасоль"
        ],
        "plant_broccoli": [
            "en": "Broccoli", "pl": "Brokuły", "es": "Brócoli", "de": "Brokkoli",
            "fr": "Brocoli", "it": "Broccoli", "pt": "Brócolis", "nl": "Broccoli",
            "ja": "ブロッコリー", "ko": "브로콜리", "zh": "西兰花", "ar": "بروكلي",
            "hi": "ब्रोकली", "uk": "Броколі", "ru": "Брокколи"
        ],
        "plant_cauliflower": [
            "en": "Cauliflower", "pl": "Kalafior", "es": "Coliflor", "de": "Blumenkohl",
            "fr": "Chou-fleur", "it": "Cavolfiore", "pt": "Couve-flor", "nl": "Bloemkool",
            "ja": "カリフラワー", "ko": "콜리플라워", "zh": "花椰菜", "ar": "قرنبيط",
            "hi": "फूलगोभी", "uk": "Цвітна капуста", "ru": "Цветная капуста"
        ],
        "plant_cabbage": [
            "en": "Cabbage", "pl": "Kapusta", "es": "Col", "de": "Kohl",
            "fr": "Chou", "it": "Cavolo", "pt": "Repolho", "nl": "Kool",
            "ja": "キャベツ", "ko": "양배추", "zh": "卷心菜", "ar": "ملفوف",
            "hi": "पत्तागोभी", "uk": "Капуста", "ru": "Капуста"
        ],
        "plant_eggplant": [
            "en": "Eggplant", "pl": "Bakłażan", "es": "Berenjena", "de": "Aubergine",
            "fr": "Aubergine", "it": "Melanzana", "pt": "Berinjela", "nl": "Aubergine",
            "ja": "ナス", "ko": "가지", "zh": "茄子", "ar": "باذنجان",
            "hi": "बैंगन", "uk": "Баклажан", "ru": "Баклажан"
        ],
        "plant_radish": [
            "en": "Radish", "pl": "Rzodkiewka", "es": "Rábano", "de": "Radieschen",
            "fr": "Radis", "it": "Ravanello", "pt": "Rabanete", "nl": "Radijs",
            "ja": "ラディッシュ", "ko": "래디시", "zh": "萝卜", "ar": "فجل",
            "hi": "मूली", "uk": "Редиска", "ru": "Редис"
        ],
        "plant_beetroot": [
            "en": "Beetroot", "pl": "Burak", "es": "Remolacha", "de": "Rote Bete",
            "fr": "Betterave", "it": "Barbabietola", "pt": "Beterraba", "nl": "Rode biet",
            "ja": "ビーツ", "ko": "비트", "zh": "甜菜", "ar": "شمندر",
            "hi": "चुकंदर", "uk": "Буряк", "ru": "Свёкла"
        ],
        "plant_celery": [
            "en": "Celery", "pl": "Seler", "es": "Apio", "de": "Sellerie",
            "fr": "Céleri", "it": "Sedano", "pt": "Aipo", "nl": "Selderij",
            "ja": "セロリ", "ko": "셀러리", "zh": "芹菜", "ar": "كرفس",
            "hi": "अजवाइन", "uk": "Селера", "ru": "Сельдерей"
        ],
        "plant_pumpkin": [
            "en": "Pumpkin", "pl": "Dynia", "es": "Calabaza", "de": "Kürbis",
            "fr": "Citrouille", "it": "Zucca", "pt": "Abóbora", "nl": "Pompoen",
            "ja": "カボチャ", "ko": "호박", "zh": "南瓜", "ar": "يقطين",
            "hi": "कद्दू", "uk": "Гарбуз", "ru": "Тыква"
        ],
        "plant_squash": [
            "en": "Squash", "pl": "Kabaczek", "es": "Calabacín", "de": "Kürbis",
            "fr": "Courge", "it": "Zucca", "pt": "Abóbora", "nl": "Pompoen",
            "ja": "スカッシュ", "ko": "스쿼시", "zh": "南瓜", "ar": "قرع",
            "hi": "स्क्वाश", "uk": "Кабачок", "ru": "Кабачок"
        ],
        "plant_brusselsSprouts": [
            "en": "Brussels Sprouts", "pl": "Brukselka", "es": "Coles de Bruselas", "de": "Rosenkohl",
            "fr": "Choux de Bruxelles", "it": "Cavolini di Bruxelles", "pt": "Couve-de-bruxelas", "nl": "Spruitjes",
            "ja": "芽キャベツ", "ko": "방울양배추", "zh": "抱子甘蓝", "ar": "كرنب بروكسل",
            "hi": "ब्रसेल्स स्प्राउट्स", "uk": "Брюссельська капуста", "ru": "Брюссельская капуста"
        ],
        "plant_leek": [
            "en": "Leek", "pl": "Por", "es": "Puerro", "de": "Lauch",
            "fr": "Poireau", "it": "Porro", "pt": "Alho-poró", "nl": "Prei",
            "ja": "リーキ", "ko": "리크", "zh": "韭葱", "ar": "كراث",
            "hi": "लीक", "uk": "Порей", "ru": "Лук-порей"
        ],
        "plant_asparagus": [
            "en": "Asparagus", "pl": "Szparagi", "es": "Espárragos", "de": "Spargel",
            "fr": "Asperges", "it": "Asparagi", "pt": "Espargos", "nl": "Asperges",
            "ja": "アスパラガス", "ko": "아스파라거스", "zh": "芦笋", "ar": "هليون",
            "hi": "शतावरी", "uk": "Спаржа", "ru": "Спаржа"
        ],
        "plant_swissChard": [
            "en": "Swiss Chard", "pl": "Boćwina", "es": "Acelga", "de": "Mangold",
            "fr": "Blette", "it": "Bietola", "pt": "Acelga", "nl": "Snijbiet",
            "ja": "フダンソウ", "ko": "근대", "zh": "甜菜叶", "ar": "سلق",
            "hi": "चार्ड", "uk": "Мангольд", "ru": "Мангольд"
        ],
        "plant_turnip": [
            "en": "Turnip", "pl": "Rzepa", "es": "Nabo", "de": "Rübe",
            "fr": "Navet", "it": "Rapa", "pt": "Nabo", "nl": "Raap",
            "ja": "カブ", "ko": "순무", "zh": "芜菁", "ar": "لفت",
            "hi": "शलगम", "uk": "Ріпа", "ru": "Репа"
        ],
        "plant_parsnip": [
            "en": "Parsnip", "pl": "Pasternak", "es": "Chirivía", "de": "Pastinake",
            "fr": "Panais", "it": "Pastinaca", "pt": "Pastinaga", "nl": "Pastinaak",
            "ja": "パースニップ", "ko": "파스닙", "zh": "欧洲防风", "ar": "جزر أبيض",
            "hi": "पार्सनिप", "uk": "Пастернак", "ru": "Пастернак"
        ],
        "plant_okra": [
            "en": "Okra", "pl": "Okra", "es": "Okra", "de": "Okra",
            "fr": "Gombo", "it": "Okra", "pt": "Quiabo", "nl": "Okra",
            "ja": "オクラ", "ko": "오크라", "zh": "秋葵", "ar": "بامية",
            "hi": "भिंडी", "uk": "Бамія", "ru": "Бамия"
        ],
        "plant_garlic": [
            "en": "Garlic", "pl": "Czosnek", "es": "Ajo", "de": "Knoblauch",
            "fr": "Ail", "it": "Aglio", "pt": "Alho", "nl": "Knoflook",
            "ja": "ニンニク", "ko": "마늘", "zh": "大蒜", "ar": "ثوم",
            "hi": "लहसुन", "uk": "Часник", "ru": "Чеснок"
        ],
        "plant_zucchini": [
            "en": "Zucchini", "pl": "Cukinia", "es": "Calabacín", "de": "Zucchini",
            "fr": "Courgette", "it": "Zucchina", "pt": "Abobrinha", "nl": "Courgette",
            "ja": "ズッキーニ", "ko": "주키니", "zh": "西葫芦", "ar": "كوسة",
            "hi": "तोरी", "uk": "Цукіні", "ru": "Цукини"
        ],
        "plant_kale": [
            "en": "Kale", "pl": "Jarmuż", "es": "Col rizada", "de": "Grünkohl",
            "fr": "Chou frisé", "it": "Cavolo riccio", "pt": "Couve", "nl": "Boerenkool",
            "ja": "ケール", "ko": "케일", "zh": "羽衣甘蓝", "ar": "كرنب أخضر",
            "hi": "केल", "uk": "Кейл", "ru": "Кейл"
        ],
        "plant_peas": [
            "en": "Peas", "pl": "Groszek", "es": "Guisantes", "de": "Erbsen",
            "fr": "Petits pois", "it": "Piselli", "pt": "Ervilhas", "nl": "Erwten",
            "ja": "エンドウ豆", "ko": "완두콩", "zh": "豌豆", "ar": "بازلاء",
            "hi": "मटर", "uk": "Горох", "ru": "Горох"
        ],
        
        // ═══════════════════════════════════════
        // HERBS
        // ═══════════════════════════════════════
        "plant_parsley": [
            "en": "Parsley", "pl": "Pietruszka", "es": "Perejil", "de": "Petersilie",
            "fr": "Persil", "it": "Prezzemolo", "pt": "Salsa", "nl": "Peterselie",
            "ja": "パセリ", "ko": "파슬리", "zh": "欧芹", "ar": "بقدونس",
            "hi": "अजमोद", "uk": "Петрушка", "ru": "Петрушка"
        ],
        "plant_dill": [
            "en": "Dill", "pl": "Koperek", "es": "Eneldo", "de": "Dill",
            "fr": "Aneth", "it": "Aneto", "pt": "Endro", "nl": "Dille",
            "ja": "ディル", "ko": "딜", "zh": "莳萝", "ar": "شبت",
            "hi": "सोआ", "uk": "Кріп", "ru": "Укроп"
        ],
        "plant_sage": [
            "en": "Sage", "pl": "Szałwia", "es": "Salvia", "de": "Salbei",
            "fr": "Sauge", "it": "Salvia", "pt": "Sálvia", "nl": "Salie",
            "ja": "セージ", "ko": "세이지", "zh": "鼠尾草", "ar": "مريمية",
            "hi": "तेजपत्ता", "uk": "Шавлія", "ru": "Шалфей"
        ],
        "plant_oregano": [
            "en": "Oregano", "pl": "Oregano", "es": "Orégano", "de": "Oregano",
            "fr": "Origan", "it": "Origano", "pt": "Orégano", "nl": "Oregano",
            "ja": "オレガノ", "ko": "오레가노", "zh": "牛至", "ar": "أوريجانو",
            "hi": "अजवायन की पत्ती", "uk": "Орегано", "ru": "Орегано"
        ],
        "plant_chives": [
            "en": "Chives", "pl": "Szczypiorek", "es": "Cebollino", "de": "Schnittlauch",
            "fr": "Ciboulette", "it": "Erba cipollina", "pt": "Cebolinha", "nl": "Bieslook",
            "ja": "チャイブ", "ko": "차이브", "zh": "细香葱", "ar": "ثوم معمر",
            "hi": "चाइव्स", "uk": "Шніт-цибуля", "ru": "Шнитт-лук"
        ],
        "plant_lemonBalm": [
            "en": "Lemon Balm", "pl": "Melisa", "es": "Melisa", "de": "Zitronenmelisse",
            "fr": "Mélisse", "it": "Melissa", "pt": "Erva-cidreira", "nl": "Citroenmelisse",
            "ja": "レモンバーム", "ko": "레몬밤", "zh": "柠檬香脂草", "ar": "بلسم الليمون",
            "hi": "लेमन बाम", "uk": "Меліса", "ru": "Мелисса"
        ],
        "plant_rosemary": [
            "en": "Rosemary", "pl": "Rozmaryn", "es": "Romero", "de": "Rosmarin",
            "fr": "Romarin", "it": "Rosmarino", "pt": "Alecrim", "nl": "Rozemarijn",
            "ja": "ローズマリー", "ko": "로즈마리", "zh": "迷迭香", "ar": "إكليل الجبل",
            "hi": "रोज़मेरी", "uk": "Розмарин", "ru": "Розмарин"
        ],
        "plant_thyme": [
            "en": "Thyme", "pl": "Tymianek", "es": "Tomillo", "de": "Thymian",
            "fr": "Thym", "it": "Timo", "pt": "Tomilho", "nl": "Tijm",
            "ja": "タイム", "ko": "타임", "zh": "百里香", "ar": "زعتر",
            "hi": "थाइम", "uk": "Чебрець", "ru": "Тимьян"
        ],
        "plant_cilantro": [
            "en": "Cilantro", "pl": "Kolendra", "es": "Cilantro", "de": "Koriander",
            "fr": "Coriandre", "it": "Coriandolo", "pt": "Coentro", "nl": "Koriander",
            "ja": "コリアンダー", "ko": "고수", "zh": "香菜", "ar": "كزبرة",
            "hi": "धनिया", "uk": "Коріандр", "ru": "Кинза"
        ],
        
        // ═══════════════════════════════════════
        // FLOWERS
        // ═══════════════════════════════════════
        "plant_rose": [
            "en": "Rose", "pl": "Róża", "es": "Rosa", "de": "Rose",
            "fr": "Rose", "it": "Rosa", "pt": "Rosa", "nl": "Roos",
            "ja": "バラ", "ko": "장미", "zh": "玫瑰", "ar": "وردة",
            "hi": "गुलाब", "uk": "Троянда", "ru": "Роза"
        ],
        "plant_dahlia": [
            "en": "Dahlia", "pl": "Dalia", "es": "Dalia", "de": "Dahlie",
            "fr": "Dahlia", "it": "Dalia", "pt": "Dália", "nl": "Dahlia",
            "ja": "ダリア", "ko": "달리아", "zh": "大丽花", "ar": "داليا",
            "hi": "डहलिया", "uk": "Жоржина", "ru": "Георгин"
        ],
        "plant_tulip": [
            "en": "Tulip", "pl": "Tulipan", "es": "Tulipán", "de": "Tulpe",
            "fr": "Tulipe", "it": "Tulipano", "pt": "Tulipa", "nl": "Tulp",
            "ja": "チューリップ", "ko": "튤립", "zh": "郁金香", "ar": "توليب",
            "hi": "ट्यूलिप", "uk": "Тюльпан", "ru": "Тюльпан"
        ],
        "plant_zinnia": [
            "en": "Zinnia", "pl": "Cynia", "es": "Zinnia", "de": "Zinnie",
            "fr": "Zinnia", "it": "Zinnia", "pt": "Zínia", "nl": "Zinnia",
            "ja": "ジニア", "ko": "지니아", "zh": "百日草", "ar": "زينيا",
            "hi": "ज़िन्निया", "uk": "Цинія", "ru": "Цинния"
        ],
        "plant_cosmos": [
            "en": "Cosmos", "pl": "Kosmos", "es": "Cosmos", "de": "Kosmee",
            "fr": "Cosmos", "it": "Cosmea", "pt": "Cosmos", "nl": "Cosmos",
            "ja": "コスモス", "ko": "코스모스", "zh": "波斯菊", "ar": "كوزموس",
            "hi": "कॉसमॉस", "uk": "Космея", "ru": "Космея"
        ],
        "plant_nasturtium": [
            "en": "Nasturtium", "pl": "Nasturcja", "es": "Capuchina", "de": "Kapuzinerkresse",
            "fr": "Capucine", "it": "Nasturzio", "pt": "Nastúrcio", "nl": "Oost-Indische kers",
            "ja": "ナスタチウム", "ko": "한련화", "zh": "旱金莲", "ar": "أبو خنجر",
            "hi": "नास्टर्शियम", "uk": "Настурція", "ru": "Настурция"
        ],
        "plant_petunia": [
            "en": "Petunia", "pl": "Petunia", "es": "Petunia", "de": "Petunie",
            "fr": "Pétunia", "it": "Petunia", "pt": "Petúnia", "nl": "Petunia",
            "ja": "ペチュニア", "ko": "페튜니아", "zh": "矮牵牛", "ar": "بتونيا",
            "hi": "पेटूनिया", "uk": "Петунія", "ru": "Петуния"
        ],
        "plant_marigold": [
            "en": "Marigold", "pl": "Aksamitka", "es": "Caléndula", "de": "Studentenblume",
            "fr": "Souci", "it": "Tagete", "pt": "Cravo-de-defunto", "nl": "Goudsbloem",
            "ja": "マリーゴールド", "ko": "금잔화", "zh": "万寿菊", "ar": "قطيفة",
            "hi": "गेंदा", "uk": "Чорнобривці", "ru": "Бархатцы"
        ],
        
        // ═══════════════════════════════════════
        // FRUITS & BERRIES
        // ═══════════════════════════════════════
        "plant_grape": [
            "en": "Grapes", "pl": "Winogrona", "es": "Uvas", "de": "Trauben",
            "fr": "Raisins", "it": "Uva", "pt": "Uvas", "nl": "Druiven",
            "ja": "ブドウ", "ko": "포도", "zh": "葡萄", "ar": "عنب",
            "hi": "अंगूर", "uk": "Виноград", "ru": "Виноград"
        ],
        "plant_watermelon": [
            "en": "Watermelon", "pl": "Arbuz", "es": "Sandía", "de": "Wassermelone",
            "fr": "Pastèque", "it": "Anguria", "pt": "Melancia", "nl": "Watermeloen",
            "ja": "スイカ", "ko": "수박", "zh": "西瓜", "ar": "بطيخ",
            "hi": "तरबूज", "uk": "Кавун", "ru": "Арбуз"
        ],
        "plant_melon": [
            "en": "Melon", "pl": "Melon", "es": "Melón", "de": "Melone",
            "fr": "Melon", "it": "Melone", "pt": "Melão", "nl": "Meloen",
            "ja": "メロン", "ko": "멜론", "zh": "甜瓜", "ar": "شمام",
            "hi": "खरबूजा", "uk": "Диня", "ru": "Дыня"
        ],
        "plant_blackberry": [
            "en": "Blackberry", "pl": "Jeżyna", "es": "Mora", "de": "Brombeere",
            "fr": "Mûre", "it": "Mora", "pt": "Amora", "nl": "Braam",
            "ja": "ブラックベリー", "ko": "블랙베리", "zh": "黑莓", "ar": "توت أسود",
            "hi": "ब्लैकबेरी", "uk": "Ожина", "ru": "Ежевика"
        ],
        "plant_gooseberry": [
            "en": "Gooseberry", "pl": "Agrest", "es": "Grosella", "de": "Stachelbeere",
            "fr": "Groseille à maquereau", "it": "Uva spina", "pt": "Groselha", "nl": "Kruisbes",
            "ja": "グーズベリー", "ko": "구즈베리", "zh": "醋栗", "ar": "عنب الثعلب",
            "hi": "आंवला", "uk": "Аґрус", "ru": "Крыжовник"
        ],
        "plant_blueberry": [
            "en": "Blueberry", "pl": "Borówka", "es": "Arándano", "de": "Blaubeere",
            "fr": "Myrtille", "it": "Mirtillo", "pt": "Mirtilo", "nl": "Blauwe bes",
            "ja": "ブルーベリー", "ko": "블루베리", "zh": "蓝莓", "ar": "توت أزرق",
            "hi": "ब्लूबेरी", "uk": "Чорниця", "ru": "Черника"
        ],
        "plant_raspberry": [
            "en": "Raspberry", "pl": "Malina", "es": "Frambuesa", "de": "Himbeere",
            "fr": "Framboise", "it": "Lampone", "pt": "Framboesa", "nl": "Framboos",
            "ja": "ラズベリー", "ko": "라즈베리", "zh": "覆盆子", "ar": "توت العليق",
            "hi": "रास्पबेरी", "uk": "Малина", "ru": "Малина"
        ],
        
        // ═══════════════════════════════════════
        // TROPICAL
        // ═══════════════════════════════════════
        "plant_avocado": [
            "en": "Avocado", "pl": "Awokado", "es": "Aguacate", "de": "Avocado",
            "fr": "Avocat", "it": "Avocado", "pt": "Abacate", "nl": "Avocado",
            "ja": "アボカド", "ko": "아보카도", "zh": "鳄梨", "ar": "أفوكادو",
            "hi": "एवोकाडो", "uk": "Авокадо", "ru": "Авокадо"
        ],
        "plant_pineapple": [
            "en": "Pineapple", "pl": "Ananas", "es": "Piña", "de": "Ananas",
            "fr": "Ananas", "it": "Ananas", "pt": "Abacaxi", "nl": "Ananas",
            "ja": "パイナップル", "ko": "파인애플", "zh": "菠萝", "ar": "أناناس",
            "hi": "अनानास", "uk": "Ананас", "ru": "Ананас"
        ],
        "plant_passionfruit": [
            "en": "Passion Fruit", "pl": "Marakuja", "es": "Maracuyá", "de": "Passionsfrucht",
            "fr": "Fruit de la passion", "it": "Frutto della passione", "pt": "Maracujá", "nl": "Passievrucht",
            "ja": "パッションフルーツ", "ko": "패션프루트", "zh": "百香果", "ar": "فاكهة العاطفة",
            "hi": "पैशन फ्रूट", "uk": "Маракуя", "ru": "Маракуйя"
        ],
        "plant_lemongrass": [
            "en": "Lemongrass", "pl": "Trawa cytrynowa", "es": "Hierba limón", "de": "Zitronengras",
            "fr": "Citronnelle", "it": "Citronella", "pt": "Capim-limão", "nl": "Citroengras",
            "ja": "レモングラス", "ko": "레몬그라스", "zh": "柠檬草", "ar": "عشبة الليمون",
            "hi": "लेमनग्रास", "uk": "Лимонна трава", "ru": "Лемонграсс"
        ],
        "plant_ginger": [
            "en": "Ginger", "pl": "Imbir", "es": "Jengibre", "de": "Ingwer",
            "fr": "Gingembre", "it": "Zenzero", "pt": "Gengibre", "nl": "Gember",
            "ja": "ショウガ", "ko": "생강", "zh": "姜", "ar": "زنجبيل",
            "hi": "अदरक", "uk": "Імбир", "ru": "Имбирь"
        ],
        "plant_turmeric": [
            "en": "Turmeric", "pl": "Kurkuma", "es": "Cúrcuma", "de": "Kurkuma",
            "fr": "Curcuma", "it": "Curcuma", "pt": "Cúrcuma", "nl": "Kurkuma",
            "ja": "ウコン", "ko": "강황", "zh": "姜黄", "ar": "كركم",
            "hi": "हल्दी", "uk": "Куркума", "ru": "Куркума"
        ],
        "plant_mango": [
            "en": "Mango", "pl": "Mango", "es": "Mango", "de": "Mango",
            "fr": "Mangue", "it": "Mango", "pt": "Manga", "nl": "Mango",
            "ja": "マンゴー", "ko": "망고", "zh": "芒果", "ar": "مانجو",
            "hi": "आम", "uk": "Манго", "ru": "Манго"
        ],
        "plant_banana": [
            "en": "Banana", "pl": "Banan", "es": "Plátano", "de": "Banane",
            "fr": "Banane", "it": "Banana", "pt": "Banana", "nl": "Banaan",
            "ja": "バナナ", "ko": "바나나", "zh": "香蕉", "ar": "موز",
            "hi": "केला", "uk": "Банан", "ru": "Банан"
        ],
    ]
}
