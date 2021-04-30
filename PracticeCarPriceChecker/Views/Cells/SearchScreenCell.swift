//
//  SearchScreenCell.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 2/10/21.
//  Copyright © 2021 Abraham Shenghur. All rights reserved.
//

import UIKit

class SearchScreenCell: UITableViewCell {
    
    static let reuseID = "SearchScreenCell"
    
    var carLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(carLabel)
        
        carLabel.translatesAutoresizingMaskIntoConstraints = false
        carLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            carLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            carLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            carLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            carLabel.heightAnchor.constraint(equalToConstant: 35)
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
