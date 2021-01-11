//
//  ViewController.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 12/12/20.
//  Copyright © 2020 Abraham Shenghur. All rights reserved.
//

import UIKit
import SafariServices

class VehicleListVC: UIViewController {
    
    var vehicles: [Vehicle] = []
    
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Random Vehicle Prices"
        vehicles = fetchData()
        configureCollectionView()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.8446617126, green: 0.9358935952, blue: 0.7635106444, alpha: 1)]
    }
    
    
    private struct Constants {
        static let minimumLineSpacing: CGFloat      = 20
        static let minimumInteritemSpacing: CGFloat = 8
        static let edgeSpacingTop: CGFloat          = 20
        static let edgeSpacingBottom: CGFloat       = 20
        static let edgeSpacingRight: CGFloat        = 8
        static let edgeSpacingLeft: CGFloat         = 8
    }
    
    
    func configureCollectionView() {
        let cellSize = view.bounds.size.width - Constants.minimumLineSpacing
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
        flowLayout.minimumInteritemSpacing = Constants.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = Constants.minimumLineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: Constants.edgeSpacingTop,
                                               left: Constants.edgeSpacingLeft,
                                               bottom: Constants.edgeSpacingBottom,
                                               right: Constants.edgeSpacingRight)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.8632575274, green: 0.9452304244, blue: 0.794632256, alpha: 1)
        collectionView.register(VehicleCell.self, forCellWithReuseIdentifier: VehicleCell.reuseID)
        
        view.addSubview(collectionView)
    }
    
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        
        self.present(safariVC, animated: true)
    }
    
    
    func didTapCell(of vehicle: Vehicle) {
        guard let url = URL(string: vehicle.listingURL!) else {
            return
        }
        
        presentSafariVC(with: url)
    }
}


extension VehicleListVC: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}


extension VehicleListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vehicleListing = vehicles[indexPath.row]
        
        didTapCell(of: vehicleListing)
    }
}


extension VehicleListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VehicleCell.reuseID, for: indexPath) as! VehicleCell
        cell.clipsToBounds = true

        cell.layer.shadowColor      = UIColor.lightGray.cgColor
        cell.layer.shadowOffset     = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius     = 2.0
        cell.layer.shadowOpacity    = 1.0
        cell.layer.masksToBounds    = false;
        cell.layer.shadowPath       = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        let vehicle = vehicles[indexPath.row]
        cell.set(vehicle: vehicle)
        
        return cell
    }
}


extension VehicleListVC {
    
    func fetchData() -> [Vehicle] {
        let vehicles = VehicleList.tenRandomVehicles
        return vehicles
    }
}





