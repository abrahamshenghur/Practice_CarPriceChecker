//
//  SearchVC.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 1/11/21.
//  Copyright © 2021 Abraham Shenghur. All rights reserved.
//

import UIKit
import SafariServices

enum Section: Int {
    case website = 0
    case vehcileMake = 1
    case vehicleModel = 2
}


struct ExpandableSectionData {
    var isExpanded: Bool
    var title: String
    var data: [String]
    
    var numberOfItems: Int {
        return data.count
    }
    
    subscript(index: Int) -> String {
        return data[index]
    }
}


extension ExpandableSectionData {
    init(isExpanded: Bool, title: String, data: String...) {
        self.isExpanded = isExpanded
        self.title = title
        self.data = data
    }
}


class SearchVC: UIViewController, SFSafariViewControllerDelegate {
    
    let logoView = UIView()
    var tableView = UITableView()
    let searchButton = Button(title: "Search for Vehicles")
    
    var expandableSections: [ExpandableSectionData] = []
    var websites = [String]()
    var makes = [String]()
    var models = [String]()
    var modelsUsingAutotraderQuery = [String]()
    var modelsUsingCarsDotComQuery = [String]()
    var modelsUsingCarGurusQuery = [String]()   // Array items correspond to items in [models] above; needed for CarGurus url query item
    var modelsUsingTrueCarQuery = [String]()

    var buttonOfSectionAlreadyOpen = UIButton() // Allows for one section to be open at a time by closing one that was open prior

    var selectedWebsite = String()
    var selectedVehicleMake = String()
    
    var vehicleModelsDictionary: [String: [Model]] = [:]  // Dynamically shows models of 3rd section based on vehicle make in 2nd section
    var selectedVehicleModel = String() // Stored value eventually used to build url for given website
    var selectedVehicleModelUsingCarsDotComQuery = String()
    var selectedVehicleModelUsingCarGurusQuery = String()
    var selectedVehicleModelUsingAutotraderQuery = String()
    var selectedVehicleModelUsingTrueCarQuery = String()

    var websiteName         = String()
    var websiteHost         = String()
    var websitePath         = String()
    var queryItems          = String()
    var websiteURLComponents = [Website]()
    
    let autotraderVehicleMakes = ["acura": "ACURA", "alfa romeo": "ALFA", "aston martin": "ASTON", "audi": "AUDI", "bentley": "BENTL", "bmw": "BMW", "buick": "BUICK", "cadillac": "CAD", "chevrolet": "CHEV", "chrysler": "CHRY", "dodge": "DODGE", "ferrari": "FER", "fiat": "FIAT", "fisker": "FISK", "ford": "FORD", "freightliner": "FREIGHT", "genesis": "GENESIS", "gmc": "GMC", "honda": "HONDA", "hummer": "AMGEN","hyundai": "HYUND", "infiniti": "INFIN", "isuzu": "ISU", "jaguar": "JAG", "jeep": "JEEP", "karma": "KARMA", "kia": "KIA", "lamborghini": "LAM", "land rover": "ROV" ,"lexus": "LEXUS", "lincoln": "LINC", "lotus": "LOTUS", "maserati": "MAS", "maybach": "MAYBACH", "mazda": "MAZDA", "mclaren": "MCLAREN", "mercedes-benz" : "MB", "mercury": "MERC", "mini": "MINI", "mitsubishi": "MIT", "nissan": "NISSAN", "oldsmobile": "OLDS", "plymouth": "PLYM", "pontiac": "PONT", "porsche": "POR", "ram": "RAM", "rolls-royce": "RR", "saab": "SAAB", "saturn": "SATURN", "scion": "SCION", "smart": "SMART", "subaru": "SUB", "suzuki": "SUZUKI", "tesla": "TESLA", "toyota": "TOYOTA", "volkswagen": "VOLKS", "volvo": "VOLVO"]

