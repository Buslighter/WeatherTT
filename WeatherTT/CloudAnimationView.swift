import UIKit

class WeatherAnimator: UIView {
    
    var currentWeather: WeatherEvent = .clear {
        didSet {
            animateWeather(event: currentWeather)
        }
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
        
        switch event {
        case .clear:
            animateClear()
        case .rain:
            animateRain()
        case .thunderstorm:
            animateThunderstorm()
        case .fog:
            animateFog()
        case .snow:
            animateSnow()
        case .cloudy:
            animateCloudy()
        case .windy:
            animateWindy()
        case .hail:
            animateHail()
        }
    }
    
    private func animateClear() {
        backgroundColor = UIColor.blue
    }
    
    private func animateRain() {
        backgroundColor = UIColor.gray

        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterPosition = CGPoint(x: bounds.width / 2, y: -50)
        emitter.emitterSize = CGSize(width: bounds.width, height: 1)

        let cell = CAEmitterCell()
        cell.birthRate = 2
        cell.lifetime = 6.0
        cell.velocity = 80
        cell.velocityRange = 20
        cell.emissionLongitude = CGFloat.pi
        cell.yAcceleration = 100
        cell.spinRange = 0.1
        cell.scale = 0.03
        cell.scaleRange = 0.02
        cell.contents = UIImage(named: "raindrop")?.cgImage

        emitter.emitterCells = [cell]
        layer.insertSublayer(emitter, at: 0)
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
    
    private func animateSnow() {
        backgroundColor = UIColor.white
        
        let snowLayer = CAEmitterLayer()
        snowLayer.emitterShape = .line
        snowLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)
        snowLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        
        let snowCell = CAEmitterCell()
        snowCell.birthRate = 10
        snowCell.lifetime = 10.0
        snowCell.velocity = 30
        snowCell.scale = 0.1
        snowCell.contents = UIImage(named: "snowflake")?.cgImage
        
        snowLayer.emitterCells = [snowCell]
        layer.addSublayer(snowLayer)
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
    
    private func animateHail() {
        backgroundColor = UIColor.darkGray
        
        let hailLayer = CAEmitterLayer()
        hailLayer.emitterShape = .line
        hailLayer.emitterPosition = CGPoint(x: bounds.width / 2, y: 0)
        hailLayer.emitterSize = CGSize(width: bounds.width, height: 1)
        
        let hailCell = CAEmitterCell()
        hailCell.birthRate = 50
        hailCell.lifetime = 3.0
        hailCell.velocity = 200
        hailCell.scale = 0.2
        hailCell.contents = UIImage(named: "hail")?.cgImage
        
        hailLayer.emitterCells = [hailCell]
        layer.addSublayer(hailLayer)
    }
}
