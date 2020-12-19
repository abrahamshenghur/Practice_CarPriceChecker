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
    }
    
    
    private struct Constants {
        static let minimumLineSpacing: CGFloat      = 8
        static let minimumInteritemSpacing: CGFloat = 8
        static let edgeSpacingTop: CGFloat          = 8
        static let edgeSpacingBottom: CGFloat       = 8
        static let edgeSpacingRight: CGFloat        = 8
        static let edgeSpacingLeft: CGFloat         = 8
    }
    
    
    func configureCollectionView() {
        let cellSize = ((view.bounds.size.width - (Constants.minimumLineSpacing * 3)) / 2)
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
        collectionView.backgroundColor = .black
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
        cell.layer.cornerRadius = 16
        cell.layer.borderWidth  = 2
        cell.layer.borderColor  = #colorLiteral(red: 0.8314041495, green: 0.8314985037, blue: 0.8227116466, alpha: 1)
        cell.clipsToBounds      = true
        
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





