//
//  AddCityViewController.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 22/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import UIKit
import CoreLocation

class AddCityViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var selectCityAction: (City) -> () = { _ in }
    
    var cities: [City] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.placeholder = "City or address"
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(searchText) {
            places, error in
            guard let places = places else {
                return
            }
            
            self.cities = places.flatMap {
                placemark in
                
                guard let name = placemark.addressDictionary?["City"] as? String,
                    let country = placemark.country,
                    let coordinate = placemark.location?.coordinate else {
                        return nil
                }
                
                return City(name: name, country: country, coordinate: coordinate)
            }
        }
    }
}

extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        let city = cities[indexPath.row]
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = city.country
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities[indexPath.row]
        
        selectCityAction(city)
        dismiss(animated: true, completion: nil)
    }
}
