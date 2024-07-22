import UIKit

final class MainViewController: UIViewController {
    
    private lazy var weatherView: WeatherAnimator = {
        let weatherView = WeatherAnimator(frame: view.bounds)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    private var animationTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weatherView)
        updateWeather(event: .man)
        // Start with a default weather event
//        WeatherAnimator.animateWeather(event: .clear, in: weatherView)
    }
    
    func updateWeather(event: WeatherEvent) {
        weatherView.currentWeather = event
        
        // Invalidate any existing timer
        animationTimer?.invalidate()
        
        // Schedule a timer to stop the animation after 10 seconds
        animationTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { [weak self] _ in
            self?.stopWeatherAnimation()
        }
    }
    
    private func stopWeatherAnimation() {
        // Implement the method to stop the animation
        weatherView.stopAnimation()
    }

}
