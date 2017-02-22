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
    @IBOutlet weak var tableView: UITableView!
    
    var favouriteCities: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coord = CLLocationCoordinate2D(latitude: 54.524288, longitude: -1.55039)
        
        let city = City(name: "Darlington", country: "UK", coordinate: coord)
        
        city.getForecast { windData in
            print(windData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let controller = navController.topViewController as? AddCityViewController {
            controller.selectCityAction = {
                city in
                self.favouriteCities.append(city)
                print(self.favouriteCities)
                self.tableView.reloadData()
            }
        }
    }
}

extension WeatherViewController: UITextViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        let city = favouriteCities[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
}
