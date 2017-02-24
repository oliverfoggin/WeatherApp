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
    
    var favouriteCities: [City] = CityService.loadFavouritesCities()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let controller = navController.topViewController as? AddCityViewController {
            controller.selectCityAction = {
                city in
                self.favouriteCities.append(city)
                CityService.save(favouriteCities: self.favouriteCities)
                self.tableView.reloadData()
            }
        }
        
        if let navController = segue.destination as? UINavigationController,
            let controller = navController.topViewController as? CityViewController,
            let indexPath = sender as? IndexPath {
            controller.city = favouriteCities[indexPath.row]
        }
    }
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = CityViewController()
//        let navController = UINavigationController(rootViewController: controller)
//        controller.city = favouriteCities[indexPath.row]
//        showDetailViewController(navController, sender: nil)
        performSegue(withIdentifier: "showCitySegue", sender: indexPath)
    }
}