    let carsDotComVehicleMakes = ["acura": "20001", "alfa romeo": "20047", "aston martin": "20003", "audi": "20049", "bentley": "20051", "bmw": "20005", "buick": "20006", "cadillac": "20052", "chevrolet": "20053", "chrysler": "20008", "dodge": "20012", "ferrari": "20014", "fiat": "20060", "fisker": "41703", "ford": "20015","genesis": "35354491", "gmc": "20061", "honda": "20017", "hummer": "20018","hyundai": "20064", "infiniti": "20019", "isuzu": "20020", "jaguar": "20066", "jeep": "20021", "karma": "36365359", "kia": "20068", "lamborghini": "20069", "land rover": "20024" ,"lexus": "20070", "lincoln": "20025", "lotus": "20071", "maserati": "20072", "maybach": "20027", "mazda": "20073", "mclaren": "47903", "mercedes-benz" : "20028", "mercury": "20074", "mini": "20075", "mitsubishi": "20030", "nissan": "20077", "oldsmobile": "20032", "plymouth": "20080", "pontiac": "20035", "porsche": "20081", "ram": "44763", "rolls-royce": "20037", "saab": "20038", "saturn": "20039", "scion": "20085", "smart": "20228", "subaru": "20041", "suzuki": "20042", "tesla": "28263", "toyota": "20088", "volkswagen": "20089", "volvo": "20044"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVehicle()
        createSections()
        configureViewController()
        configureLogoView()
        configureTableView()
        configureSearchButton()
        layoutUI()
    }
    
    
    func getVehicle() {
        if let url = Bundle.main.url(forResource: "VehiclesJSON", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let response = try decoder.decode(LocalJSONResponse.self, from: data)
                
                for website in response.websites {
                    let name = website.name
                    let scheme = website.scheme
                    let host = website.host
                    let path = website.path
                    let query = website.query
                    let urlComponents = Website(name: name, scheme: scheme, host: host, path: path, query: query)
                    websites.append(urlComponents.name) // Section 0 row item textLabels
                    websiteURLComponents.append(urlComponents)
                }
                
                for vehicle in response.vehicles {
                    let vehicleMake = vehicle.make
                    let vehicleModels = vehicle.models
                    let vehicle = Vehicle(make: vehicleMake, models: vehicleModels)
                    makes.append(vehicle.make)      // Data for 2nd section dropdown menu
                    vehicleModelsDictionary[vehicle.make] = vehicleModels   // Make a dictionary for filtering vehicle models
                }
            } catch {
                print("Catch Error")
            }
        }
    }
    
    
    func createSections() {
        expandableSections = [
            ExpandableSectionData(isExpanded: false, title: "Websites", data: websites),
            ExpandableSectionData(isExpanded: false, title: "Makes", data: makes),
            ExpandableSectionData(isExpanded: false, title: "Models", data: models)
        ]
    }
    
    
    func getVehicleModels(for selectedMake: String) {
        let accessVehicleModels = vehicleModelsDictionary[selectedMake]
        var retrievedVehicleModels = [String]() // row item text label
        
        // Used to construct URL path for chosen website, b/c they differ
        var autotraderQuery = [String]()
        var carsDotComQuery = [String]()
        var carGurusQuery = [String]()
        var trueCarQuery = [String]()
        
        for model in accessVehicleModels! {
            retrievedVehicleModels.append(model.name)
            autotraderQuery.append(model.autotraderQuery)
            carsDotComQuery.append(model.carsDotComQuery)
            carGurusQuery.append(model.carGurusQuery)
            trueCarQuery.append(model.trueCarQuery)
        }
        
        expandableSections[Section.vehicleModel.rawValue].data = retrievedVehicleModels // Dynamically get models based on selected make
        modelsUsingAutotraderQuery = autotraderQuery
        modelsUsingCarsDotComQuery = carsDotComQuery
        modelsUsingCarGurusQuery = carGurusQuery
        modelsUsingTrueCarQuery = trueCarQuery
    }
    
    
    func configureViewController() {
        view.backgroundColor = #colorLiteral(red: 0.8632575274, green: 0.9452304244, blue: 0.794632256, alpha: 1)
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        navigationController?.navigationBar.barStyle = .blackOpaque
    }
    
    
    func configureLogoView() {
        view.addSubview(logoView)
        logoView.backgroundColor = navigationController?.navigationBar.barTintColor
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = #colorLiteral(red: 0.8632575274, green: 0.9452304244, blue: 0.794632256, alpha: 1)
        tableView.layer.cornerRadius = 20
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchScreenCell.self, forCellReuseIdentifier: SearchScreenCell.reuseID)
    }
    
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        searchButton.layer.cornerRadius = 10
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    
    @objc func searchButtonTapped() {
        let make = selectedVehicleMake
        let model = selectedVehicleModel

        let url = buildURL(make, model)
        let safariVC = SFSafariViewController(url: url!)
        safariVC.delegate = self
        
        self.present(safariVC, animated: true)
    }
    
    func buildURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = websiteHost

        if websiteName == "Craigslist" {
            components.path = websitePath
            components.queryItems = [
                URLQueryItem(name: "query", value: "\(make)+\(model)"),
                URLQueryItem(name: "purveyor-input", value: "all")
            ]
        } else if websiteName == "AutoTrader" {
            var autotraderVehicleMakeCode = String()
            if let make = autotraderVehicleMakes[make] {
                autotraderVehicleMakeCode = make
            }
            components.path = websitePath
            components.queryItems = [
                URLQueryItem(name: "makeCodeList", value: "\(autotraderVehicleMakeCode)"),
                URLQueryItem(name: "modelCodeList", value: "\(selectedVehicleModelUsingAutotraderQuery)"),
                URLQueryItem(name: "seriesCodeList", value: "\(selectedVehicleModelUsingAutotraderQuery)")
            ]
        } else if websiteName == "Cars.com" {
            var carsDotComVehicleMakeCode = String()
            if let make = carsDotComVehicleMakes[make] {
                carsDotComVehicleMakeCode = make
            }
            components.path = websitePath
            components.queryItems = [
                URLQueryItem(name: "mdId", value: "\(selectedVehicleModelUsingCarsDotComQuery)"),
                URLQueryItem(name: "mkId", value: "\(carsDotComVehicleMakeCode)"),
                URLQueryItem(name: "rd", value: "20"),
                URLQueryItem(name: "searchSource", value: "QUICK_FORM"),
                URLQueryItem(name: "stkTypId", value: "28881")
            ]
        } else if websiteName == "CarGurus" {
            components.path = websitePath
            components.queryItems = [
                URLQueryItem(name: "sourceContext", value: "carGurusHomePageModel"),
                URLQueryItem(name: "entitySelectingHelper.selectedEntity", value: "\(selectedVehicleModelUsingCarGurusQuery)"),
            ]
        } else if websiteName == "TrueCar" {
            components.path = websitePath + "/\(make)/\(selectedVehicleModelUsingTrueCarQuery)"
            components.queryItems = [
                URLQueryItem(name: "sort[]", value: "best_match")
            ]
        }
        
        return components.url
    }
    
    func layoutUI() {
        let padding = CGFloat(20)
        logoView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.topAnchor),
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40),
            
            tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -20),
            
            searchButton.heightAnchor.constraint(equalToConstant: 60),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -65)
        ])
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = expandableSections[section].title
        let button = Button(title: title)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        let border = UIView(frame: CGRect(x: self.tableView.bounds.width * 1/3, y: 0, width: self.tableView.bounds.width * 1/3, height: 1))
        border.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
        
        if section == 1 || section == 2 {   // Add lines for visual separation of sections
            button.addSubview(border)
        }

        if expandableSections[section].isExpanded {
            button.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.setTitleColor(.black, for: .normal)
        }
        
        return button
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expandableSections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !expandableSections[section].isExpanded {
            return 0
        } else {
            return expandableSections[section].numberOfItems
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchScreenCell.reuseID, for: indexPath) as! SearchScreenCell
        let item = expandableSections[indexPath.section].data[indexPath.row]

        if indexPath.section == Section.vehcileMake.rawValue {
            cell.carLabel.text = item.capitalized   // json file has lowercased vehicle makes
        } else {
            cell.carLabel.text = item
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let rowItem = indexPath.row
        let selectedRowItem = expandableSections[section].data[rowItem]

        let isExpanded = expandableSections[section].isExpanded

        if section == Section.website.rawValue {
            selectedWebsite = selectedRowItem
            expandableSections[section].title = selectedRowItem
            websiteName = websiteURLComponents[rowItem].name
            websiteHost = websiteURLComponents[rowItem].host
            websitePath = websiteURLComponents[rowItem].path
        } else if section == Section.vehcileMake.rawValue {
            selectedVehicleMake = selectedRowItem
            expandableSections[section].title = selectedRowItem.capitalized
            getVehicleModels(for: selectedVehicleMake)
            getVehicle()    // Dynamically display models based on selected make
        } else if section == Section.vehicleModel.rawValue {
            selectedVehicleModel = selectedRowItem
            selectedVehicleModelUsingAutotraderQuery = modelsUsingAutotraderQuery[rowItem]
            selectedVehicleModelUsingCarsDotComQuery = modelsUsingCarsDotComQuery[rowItem]
            selectedVehicleModelUsingCarGurusQuery = modelsUsingCarGurusQuery[rowItem]
            selectedVehicleModelUsingTrueCarQuery = modelsUsingTrueCarQuery[rowItem]
            expandableSections[section].title = selectedRowItem
        }

        expandableSections[section].isExpanded = !isExpanded
        tableView.reloadSections([section], with: .fade)
    }
}


