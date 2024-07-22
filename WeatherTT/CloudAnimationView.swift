import UIKit

class WeatherAnimator: UIView {
    
    var currentWeather: WeatherEvent = .clear {
        didSet {
            animateWeather(event: currentWeather)
        }
    }
    func stopAnimation() {
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    init(frame: CGRect, initialWeather: WeatherEvent = WeatherEvent.allCases.randomElement() ?? .clear) {
        self.currentWeather = initialWeather
        super.init(frame: frame)
        self.animateWeather(event: initialWeather)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func animateWeather(event: WeatherEvent) {
        // Clear any existing subviews or layers
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        var animator: WeatherAnimation? // let
        animator = DownfallAnimation(type: .rain) // delete
        
        switch event {
        case .clear:
            animateClear()
        case .rain, .hail, .snow, .man:
            animator = DownfallAnimation(type: event)
        case .thunderstorm:
            animateThunderstorm()
        case .fog:
            animateFog()
        case .cloudy:
            animateCloudy()
        case .windy:
            animateWindy()
        }
        if let animator = animator {
            animator.animate(in: self)
        }
    }
    
    private func animateClear() {
        backgroundColor = UIColor.blue
    }
    
    private func animateThunderstorm() {
        backgroundColor = UIColor.darkGray
        
        let lightningView = UIView(frame: bounds)
        lightningView.backgroundColor = UIColor.white
        lightningView.alpha = 0
        addSubview(lightningView)
        
        UIView.animate(withDuration: 0.2, delay: 1.0, options: [.autoreverse, .repeat], animations: {
            lightningView.alpha = 1.0
        }, completion: nil)
    }
    
    private func animateFog() {
        backgroundColor = UIColor.lightGray
        
        let fogView = UIView(frame: bounds)
        fogView.backgroundColor = UIColor.white
        fogView.alpha = 0.8
        addSubview(fogView)
        
        UIView.animate(withDuration: 5.0, delay: 0, options: [.autoreverse, .repeat], animations: {
            fogView.alpha = 0.4
        }, completion: nil)
    }
    
    private func animateCloudy() {
        backgroundColor = UIColor.lightGray
        
        let cloudImageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 200, height: 100))
        cloudImageView.image = UIImage(named: "cloud")
        addSubview(cloudImageView)
        
        UIView.animate(withDuration: 10.0, delay: 0, options: [.curveLinear, .repeat], animations: {
            cloudImageView.frame.origin.x = self.bounds.width
        }, completion: nil)
    }
    
    private func animateWindy() {
        backgroundColor = UIColor.cyan
        
        let windImageView = UIImageView(frame: CGRect(x: 0, y: bounds.height / 2, width: 100, height: 100))
        windImageView.image = UIImage(named: "wind")
        addSubview(windImageView)
        
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            windImageView.frame.origin.x = self.bounds.width - 100
        }, completion: nil)
    }
}
protocol WeatherAnimation {
    func animate(in view: WeatherAnimator)
}


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
        init(backgroundColor: UIColor = .clear, emitterPositionScale: CGFloat = 1, image: CGImage?, emissionPositionScale: CGFloat = 2, scale: CGFloat = 0.03, spingRange: CGFloat = 0.01) {
            self.backgroundColor = backgroundColor
            self.emissionLongtitudeScale = emitterPositionScale
            self.image = image
            self.emissionPositionScale = emissionPositionScale
            self.scale = scale
            self.spinRange = spingRange
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
            self.settings = .init(backgroundColor:  UIColor.gray, emitterPositionScale: -2, image: UIImage(named: eventType.rawValue)?.cgImage, emissionPositionScale: 1, scale: 0.15, spingRange: 10)
        case .hail:
            self.settings = .init(backgroundColor:  UIColor.gray, emitterPositionScale: -2 , image: UIImage(named: eventType.rawValue)?.cgImage, emissionPositionScale: 1)
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
        cell.velocity = 100 // 100
        cell.velocityRange = 80 //20
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
