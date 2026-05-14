// PlantImageView.swift
// Seedly
//
// Renders plant images using emoji or SF Symbols with colored backgrounds.
// Replace with actual asset images when available.

import SwiftUI

struct PlantImageView: View {
    let plant: Plant
    var size: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Gradient background (visible while image loads or as fallback)
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(
                    LinearGradient(
                        colors: [plantColor.opacity(0.3), plantColor.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // 1) User-uploaded photo (custom plants)
            if let data = GardenStore.customPhotoData(for: plant.id),
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
            }
            // 2) Bundled catalog photo
            else if UIImage(named: plant.imageAssetName) != nil {
                Image(plant.imageAssetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
            }
            // 3) Emoji fallback
            else {
                Text(plantEmoji)
                    .font(.system(size: size * 0.45))
            }
        }
        .frame(minWidth: size, minHeight: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
    }
    
    private var plantColor: Color {
        switch plant.category {
        case .vegetable: return .green
        case .fruit: return .orange
        case .herb: return .mint
        case .flower: return .pink
        case .berry: return .purple
        case .tree: return .brown
        case .tropical: return .yellow
        case .greenhouse: return .teal
        }
    }
    
    private var plantEmoji: String {
        PlantImageProvider.emoji(for: plant.id)
    }
}

// MARK: - Plant Image Provider

struct PlantImageProvider {
    static func emoji(for plantId: String) -> String {
        let emojiMap: [String: String] = [
            // Vegetables
            "tomato": "🍅",
            "carrot": "🥕",
            "lettuce": "🥬",
            "pepper": "🌶️",
            "cucumber": "🥒",
            "spinach": "🥬",
            "onion": "🧅",
            "garlic": "🧄",
            "potato": "🥔",
            "sweetPotato": "🍠",
            "corn": "🌽",
            "peas": "🫛",
            "bean": "🫘",
            "broccoli": "🥦",
            "cauliflower": "🥦",
            "cabbage": "🥬",
            "kale": "🥬",
            "zucchini": "🥒",
            "pumpkin": "🎃",
            "squash": "🎃",
            "eggplant": "🍆",
            "radish": "🫒",
            "beetroot": "🫒",
            "celery": "🥬",
            "asparagus": "🌿",
            "artichoke": "🌿",
            "leek": "🧅",
            "turnip": "🫒",
            "parsnip": "🥕",
            "sweetCorn": "🌽",
            "okra": "🌿",
            "brusselsSprouts": "🥬",
            "swissChard": "🥬",
            "kohlrabi": "🥬",
            "fennel": "🌿",
            "rhubarb": "🌿",
            
            // Herbs
            "basil": "🌿",
            "mint": "🌿",
            "rosemary": "🌿",
            "thyme": "🌿",
            "cilantro": "🌿",
            "parsley": "🌿",
            "dill": "🌿",
            "sage": "🌿",
            "oregano": "🌿",
            "chives": "🌿",
            "tarragon": "🌿",
            "lemonBalm": "🌿",
            "chamomile": "🌼",
            "lemongrass": "🌾",
            
            // Fruits
            "strawberry": "🍓",
            "blueberry": "🫐",
            "raspberry": "🫐",
            "blackberry": "🫐",
            "grape": "🍇",
            "watermelon": "🍉",
            "melon": "🍈",
            "apple": "🍎",
            "pear": "🍐",
            "cherry": "🍒",
            "peach": "🍑",
            "plum": "🍑",
            "fig": "🫒",
            "kiwi": "🥝",
            "lemon": "🍋",
            "orange": "🍊",
            "grapefruit": "🍊",
            
            // Flowers
            "sunflower": "🌻",
            "lavender": "💜",
            "marigold": "🌼",
            "rose": "🌹",
            "dahlia": "🌸",
            "tulip": "🌷",
            "daffodil": "🌼",
            "peony": "🌸",
            "zinnia": "🌺",
            "cosmos": "🌸",
            "pansy": "🌸",
            "petunia": "🌺",
            "geranium": "🌺",
            "nasturtium": "🌼",
            "snapdragon": "🌺",
            "chrysanthemum": "🌼",
            
            // Tropical
            "mango": "🥭",
            "banana": "🍌",
            "pineapple": "🍍",
            "avocado": "🥑",
            "papaya": "🫒",
            "passionfruit": "🫒",
            "guava": "🫒",
            "coconut": "🥥",
            "dragonfruit": "🫒",
            "lychee": "🫒",
            "starfruit": "⭐",
            "jackfruit": "🫒",
            
            // Trees
            "appleTree": "🍎",
            "pearTree": "🍐",
            "cherryTree": "🍒",
            "peachTree": "🍑",
            "plumTree": "🍑",
            "lemonTree": "🍋",
            "orangeTree": "🍊",
            "oliverTree": "🫒",
            "walnut": "🌰",
            "almond": "🌰",
        ]
        
        return emojiMap[plantId] ?? "🌱"
    }
}

#Preview {
    HStack {
        PlantImageView(plant: PlantDatabase.mockPlants[0], size: 60)
        PlantImageView(plant: PlantDatabase.mockPlants[1], size: 60)
        PlantImageView(plant: PlantDatabase.mockPlants[2], size: 80)
    }
    .padding()
}