extension SearchVC {
    
    @objc func handleExpandClose(button: UIButton) {
        let section = button.tag
        let indexPaths = [IndexPath]()  /// Collect all the rows inside this empty array of indexpaths
        
        getVehicle()

        switch section {
        case 0:
            buttonOfSectionAlreadyOpen = button
        case 1:
            buttonOfSectionAlreadyOpen = button
        case 2:
            buttonOfSectionAlreadyOpen = button
        default:
            print("NO SELECTION")
        }

        if expandableSections[section].isExpanded == false {
            if expandableSections[section].data.count == 0 {
                expandableSections[section].isExpanded = false
                return
            } else {    // Do a check for any sections already expanded; collapse it before expanding the other section that's tapped
                let sections = expandableSections
                if let sectionCurrentlyExpanded = sections.firstIndex(where: { $0.isExpanded == true }) {
                    button.tag = sectionCurrentlyExpanded
                    collapse(sectionCurrentlyExpanded, using: buttonOfSectionAlreadyOpen)
                }
                button.tag = section
                expand(section, using: button)
                updateUI(for: button, in: section, at: indexPaths)
            }
        } else {
            if expandableSections[section].isExpanded == true {
                collapse(section, using: button)
                updateUI(for: button, in: section, at: indexPaths)
            } else {    // TODO:- POSSIBLY DISCARD: May not need this condition, since it doesn't seem to be executed
                expand(section, using: button)
                updateUI(for: button, in: section, at: indexPaths)
            }
        }
    }

    
    func expand(_ section: Int, using button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()

        appendTemporary(&indexPaths, in: section)
        expandableSections[section].isExpanded = true
        tableView.insertRows(at: indexPaths, with: .fade)
    }
    
    
    func collapse(_ section: Int, using button: UIButton) {
        let section = button.tag
        var indexPaths = [IndexPath]()
        
        appendTemporary(&indexPaths, in: section)
        expandableSections[section].isExpanded = false
        tableView.deleteRows(at: indexPaths, with: .fade)
    }

    
    func appendTemporary(_ indexPaths: inout [IndexPath], in section: Int) {
        for row in expandableSections[section].data.indices {
            let indexPath = IndexPath(row: row, section: section)   // temporary store items to track appending or deleting
            indexPaths.append(indexPath)
        }
    }
    
    
    func updateUI(for button: UIButton, in section: Int, at indexPaths: [IndexPath]) {
        var sectionTitle = ["Websites", "Makes", "Models"]

        DispatchQueue.main.async {
            if !(self.expandableSections[section].isExpanded) {
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                button.setTitleColor(.black, for: .normal)
            } else {
                button.backgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
                button.setTitleColor(.white, for: .normal)
                button.setTitle(sectionTitle[section], for: .normal)
            }
        }
    }
}

