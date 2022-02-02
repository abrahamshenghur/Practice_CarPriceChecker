//
//  PCPCWebView.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 1/3/22.
//  Copyright © 2022 Abraham Shenghur. All rights reserved.
//

import WebKit

class PCPCWebView: WKWebView {
    
    let autotraderVehicleMakes = ["acura": "ACURA", "alfa romeo": "ALFA", "aston martin": "ASTON", "audi": "AUDI", "bentley": "BENTL", "bmw": "BMW", "buick": "BUICK", "cadillac": "CAD", "chevrolet": "CHEV", "chrysler": "CHRY", "dodge": "DODGE", "ferrari": "FER", "fiat": "FIAT", "fisker": "FISK", "ford": "FORD", "freightliner": "FREIGHT", "genesis": "GENESIS", "gmc": "GMC", "honda": "HONDA", "hummer": "AMGEN","hyundai": "HYUND", "infiniti": "INFIN", "isuzu": "ISU", "jaguar": "JAG", "jeep": "JEEP", "karma": "KARMA", "kia": "KIA", "lamborghini": "LAM", "land rover": "ROV" ,"lexus": "LEXUS", "lincoln": "LINC", "lotus": "LOTUS", "maserati": "MAS", "maybach": "MAYBACH", "mazda": "MAZDA", "mclaren": "MCLAREN", "mercedes-benz" : "MB", "mercury": "MERC", "mini": "MINI", "mitsubishi": "MIT", "nissan": "NISSAN", "oldsmobile": "OLDS", "plymouth": "PLYM", "pontiac": "PONT", "porsche": "POR", "ram": "RAM", "rolls-royce": "RR", "saab": "SAAB", "saturn": "SATURN", "scion": "SCION", "smart": "SMART", "subaru": "SUB", "suzuki": "SUZUKI", "tesla": "TESLA", "toyota": "TOYOTA", "volkswagen": "VOLKS", "volvo": "VOLVO"]
    
    let carsDotComVehicleMakes = ["acura": "20001", "alfa romeo": "20047", "aston martin": "20003", "audi": "20049", "bentley": "20051", "bmw": "20005", "buick": "20006", "cadillac": "20052", "chevrolet": "20053", "chrysler": "20008", "dodge": "20012", "ferrari": "20014", "fiat": "20060", "fisker": "41703", "ford": "20015","genesis": "35354491", "gmc": "20061", "honda": "20017", "hummer": "20018","hyundai": "20064", "infiniti": "20019", "isuzu": "20020", "jaguar": "20066", "jeep": "20021", "karma": "36365359", "kia": "20068", "lamborghini": "20069", "land rover": "20024" ,"lexus": "20070", "lincoln": "20025", "lotus": "20071", "maserati": "20072", "maybach": "20027", "mazda": "20073", "mclaren": "47903", "mercedes-benz" : "20028", "mercury": "20074", "mini": "20075", "mitsubishi": "20030", "nissan": "20077", "oldsmobile": "20032", "plymouth": "20080", "pontiac": "20035", "porsche": "20081", "ram": "44763", "rolls-royce": "20037", "saab": "20038", "saturn": "20039", "scion": "20085", "smart": "20228", "subaru": "20041", "suzuki": "20042", "tesla": "28263", "toyota": "20088", "volkswagen": "20089", "volvo": "20044"]
    
