//
//  UIComponents.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 03/08/2023.
//

import UIKit

//MARK: - UIComponents
class UIComponents {
    
    private let cloudyColor = UIColor(named: "cloudyColor")
    private let rainyColor = UIColor(named: "rainyColor")
    private let sunnyColor = UIColor(named: "sunnyColor")
    
    private let seaSunnyImage = UIImage(named: "sea_sunny")
    private let seaRainyImage = UIImage(named: "sea_rainy")
    private let seaCloudyImage = UIImage(named: "sea_cloudy")
    
    
    func weatherIcon(condition: WeatherCondition) -> UIImage? {
        switch condition {
        case .rain:
            return UIImage(named: "rain")
        case .clear:
            return UIImage(named: "clear")
        case .cloudy:
            return UIImage(named: "cloudy")
        }
    }
    
    func backgroundColor(condition: WeatherCondition) -> UIColor {
        switch condition {
        case .rain:
            return rainyColor!
        case .clear:
            return sunnyColor!
        case .cloudy:
            return cloudyColor!
        }
    }
    
    func backgroundImage(condition: WeatherCondition) -> UIImage? {
        switch condition {
        case .rain:
            return seaRainyImage
        case .clear:
            return seaSunnyImage
        case .cloudy:
            return seaCloudyImage
        }
    }
    
    //MARK: - Display Weather Icon
    func displayWeatherIcon(conditionString: String) -> UIImage? {
        let lowercaseCondition = conditionString.lowercased()
        var condition: WeatherCondition
        
        if lowercaseCondition.contains(WeatherCondition.rain.rawValue) {
            condition = .rain
        } else if lowercaseCondition.contains(WeatherCondition.clear.rawValue) {
            condition = .clear
        } else {
            condition = .cloudy
        }
        
        return weatherIcon(condition: condition)
    }
    //MARK: - DisplayBackground Color
    func displayBackgroundColor(conditionString: String) -> UIColor {
        let lowercaseCondition = conditionString.lowercased()
        var condition: WeatherCondition
        
        if lowercaseCondition.contains(WeatherCondition.rain.rawValue) {
            condition = .rain
        } else if lowercaseCondition.contains(WeatherCondition.clear.rawValue) {
            condition = .clear
        } else {
            condition = .cloudy
        }
        
        return backgroundColor(condition: condition)
    }
    
    //MARK: - DisplayBackground Image
    func displayBackgroundImage(conditionString: String) -> UIImage? {
        let lowercaseCondition = conditionString.lowercased()
        var condition: WeatherCondition
        
        if lowercaseCondition.contains(WeatherCondition.rain.rawValue) {
            condition = .rain
        } else if lowercaseCondition.contains(WeatherCondition.clear.rawValue) {
            condition = .clear
        } else {
            condition = .cloudy
        }
        
        return backgroundImage(condition: condition)
    }
    
    
    //MARK: - Temperature Formatter
    func formatTemperature(degrees: Double) -> String {
        let roundedDegrees = Int(round(degrees))
        return "\(roundedDegrees)°C"
    }
    func formattedTemperature(min: Double, max: Double) -> String {
        let minTemperature = UIComponents().formatTemperature(degrees: min)
        let maxTemperature = UIComponents().formatTemperature(degrees: max)
        return "L: \(minTemperature) H: \(maxTemperature)"
    }
    
    
    func urlEncode(_ string: String) -> String? {
        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}






//MARK: - Anchor Properties

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil, constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}




// MARK: - UIColor
extension UIColor {
    convenience init(hex hexString: String) {
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}





//MARK: - Date Formmater
extension Date {
    func getTimeForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func getHourForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func getDayForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
}




//MARK: - Weather Details
extension CurrentWeatherData {
    
    var dayLabel: String {
        return Date(timeIntervalSince1970: Double(dt)).getDayForDate()
    }
    
    var weatherIcon: UIImage? {
        let lowercaseMain = weather[0].main.lowercased()
        if lowercaseMain.contains(WeatherCondition.rain.rawValue) {
            return UIImage(named: "rain")
        } else if lowercaseMain.contains(WeatherCondition.clear.rawValue) {
            return UIImage(named: "clear")
        } else {
            return UIImage(named: "partlysunny")
        }
    }
}
