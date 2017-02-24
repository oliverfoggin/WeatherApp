//
//  City.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 22/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import Foundation
import CoreLocation

class City {
    let name: String
    let country: String
    let coordinate: CLLocationCoordinate2D
    private var windData: [WindData]? = nil
    private var currentWind: WindData? = nil
    
    init(name: String, country: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.country = country
        self.coordinate = coordinate
    }
    
    init?(withDictionary dictionary: [String : String]) {
        guard let name = dictionary["name"],
            let country = dictionary["country"],
            let latString = dictionary["lat"],
            let lat = Double(latString),
            let lonString = dictionary["lon"],
            let lon = Double(lonString) else {
                return nil
        }
        
        self.name = name
        self.country = country
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func dictionaryForm() -> [String : String] {
        return [
            "name" : name,
            "country" : country,
            "lat" : "\(coordinate.latitude)",
            "lon" : "\(coordinate.longitude)"
        ]
    }
    
    func getCurrentWeather(completion: @escaping (WindData?) -> ()) {
        if let currentWind = currentWind {
            completion(currentWind)
            return
        }
        
        WeatherService.getCurrentWeather(coordinate: coordinate) { windData in
            self.currentWind = windData
            completion(windData)
        }
    }
    
    func getForecast(completion: @escaping ([WindData]) -> ()) {
        if let windData = windData {
            completion(windData)
            return
        }
        
        WeatherService.getForecast(coordinate: coordinate) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let data):
                self.windData = data
                completion(data)
            }
        }
    }
}
