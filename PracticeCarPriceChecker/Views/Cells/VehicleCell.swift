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
    let backgroundImage = UIImageView()
    let yearMakeModel   = VehicleTitleLabel()
    let trim            = VehicleTitleLabel()
    let price           = VehicleTitleLabel()
    let mileage         = VehicleTitleLabel()
    let saveStatusIcon  = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        configureUIElements()
        configureSaveStatusIconTapGesture()
        setContentPriorities()
        layoutUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(vehicle: Vehicle) {
        backgroundImage.image   = UIImage(named: vehicle.listingImage)
        yearMakeModel.text      = String(vehicle.year) + " " + vehicle.make + " " + vehicle.model
        trim.text               = String(vehicle.trim)
        price.text              = "$" + String(vehicle.price)
        mileage.text            = String(vehicle.mileage) + " mi"
    }
    
    
    func addSubViews() {
        contentView.addSubview(backgroundImage)
        contentView.addSubview(yearMakeModel)
        contentView.addSubview(trim)
        contentView.addSubview(price)
        contentView.addSubview(mileage)
        contentView.addSubview(saveStatusIcon)
    }
    
    
    func configureUIElements() {
        contentView.backgroundColor = .white
        
        backgroundImage.clipsToBounds   = true
        backgroundImage.contentMode     = .scaleAspectFill
        
        yearMakeModel.textAlignment     = .left
        yearMakeModel.font              = UIFont.systemFont(ofSize: 23, weight: .medium)
        yearMakeModel.lineBreakMode     = .byTruncatingTail
        
        trim.textAlignment              = .left
        trim.font                       = UIFont.systemFont(ofSize: 15, weight: .medium)
        trim.textColor                  = #colorLiteral(red: 0.6323581934, green: 0.6365062594, blue: 0.6509622931, alpha: 1)
        
        price.textAlignment             = .right
        price.font                      = UIFont.systemFont(ofSize: 27, weight: .medium)
        price.textColor                 = #colorLiteral(red: 0.9070844054, green: 0.6450381279, blue: 0, alpha: 1)
        
        mileage.textAlignment           = .right
        mileage.font                    = UIFont.systemFont(ofSize: 21, weight: .medium)
        mileage.textColor               = #colorLiteral(red: 0.6323581934, green: 0.6365062594, blue: 0.6509622931, alpha: 1)
        
        saveStatusIcon.image = UIImage(named: "unsaved")
        
    }
    
    
    func configureSaveStatusIconTapGesture() {
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTapping(recognizer:)))
        singleTap.numberOfTapsRequired = 1
        saveStatusIcon.addGestureRecognizer(singleTap)
        saveStatusIcon.isUserInteractionEnabled = true
    }

    
    @objc func singleTapping(recognizer: UIGestureRecognizer) {
        if saveStatusIcon.image == UIImage(named: "saved") {
            saveStatusIcon.image = UIImage(named: "unsaved")
        } else {
            saveStatusIcon.image = UIImage(named: "saved")
        }
    }
    
    
    func setContentPriorities() {
        yearMakeModel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        price.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
    }

    
    func layoutUI() {
        backgroundImage.translatesAutoresizingMaskIntoConstraints   = false
        yearMakeModel.translatesAutoresizingMaskIntoConstraints     = false
        trim.translatesAutoresizingMaskIntoConstraints              = false
        price.translatesAutoresizingMaskIntoConstraints             = false
        mileage.translatesAutoresizingMaskIntoConstraints           = false
        saveStatusIcon.translatesAutoresizingMaskIntoConstraints    = false

        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.70),
            
            yearMakeModel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 14),
            yearMakeModel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            yearMakeModel.trailingAnchor.constraint(equalTo: price.leadingAnchor, constant: -8),
            
            trim.topAnchor.constraint(equalTo: yearMakeModel.bottomAnchor, constant: 3),
            trim.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            price.centerYAnchor.constraint(equalTo: yearMakeModel.centerYAnchor),
            price.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            mileage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mileage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            saveStatusIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            saveStatusIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            saveStatusIcon.heightAnchor.constraint(equalToConstant: 40),
            saveStatusIcon.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
