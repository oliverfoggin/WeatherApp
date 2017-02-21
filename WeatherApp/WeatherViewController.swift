//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 21/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import UIKit

import CoreLocation

class WeatherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coord = CLLocationCoordinate2D(latitude: 54.524288, longitude: -1.55039)
        
        WeatherService.getForecast(coordinate: coord) { result in
            print("hello")
        }
    }
}
