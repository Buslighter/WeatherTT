import UIKit
import QuartzCore


class RaindropLayer: CALayer {
    var raindropImage: CGImage?
    
    override func draw(in ctx: CGContext) {
        guard let raindropImage = raindropImage else { return }
        ctx.draw(raindropImage, in: bounds)
    }
}

