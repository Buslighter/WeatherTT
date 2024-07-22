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
        // Clear any existing subviews or layers
        subviews.forEach { $0.removeFromSuperview() }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let animator: WeatherAnimation?
        
        switch event {
        case .clear:
            animator = DownfallAnimation(type: event)
        case .rain, .hail, .snow, .man:
            animator = DownfallAnimation(type: event)
        case .thunderstorm:
            animator = DownfallAnimation(type: event)
        case .fog:
            animator = DownfallAnimation(type: event)
        case .cloudy:
            animator = DownfallAnimation(type: event)
        case .windy:
            animator = DownfallAnimation(type: event)
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


