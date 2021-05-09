//
//  Vehicle.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 12/16/20.
//  Copyright © 2020 Abraham Shenghur. All rights reserved.
//
import Foundation

struct LocalJSONResponse: Decodable {
    let websites: [Website]
    let vehicles: [Vehicle]
}

struct Website: Decodable {
    var name: String
    var scheme: String
    var host: String
    var path: String
    var query: String
}

struct Vehicle: Decodable {
    let make: String
    let models: [Model]
}

struct Model: Decodable {
    let name: String
    let autotraderQuery: String
    let carsDotComQuery: String
    let carGurusQuery: String
    let trueCarQuery: String
}


