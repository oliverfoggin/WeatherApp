//
//  CityService.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 24/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import Foundation

import CoreLocation

struct CityService {
    static func searchForCities(searchText: String, completion: @escaping (Result<[City]>) -> ()) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(searchText) {
            places, error in
            guard let places = places else {
                completion(Result.failure(NSError(domain: "No Cities Found", code: 1, userInfo: nil)))
                return
            }
            
            let cities: [City] = places.flatMap {
                placemark in
                
                guard let name = placemark.addressDictionary?["City"] as? String,
                    let country = placemark.country,
                    let coordinate = placemark.location?.coordinate else {
                        return nil
                }
                
                return City(name: name, country: country, coordinate: coordinate)
            }
            
            completion(Result.success(cities))
        }
    }
    
    static func save(favouriteCities cities: [City]) {
        let citiesArray = cities.map{$0.dictionaryForm()}
        
        UserDefaults.standard.set(citiesArray, forKey: "FavouriteCities")
        UserDefaults.standard.synchronize()
    }
    
    static func loadFavouritesCities() -> [City] {
        guard let citiesArray = UserDefaults.standard.array(forKey: "FavouriteCities") as? [[String : String]] else {
            return []
        }
        
        return citiesArray.flatMap{City(withDictionary: $0)}
    }
}
