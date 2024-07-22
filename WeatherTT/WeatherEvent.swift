import Foundation

enum WeatherEvent: String, CaseIterable {
    case clear
    case rain
    case thunderstorm
    case fog
    case snow
    case cloudy
    case hail
    case man
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
