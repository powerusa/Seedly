// A deterministic typographic release banner using the app's own green palette.
import AppKit
let destination = CommandLine.arguments[1]
let locale = CommandLine.arguments.count > 2 ? CommandLine.arguments[2] : "en"
let width = CommandLine.arguments.count > 3 ? Int(CommandLine.arguments[3])! : 5244
let height = CommandLine.arguments.count > 4 ? Int(CommandLine.arguments[4])! : 2950
precondition([(5244, 2950), (3840, 1646)].contains { $0.0 == width && $0.1 == height }, "Use an Apple-supported header size")
let scale = CGFloat(height) / 900
let designWidth = CGFloat(width) / scale
let extraWidth = designWidth - 1600
let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
    bytesPerRow: width * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!,
    bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
context.scaleBy(x: scale, y: scale)
NSGradient(starting: NSColor(srgbRed: 0.16, green: 0.32, blue: 0.12, alpha: 1),
           ending: NSColor(srgbRed: 0.08, green: 0.18, blue: 0.06, alpha: 1))!
    .draw(in: NSRect(x: 0, y: 0, width: designWidth, height: 900), angle: 90)
func text(_ value: String, _ x: CGFloat, _ y: CGFloat, _ size: CGFloat, _ weight: NSFont.Weight, _ color: NSColor) {
    (value as NSString).draw(at: NSPoint(x: x, y: y), withAttributes: [.font: NSFont.systemFont(ofSize: size, weight: weight), .foregroundColor: color])
}
let accent = NSColor(srgbRed: 0.65, green: 0.86, blue: 0.42, alpha: 1)
NSColor.white.withAlphaComponent(0.035).setFill()
NSBezierPath(ovalIn: NSRect(x: 1030 + extraWidth, y: -100, width: 650, height: 650)).fill()
NSBezierPath(ovalIn: NSRect(x: 1190 + extraWidth, y: 540, width: 500, height: 500)).fill()
accent.withAlphaComponent(0.12).setFill()
NSBezierPath(roundedRect: NSRect(x: 100, y: 700, width: 230, height: 54), xRadius: 27, yRadius: 27).fill()
text(locale == "pl" ? "WERSJA 3.0" : "VERSION 3.0", 126, 715, 23, .semibold, accent)
text("Seedly 3.0", 93, 485, 140, .bold, .white)
text(locale == "pl" ? "Planuj. Sadź. Uprawiaj." : "Plan. Plant. Grow.", 102, 393, 62, .medium, .white)
text(locale == "pl" ? "77 roślin. Zdjęcia zawsze pod ręką." : "77 plants. Photos always at hand.", 104, 280, 33, .regular, NSColor.white.withAlphaComponent(0.75))
text(locale == "pl" ? "Twój ogród, w nowej zielonej odsłonie." : "Your garden, in a fresh shade of green.", 104, 223, 30, .regular, NSColor.white.withAlphaComponent(0.65))
// Leaf mark echoes the app's existing leaf icon without introducing a new logo system.
context.saveGState()
context.translateBy(x: extraWidth, y: 0)
let leaf = NSBezierPath()
leaf.move(to: NSPoint(x: 1150, y: 405))
leaf.curve(to: NSPoint(x: 1410, y: 650), controlPoint1: NSPoint(x: 1030, y: 590), controlPoint2: NSPoint(x: 1335, y: 592))
leaf.curve(to: NSPoint(x: 1150, y: 405), controlPoint1: NSPoint(x: 1490, y: 420), controlPoint2: NSPoint(x: 1350, y: 300))
accent.setFill();leaf.fill()
let vein = NSBezierPath();vein.move(to: NSPoint(x: 1130, y: 350));vein.curve(to: NSPoint(x: 1360, y: 570), controlPoint1: NSPoint(x: 1200, y: 470), controlPoint2: NSPoint(x: 1280, y: 440));vein.lineWidth = 13;vein.lineCapStyle = .round
NSColor(srgbRed: 0.11, green: 0.25, blue: 0.09, alpha: 1).setStroke();vein.stroke()
context.restoreGState()
text("SIMPLE SEEDS", 106, 80, 20, .semibold, accent)
NSGraphicsContext.restoreGraphicsState()
let bitmap = NSBitmapImageRep(cgImage: context.makeImage()!)
try bitmap.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: destination))
