//
//  ForecastTableViewCell.swift
//  DVT Weather
//
//  Created by Kato Drake Smith on 04/08/2023.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    //MARK: - Propeties
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let forecastImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.setDimensions(width: 35.0, height: 35.0)
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    private func setupUI() {
        addSubview(dayLabel)
        addSubview(forecastImageView)
        addSubview(temperatureLabel)
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        temperatureLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingLeft: 16)
        
        forecastImageView.centerX(inView: self)
        forecastImageView.centerY(inView: self)
        
        temperatureLabel.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 16)
    }
}

