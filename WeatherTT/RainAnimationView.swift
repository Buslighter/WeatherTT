import UIKit

class RainAnimationView: UIView, Animation {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation()
    }
    
    func setupAnimation() {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: bounds.width / 2, y: -50)
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 20
        cell.lifetime = 5.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = .pi
        cell.spinRange = 0.25
        cell.scale = 0.1
        cell.scaleRange = 0.1
        cell.contents = UIImage(named: "raindrop")?.cgImage
        emitter.emitterCells = [cell]
        layer.addSublayer(emitter)
    }
}
