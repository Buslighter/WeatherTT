import UIKit

class DownfallAnimation: WeatherAnimation {
    private var eventType: WeatherEvent
    private var settings: DownfallSetings?
    
    struct DownfallSetings {
        private (set) var backgroundColor: UIColor?
        private (set) var emissionLongtitudeScale: CGFloat
        private (set) var image: CGImage?
        private (set) var emissionPositionScale: CGFloat
        private (set) var scale: CGFloat
        private (set) var spinRange: CGFloat
        private (set) var speed: CGFloat
        
        init(backgroundColor: UIColor = .clear, emitterPositionScale: CGFloat = 1, image: CGImage?, emissionPositionScale: CGFloat = 2, scale: CGFloat = 0.03, spingRange: CGFloat = 0.01, speed: CGFloat = 100) {
            self.backgroundColor = backgroundColor
            self.emissionLongtitudeScale = emitterPositionScale
            self.image = image
            self.emissionPositionScale = emissionPositionScale
            self.scale = scale
            self.spinRange = spingRange
            self.speed = speed
        }
    }
    
    init(type: WeatherEvent) {
        self.eventType = type
        setupParameters()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate(in view: WeatherAnimator) {
        let emitter = createEmitterLayer(in: view)
        view.layer.insertSublayer(emitter, at: 0)
    }
    
    private func setupParameters() {
        switch eventType {
        case .rain:
            self.settings = .init(backgroundColor:  UIColor.gray, emitterPositionScale: -2, image: UIImage(named: eventType.rawValue)?.cgImage, emissionPositionScale: 1)
        case .thunderstorm:
            self.settings = .init(backgroundColor:  UIColor.gray, image: UIImage(named: eventType.rawValue)?.cgImage)
        case .snow, .man:
            self.settings = .init(backgroundColor:  UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0),
                                  emitterPositionScale: -2,
                                  image: UIImage(named: eventType.rawValue)?.cgImage,
                                  emissionPositionScale: 1,
                                  scale: 0.15,
                                  spingRange: 10)
        case .hail:
            self.settings = .init(backgroundColor:  UIColor.gray, emitterPositionScale: -1.2 , image: UIImage(named: eventType.rawValue)?.cgImage, emissionPositionScale: 1, speed: 250)
        default:
            break
        }
    }
    private func createEmitterLayer(in view: UIView) -> CAEmitterLayer {
        view.backgroundColor = settings?.backgroundColor
        
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: view.bounds.width / (settings?.emissionPositionScale ?? 1) , y: -50)
        emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.birthRate = 7
        cell.lifetime = 6.0
        cell.velocity = settings?.speed ?? 100
        cell.velocityRange = (settings?.speed ?? 100) / 5
        cell.emissionLongitude = CGFloat.pi / (settings?.emissionLongtitudeScale ?? 1)
        cell.yAcceleration = 100
        cell.spinRange = settings?.spinRange ?? 0.02
        cell.scale = settings?.scale ?? 0.01
        cell.scaleRange = 0.02
        cell.contents = self.settings?.image
        
        emitter.emitterCells = [cell]
        return emitter
    }
}
