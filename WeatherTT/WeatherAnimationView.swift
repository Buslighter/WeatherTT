import UIKit

protocol WeatherAnimation {
    func animate(in view: WeatherAnimator)
}

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
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        switch event {
        case .clear:
            animateClear()
        case .rain, .hail, .snow, .man:
            let animator = DownfallAnimation(type: event)
            animator.animate(in: self)
        case .thunderstorm:
            animateThunderstorm()
        case .fog:
            animateFog()
        case .cloudy:
            animateCloudy()
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
        
        let cloudImageView = UIImageView(frame: CGRect(x: 0, y: 300, width: 200, height: 100))
        cloudImageView.image = UIImage(named: "cloud")
        addSubview(cloudImageView)
        
        UIView.animate(withDuration: 7.0, delay: 0, options: [.autoreverse, .curveLinear, .repeat], animations: {
            cloudImageView.frame.origin.x = self.bounds.width - 200
        }, completion: nil)
    }
}