    var selectedVehicleModelUsingAutotraderQuery = String()

    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: .zero, configuration: WKWebViewConfiguration())
    }
    
    
    convenience init(loadURL: URL) {
        self.init(frame: .zero)
        let request = URLRequest(url: loadURL)
        self.load(request)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {

        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8).isActive = true
    }
    
    
    func loadURL(url: URL) {
        let request = URLRequest(url: url)
        self.load(request)
    }
    
    
    func buildAutotraderURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.autotrader.com"
        
        var autotraderVehicleMakeCode = String()
        
        if let make = autotraderVehicleMakes[make] {
            autotraderVehicleMakeCode = make
        }
        
        components.path = "/cars-for-sale/all-cars"
        components.queryItems = [
            URLQueryItem(name: "makeCodeList", value: "\(autotraderVehicleMakeCode)"),
            URLQueryItem(name: "modelCodeList", value: "\(model)"),
            URLQueryItem(name: "seriesCodeList", value: "\(model)")
        ]
        
        return components.url
    }
    
    
    func buildCraigslistURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "inlandempire.craigslist.org"

        components.path = "/search/cta"
        components.queryItems = [
            URLQueryItem(name: "query", value: "\(make)+\(model)"),
            URLQueryItem(name: "purveyor-input", value: "all")
        ]
        
        return components.url
    }
    
    
    func buildCarsDotComURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.cars.com"

        // On 6/17/21 Cars.com seemingly changed their format of url query parameters while the json file was still being populsted; therefore, a workaround is done for all mokes starting with Nissan until the end of the list
        let updatedVehicleMakeArrayFromCarsDotCom = [
            "nissan", "oldsmobile", "plymouth", "pontiac", "porsche", "ram", "rolls-royce", "saab", "20038", "saturn", "scion", "smart", "subaru", "suzuki", "tesla", "toyota", "volkswagen", "volvo"
        ]
        if updatedVehicleMakeArrayFromCarsDotCom.contains(make) {
            // use new query parameters uaing as a workaround b/c Cars.com changed their url parameters to use words instead of numbers
            let updatedVehicleMake = make
            let updatedPath = "/shopping/results"
            components.path = updatedPath

            if model.contains("&") {
                // If Cars.com has multiple models under a certain model name, seen in the json file, then use this hardcoded url
                let domain = "https://www.cars.com"
                let query = model
                let endpoint = "/shopping/results/?makes[]=\(make)&maximum_distance=&models[]=\(query)&searchSource=QUICK_FORM&stock_type=used"
                let url = URL(string: domain + endpoint)
                return url
            } else {
                // Otherwise, it's a single model query and just build a url using URLComponents
                components.queryItems = [
                    URLQueryItem(name: "makes[]", value: "\(updatedVehicleMake)"),
                    URLQueryItem(name: "maximum_distance", value: ""),
                    URLQueryItem(name: "models[]", value: "\(model)"),
                    URLQueryItem(name: "searchSource", value: "QUICK_FORM"),
                    URLQueryItem(name: "stock_type", value: "used")
                ]
            }
        } else {
            // use original way when Cars.com used an integer for mkId and mdId, and stock type
            var carsDotComVehicleMakeCode = String()
            if let make = carsDotComVehicleMakes[make] {
                carsDotComVehicleMakeCode = make
            }
            components.queryItems = [
                URLQueryItem(name: "mdId", value: "\(model)"),
                URLQueryItem(name: "mkId", value: "\(carsDotComVehicleMakeCode)"),
                URLQueryItem(name: "rd", value: ""),
                URLQueryItem(name: "searchSource", value: "QUICK_FORM"),
                URLQueryItem(name: "stkTypId", value: "28881")
            ]
        }
        
        return components.url
    }
    
    
    func buildCarGurusURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.cargurus.com"

        components.path = "/Cars/inventorylisting/viewDetailsFilterViewInventoryListing.action"
        components.queryItems = [
            URLQueryItem(name: "sourceContext", value: "carGurusHomePageModel"),
            URLQueryItem(name: "entitySelectingHelper.selectedEntity", value: "\(model)"),
        ]
        
        return components.url
    }
    
    
    func buildTrueCarURL(_ make: String, _ model: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.truecar.com"

        components.path = "/used-cars-for-sale/listings" + "/\(make)/\(model)"
        components.queryItems = [
            URLQueryItem(name: "sort[]", value: "best_match")
        ]
        
        return components.url
    }
}
