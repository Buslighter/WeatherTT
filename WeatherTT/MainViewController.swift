import UIKit

final class MainViewController: UIViewController {
    
    private lazy var weatherView: WeatherAnimator = {
        let weatherView = WeatherAnimator(frame: view.bounds)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(weatherView)
        updateWeather(event: .rain)
        // Start with a default weather event
//        WeatherAnimator.animateWeather(event: .clear, in: weatherView)
    }
    
    func updateWeather(event: WeatherEvent) {
        weatherView.currentWeather = event
    }

}
