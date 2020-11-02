import Cocoa

class QRViewController : NSViewController {
    
    
    @objc dynamic var image : NSImage?
    var text : String = " " {
        didSet {
            print(text)
            redrawQRCode()
        }
    }
    
        func redrawQRCode() {
            image = nsImage()
        }
    
        func unscaledQrImage() -> CIImage? {
            guard
                let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator"),
                let message = text.data(using: .utf8) else { return nil }
            //var bytes: Data = data!
            qrCodeFilter.setDefaults()
            qrCodeFilter.setValue(message, forKey: "inputMessage")
            qrCodeFilter.setValue("L", forKey: "inputCorrectionLevel")
            //var bytes: Data = data!
            return qrCodeFilter.outputImage
        }
    
        func ciImage() -> CIImage? {
            guard
                let qrImage = unscaledQrImage(),
                let falseColorFilter = CIFilter(name: "CIFalseColor") else { return nil }
            falseColorFilter.setDefaults()
            falseColorFilter.setValue(CIColor.black, forKey: "inputColor0")
            falseColorFilter.setValue(CIColor.white, forKey: "inputColor1")
            falseColorFilter.setValue(qrImage, forKey: kCIInputImageKey)
            if let colorizedImage = falseColorFilter.outputImage {
                return colorizedImage.transformed(by: transform(for: colorizedImage.extent))
            }
            return falseColorFilter.outputImage
        }
    
        let outputWidth = 500
    
        func transform(for rect : CGRect) -> CGAffineTransform {
            return CGAffineTransform(scaleX: CGFloat(outputWidth) / rect.width,
                                     y: CGFloat(outputWidth) / rect.height)
        }
    
        func nsImage() -> NSImage? {
            var image : NSImage?
            if let newImage = ciImage() {
                image = NSImage(size: newImage.extent.size)
                image!.addRepresentation(NSCIImageRep(ciImage: newImage))
            }
            return image
        }
    
    
}
