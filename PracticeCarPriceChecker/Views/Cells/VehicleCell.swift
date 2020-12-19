//
//  VehicleCell.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 12/16/20.
//  Copyright © 2020 Abraham Shenghur. All rights reserved.
//

import UIKit

class VehicleCell: UICollectionViewCell {
    
    static let reuseID  = "VehicleCell"
    let containerView   = UIView()
    let backgroundImage = UIImageView()
    let yearMakeModel   = VehicleTitleLabel()
    let price           = VehicleTitleLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContainerView()
        configureSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(vehicle: Vehicle) {
        backgroundImage.image   = UIImage(named: vehicle.listingImage)
        yearMakeModel.text      = String(vehicle.year) + " " + vehicle.make + " " + vehicle.model
        price.text              = "$" + String(vehicle.price)
    }
    
    
    func configureContainerView() {
        addSubview(containerView)
        containerView.layer.cornerRadius    = 16
        containerView.layer.borderWidth     = 2
        containerView.layer.borderColor     = UIColor.white.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    
    func configureSubviews() {
        let blurEffect          = UIBlurEffect(style: .extraLight)
        let blurredEffectView   = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.alpha = 0.9
        
        containerView.addSubview(backgroundImage)
        containerView.addSubview(blurredEffectView)
        containerView.addSubview(yearMakeModel)
        containerView.addSubview(price)
        
        blurredEffectView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        yearMakeModel.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false

        backgroundImage.contentMode = .scaleAspectFill
        yearMakeModel.textAlignment = .center
        price.textAlignment         = .center
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            blurredEffectView.topAnchor.constraint(equalTo: yearMakeModel.topAnchor),
            blurredEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredEffectView.heightAnchor.constraint(equalToConstant: 40),
            
            yearMakeModel.bottomAnchor.constraint(equalTo: price.topAnchor),
            yearMakeModel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            yearMakeModel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            yearMakeModel.heightAnchor.constraint(equalToConstant: 20),
            
            price.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            price.leadingAnchor.constraint(equalTo: leadingAnchor),
            price.trailingAnchor.constraint(equalTo: trailingAnchor),
            price.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
}
