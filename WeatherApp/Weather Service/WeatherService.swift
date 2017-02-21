//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 21/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import Foundation
import CoreLocation

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum WeatherError: Error {
    case unknownError
}

struct WeatherService {
    static var apiKey: String?
    
    static func getForecast(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[WindData]>) -> ()) {
        guard let url = self.forecastURL(withCooridnate: coordinate) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            self.parseForecastResult(data: data, response: response, error: error, completion: completion)
            }.resume()
    }
    
    private static func parseForecastResult(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<[WindData]>) -> ()) {
        
        if let error = error {
            completion(Result.failure(error))
            return
        }
        
        guard let weatherJSON = getWeatherJSON(fromData: data) else {
            completion(Result.failure(WeatherError.unknownError))
            return
        }
        
        let windArray = createWindArray(fromJSONArray: weatherJSON)
        
        completion(Result.success(windArray))
    }
    
    private static func getWeatherJSON(fromData data: Data?) -> [[String : Any]]? {
        guard let data = data,
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let weatherArray = json["list"] as? [[String: Any]] else {
                return nil
        }
        
        return weatherArray
    }
    
    private static func createWindArray(fromJSONArray jsonArray: [[String: Any]]) -> [WindData] {
        return jsonArray.flatMap {
            guard let windData = $0["wind"] as? [String: Any],
                let dateStamp = $0["dt"] as? Int64 else {
                    return nil
            }
            
            return WindData(jsonData: windData, dateStamp: dateStamp)
        }
    }
    
    private static func forecastURL(withCooridnate coordinate: CLLocationCoordinate2D) -> URL? {
        guard let apiKey = apiKey else {
            return nil
        }
        
        var urlComponents = URLComponents(string: "http://api.openweathermap.org")!
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinate.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
        ]
        
        return urlComponents.url
    }
}
