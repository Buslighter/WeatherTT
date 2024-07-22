import UIKit
import AVFoundation

final class MainViewController: UIViewController {

    private lazy var weatherView: WeatherAnimator = {
        let weatherView = WeatherAnimator(frame: view.bounds)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        return weatherView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: WeatherCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private var audioplayer: AVAudioPlayer?
    private var animationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white // Установим цвет фона ViewController
        
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
        
        // Scroll to the selected item to center it
        self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
//
//        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
//        let index: Int
//        
//        if velocity.x > 0 {
//            index = Int(ceil(estimatedIndex))
//        } else if velocity.x < 0 {
//            index = Int(floor(estimatedIndex))
//        } else {
//            index = Int(round(estimatedIndex))
//        }
//        
//        let safeIndex = max(0, min(index, WeatherEvent.allCases.count - 1))
//        let xOffset = CGFloat(safeIndex) * cellWidthIncludingSpacing - (collectionView.bounds.width - layout.itemSize.width) / 2
//        targetContentOffset.pointee = CGPoint(x: xOffset, y: 0)
//    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 20
        let width = collectionView.bounds.width - inset * 2
        return CGSize(width: width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 20
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
}

final class WeatherCell: UICollectionViewCell {
    static let identifier = "weatherCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ])
    }
    
    func configure(with event: WeatherEvent) {
        label.text = event.rawValue.capitalized
    }
}
