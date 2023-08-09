//
//  WeatherInfoView.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 03/08/2023.
//

import UIKit

class WeatherInfoView: UIView {
    
    //MARK: - Propeties
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    let weatherTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let minLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let currentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let maxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Helpers
    private func setupUI() {
        addSubview(backgroundImage)
        backgroundImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
        let topStackView = UIStackView(arrangedSubviews: [locationLabel, temperatureLabel, weatherTypeLabel])
        topStackView.axis = .vertical
        topStackView.alignment = .center
        topStackView.spacing = 15.0
        addSubview(topStackView)
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 30, paddingLeft: 16, paddingRight: 16)
        
        if bottomStackView.arrangedSubviews.isEmpty {
            bottomStackView.addArrangedSubview(createNestedStackView(label: "", value: ""))
            bottomStackView.addArrangedSubview(createNestedStackView(label: "", value: ""))
            bottomStackView.addArrangedSubview(createNestedStackView(label: "", value: ""))
            addSubview(bottomStackView)
            bottomStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 30.0,  paddingLeft: 25, paddingBottom: 3, paddingRight: 25)
        }
    }
    
    func createNestedStackView(label: String, value: String) -> UIStackView {
        let labelLabel = UILabel()
        labelLabel.text = label
        labelLabel.textColor = .white
        labelLabel.font = UIFont.boldSystemFont(ofSize: 15)
        labelLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textColor = .white
        valueLabel.font = UIFont.boldSystemFont(ofSize: 17)
        valueLabel.textAlignment = .center
        
        let nestedStackView = UIStackView(arrangedSubviews: [valueLabel, labelLabel])
        nestedStackView.axis = .vertical
        nestedStackView.alignment = .center
        nestedStackView.distribution = .fill
        return nestedStackView
    }
    
    
    func createBarButtonItem(imageName: String, action: Selector) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        barButtonItem.tintColor = .white
        return barButtonItem
    }
}
