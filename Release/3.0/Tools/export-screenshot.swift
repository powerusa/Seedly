// Export real simulator captures as opaque RGB PNGs required by App Store Connect.
// This changes file encoding only; no compositing, labels, resizing or UI modifications.
import Foundation
import ImageIO
import CoreGraphics
import UniformTypeIdentifiers
for path in CommandLine.arguments.dropFirst() {
    let url = URL(fileURLWithPath: path)
    guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
          let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
          let context = CGContext(data: nil, width: image.width, height: image.height,
             bitsPerComponent: 8, bytesPerRow: image.width * 4,
             space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
             bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue) else { fatalError("Cannot decode \(path)") }
    context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
    guard let rgb = context.makeImage(),
          let output = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil) else {
        fatalError("Cannot export \(path)")
    }
    CGImageDestinationAddImage(output, rgb, nil)
    precondition(CGImageDestinationFinalize(output))
    print("RGB PNG: \(path)")
}
