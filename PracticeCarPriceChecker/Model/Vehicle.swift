//
//  Vehicle.swift
//  PracticeCarPriceChecker
//
//  Created by Abraham on 12/16/20.
//  Copyright © 2020 Abraham Shenghur. All rights reserved.
//
import Foundation

struct Vehicle {
    var year: Int
    var make: String
    var model: String
    var trim: String
    var price: Int
    var mileage: Int
    var listingImage: String
    var listingURL: String?
}


struct VehicleList {
    static let tenRandomVehicles = [
        Vehicle(year: 2013, make: "Nissan", model: "Altima", trim: "Coupe 2.5 S", price: 8968, mileage: 96404, listingImage: Images.vehicle1, listingURL: ListingURL.url1),
        Vehicle(year: 2015, make: "Chevrolet", model: "Camaro", trim: "1LT Coupe RWD", price: 17491, mileage: 69102, listingImage: Images.vehicle2, listingURL: ListingURL.url2),
        Vehicle(year: 2018, make: "Lexus", model: "RC 300", trim: "RWD", price: 31699, mileage: 12384, listingImage: Images.vehicle3, listingURL: ListingURL.url3),
        Vehicle(year: 2013, make: "Scion", model: "FR-S", trim: "", price: 10599, mileage: 84010, listingImage: Images.vehicle4, listingURL: ListingURL.url4),
        Vehicle(year: 2017, make: "Dodge", model: "Challenger", trim: "R/T RWD", price: 21975, mileage: 57297, listingImage: Images.vehicle5, listingURL: ListingURL.url5),
        Vehicle(year: 2017, make: "Chevrolet", model: "Camaro", trim: "2SS Coupe RWD", price: 21999, mileage: 20945, listingImage: Images.vehicle6, listingURL: ListingURL.url6),
        Vehicle(year: 2016, make: "Porsche", model: "911", trim: "Carrera 4S Coupe AWD", price: 85000, mileage: 4010, listingImage: Images.vehicle7, listingURL: ListingURL.url7),
        Vehicle(year: 2016, make: "Honda", model: "Civic", trim: "Coupe Touring", price: 14950, mileage: 41848, listingImage: Images.vehicle8, listingURL: ListingURL.url8),
        Vehicle(year: 2019, make: "Ford", model: "Mustang", trim: "EcoBoost Coupe RWD", price: 19899, mileage: 24064, listingImage: Images.vehicle9, listingURL: ListingURL.url9),
        Vehicle(year: 2015, make: "Mercedes-Benz", model: "S-Class", trim: "Coupe S 550 4MATIC", price: 57900, mileage: 13803, listingImage: Images.vehicle10, listingURL: ListingURL.url10)
    ]
}


