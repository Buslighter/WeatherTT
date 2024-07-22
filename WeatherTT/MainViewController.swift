import UIKit
import AVFoundation

final class MainViewController: UIViewController {

    private lazy var weatherView: WeatherAnimator = {
        let weatherView = WeatherAnimator(frame: view.bounds)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    private lazy var collectionView: UICollectionView = {
        var collectionView: UICollectionView!
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private var audioplayer: AVAudioPlayer?
    private var animationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(weatherView)
        view.addSubview(collectionView)
        setupConstraints()
        setupAudioPlayer()
        updateWeather(event: .clear)
    }
    
    func updateWeather(event: WeatherEvent) {
        weatherView.currentWeather = event
    
        animationTimer?.invalidate()
        
        if event == .man {
            audioplayer?.play()
        } else if let _ = audioplayer?.isPlaying {
            audioplayer?.stop()
        }
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false) { [weak self] _ in
            self?.stopWeatherAnimation()
        }
    }
    
    private func setupAudioPlayer() {
        guard let path = Bundle.main.path(forResource: "rainingmen", ofType: "mp3") else {
            print("Audio file not found")
            return
        }
        do {
            let url = URL(filePath: path)
            self.audioplayer = try AVAudioPlayer(contentsOf: url)
            self.audioplayer?.prepareToPlay()
        } catch let error {
            print("Failed to initialize AVAudioPlayer: \(error.localizedDescription)")
        }
    }
    
    private func stopWeatherAnimation() {
        weatherView.stopAnimation()
    }
    
    // MARK: - UI Methods
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 120),
            
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherEvent.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }
        let weatherEvent = WeatherEvent.allCases[indexPath.item]
        cell.configure(with: weatherEvent)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedEvent = WeatherEvent.allCases[indexPath.item]
        updateWeather(event: selectedEvent)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

// MARK: - UIScrollViewDelegate
extension MainViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            let selectedEvent = WeatherEvent.allCases[indexPath.item]
            updateWeather(event: selectedEvent)
            print("Current Page: \(indexPath.item)")
        }
    }
}
