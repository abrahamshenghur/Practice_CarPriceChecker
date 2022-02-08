//
//  SearchVC.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 1/11/21.
//  Copyright © 2021 Abraham Shenghur. All rights reserved.
//

import UIKit

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


class SearchVC: UIViewController {
    
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
    
    let autotraderVC = VehicleWebsiteVC(websiteName: WebsiteName.autotrader)
    let carsDotComVC = VehicleWebsiteVC(websiteName: WebsiteName.cars)
    let carGurusVC = VehicleWebsiteVC(websiteName: WebsiteName.carGurus)
    let craigslistVC = VehicleWebsiteVC(websiteName: WebsiteName.craigslist)
    let truecarVC = VehicleWebsiteVC(websiteName: WebsiteName.trueCar)

    var popupCardTopAnchor: NSLayoutConstraint?
    var popupCardBottomAnchor: NSLayoutConstraint?
    
    let fontFamilyName = "Futura"

    let primaryBackgroundColor = #colorLiteral(red: 0.9224214702, green: 0.9224214702, blue: 0.9224214702, alpha: 1)
    let secondaryBackgroundColor = #colorLiteral(red: 0.10656894, green: 0.3005332053, blue: 0.2772833705, alpha: 1)
    let tertiaryBackgroundColor = #colorLiteral(red: 0.9098039216, green: 0.6392156863, blue: 0.05098039216, alpha: 1)
    
    
    lazy var logoTextLabel: UILabel = {
        let strNumber: NSString = "Find the \nbest car deals" as NSString
        let range = (strNumber).range(of: "best")
        let attribute = NSMutableAttributedString.init(string: strNumber as String)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: tertiaryBackgroundColor, range: range)

        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: fontFamilyName, size: 47)
        label.numberOfLines = .zero
        label.text = strNumber as String
        label.attributedText = attribute
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let parentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let childViewForHideCardButton: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let hideCardButton: UIButton = {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 70, weight: .regular, scale: .medium)
        let chevronCompactDown = UIImage(systemName: "chevron.compact.down", withConfiguration: symbolConfiguration)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(chevronCompactDown, for: .normal)
        button.addTarget(self, action: #selector(hideCard), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getVehicle()
        createSections()
        configureViewController()
        configureLogoView()
        configureTableView()
        configureSearchButton()
        configurePopupCard()
        setPopupCardConstraints()
        addWebViews()
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
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .black

        view.backgroundColor = primaryBackgroundColor

        tabBarController?.tabBar.barTintColor = primaryBackgroundColor
        tabBarController?.tabBar.tintColor = tertiaryBackgroundColor
    }
    
    
    func configureLogoView() {
        view.addSubview(logoView)
        logoView.backgroundColor = secondaryBackgroundColor
        logoView.addSubview(logoTextLabel)
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = primaryBackgroundColor
        tableView.layer.cornerRadius = 31
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchScreenCell.self, forCellReuseIdentifier: SearchScreenCell.reuseID)
    }
    
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.backgroundColor = secondaryBackgroundColor
        searchButton.layer.cornerRadius = 31
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = UIFont(name: fontFamilyName, size: 25)
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    
    func configurePopupCard() {
        view.addSubview(parentContainerView)
        parentContainerView.addSubview(childViewForHideCardButton)
        parentContainerView.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        childViewForHideCardButton.addSubview(hideCardButton)
    }

    
    func setPopupCardConstraints() {
        popupCardBottomAnchor = parentContainerView.topAnchor.constraint(equalTo: view.bottomAnchor)
        popupCardBottomAnchor?.isActive = true
        
        popupCardTopAnchor = parentContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 75)
    }
    
    
    func addWebViews() {
        autotraderVC.gestureRecognizerDelegate = self
        carsDotComVC.gestureRecognizerDelegate = self
        carGurusVC.gestureRecognizerDelegate = self
        craigslistVC.gestureRecognizerDelegate = self
        truecarVC.gestureRecognizerDelegate = self
        
        stackView.addArrangedSubview(autotraderVC.view)
        stackView.addArrangedSubview(carsDotComVC.view)
        stackView.addArrangedSubview(carGurusVC.view)
        stackView.addArrangedSubview(craigslistVC.view)
        stackView.addArrangedSubview(truecarVC.view)
    }
    
    
    @objc func searchButtonTapped() {
        showCard()
    }
    
    
    @objc func showCard() {
        popupCardBottomAnchor?.isActive = false
        popupCardTopAnchor?.isActive = true
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        loadVehicleWebsites()
        toggleTabbar()
    }
    
    
    func loadVehicleWebsites() {
        autotraderVC.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
        
        autotraderVC.buildURLFrom(make: selectedVehicleMake, model: selectedVehicleModelUsingAutotraderQuery,for: WebsiteName.autotrader)
        carsDotComVC.buildURLFrom(make: selectedVehicleMake, model: selectedVehicleModelUsingCarsDotComQuery,for: WebsiteName.cars)
        carGurusVC.buildURLFrom(make: selectedVehicleMake, model: selectedVehicleModelUsingCarGurusQuery,for: WebsiteName.carGurus)
        craigslistVC.buildURLFrom(make: selectedVehicleMake, model: selectedVehicleModel,for: WebsiteName.craigslist)
        truecarVC.buildURLFrom(make: selectedVehicleMake, model: selectedVehicleModelUsingTrueCarQuery,for: WebsiteName.trueCar)
    }
    
    
    @objc func hideCard() {
        popupCardBottomAnchor?.isActive = true
        popupCardTopAnchor?.isActive = false

        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        toggleTabbar()
    }
    
    
    func toggleTabbar() {
        guard var tabBarFrame = tabBarController?.tabBar.frame else { return }
        let tabBarHidden = tabBarFrame.origin.y == view.frame.size.height
        
        if tabBarHidden {
            tabBarFrame.origin.y = view.frame.size.height - tabBarFrame.size.height
        } else {
            tabBarFrame.origin.y = view.frame.size.height
        }
        
        UIView.animate(withDuration: 0.4) {
            self.tabBarController?.tabBar.frame = tabBarFrame
        }
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
            
            logoTextLabel.topAnchor.constraint(equalTo: logoView.topAnchor, constant: 50),
            logoTextLabel.leadingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: 20),
            logoTextLabel.trailingAnchor.constraint(equalTo: logoView.trailingAnchor),
            logoTextLabel.heightAnchor.constraint(equalToConstant: 200),
            
            tableView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: -30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -20),
            
            searchButton.heightAnchor.constraint(equalToConstant: 60),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            searchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75),
            
            parentContainerView.topAnchor.constraint(equalTo: view.bottomAnchor),
            parentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            parentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            parentContainerView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.90),
            
            childViewForHideCardButton.topAnchor.constraint(equalTo: parentContainerView.topAnchor),
            childViewForHideCardButton.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor, constant: padding),
            childViewForHideCardButton.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor, constant: -padding),
            childViewForHideCardButton.heightAnchor.constraint(equalToConstant: 45),
            
            scrollView.topAnchor.constraint(equalTo: childViewForHideCardButton.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: parentContainerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: parentContainerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: parentContainerView.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            hideCardButton.topAnchor.constraint(equalTo: childViewForHideCardButton.topAnchor),
            hideCardButton.centerXAnchor.constraint(equalTo: childViewForHideCardButton.centerXAnchor),
            hideCardButton.widthAnchor.constraint(equalToConstant: 100),
            hideCardButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = expandableSections[section].title
        let button = Button(title: title)
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        button.titleLabel?.font = UIFont(name: fontFamilyName, size: 25)

        if expandableSections[section].isExpanded {
            button.backgroundColor = secondaryBackgroundColor
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            
            button.layer.borderColor = primaryBackgroundColor.cgColor
            button.layer.cornerRadius = 31
            button.layer.borderWidth = 1

            button.layer.shadowColor = secondaryBackgroundColor.cgColor
            button.layer.shadowRadius = 3
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 0, height: 5)
            
            button.setTitleColor(.black, for: .normal)
        }
        
        return button
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
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
        
        cell.backgroundColor = primaryBackgroundColor
        
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
        let sectionTitle = ["Websites", "Makes", "Models"]

        DispatchQueue.main.async {
            if !(self.expandableSections[section].isExpanded) {
                button.backgroundColor = .white
                button.setTitleColor(.black, for: .normal)
            } else {
                button.backgroundColor = self.secondaryBackgroundColor
                button.setTitleColor(.white, for: .normal)
                button.setTitle(sectionTitle[section], for: .normal)
            }
        }
    }
}


extension SearchVC: VehicleListVCTapGestureDelegate {
    
    func didUseGestureRecognizer(on vehicleWebsiteVC: VehicleWebsiteVC) {
        for view in stackView.arrangedSubviews {
            view.layer.borderColor = secondaryBackgroundColor.cgColor
        }

        vehicleWebsiteVC.view.layer.borderColor = tertiaryBackgroundColor.cgColor
    }
}
