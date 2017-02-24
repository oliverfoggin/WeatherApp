//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 24/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import UIKit

import MapKit

class CityViewController: UIViewController {
    var city: City? {
        didSet {
            displayCity()
        }
    }
    var forecast: [WindData] = []
    
    let dateFormatter: DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE dd, HH:mm", options: 0, locale: nil)
        return d
    }()
    
    lazy var tableView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.dataSource = self
        t.delegate = self
        t.register(ForecastTableViewCell.self, forCellReuseIdentifier: "ForecastCell")
        t.allowsSelection = false
        t.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        return t
    }()
    
    let currentWeatherLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        l.textColor = .white
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 30)
        return l
    }()
    
    let mapView: MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.mapType = .hybrid
        m.isUserInteractionEnabled = false
        return m
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        title = "City Forecast"
        
        let stackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [mapView, tableView])
            s.translatesAutoresizingMaskIntoConstraints = false
            s.axis = .vertical
            s.spacing = 0
            s.alignment = .fill
            s.distribution = .fill
            return s
        }()
        
        view.addSubview(stackView)
        view.addSubview(currentWeatherLabel)
        
        mapView.heightAnchor.constraint(equalTo: tableView.heightAnchor, multiplier: 0.7, constant: 0).isActive = true
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        
        currentWeatherLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        currentWeatherLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        currentWeatherLabel.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        currentWeatherLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        if city == nil {
            city = CityService.loadFavouritesCities().first
        }
    }
    
    func displayCity() {
        guard let city = city else {
            return
        }
        
        let region = MKCoordinateRegionMakeWithDistance(city.coordinate, 4000, 4000)
        mapView.setRegion(region, animated: false)
        
        city.getForecast { windData in
            self.forecast = windData
            print(windData)
            self.tableView.reloadData()
        }
        
        city.getCurrentWeather { windData in
            guard let windData = windData else {
                self.currentWeatherLabel.text = "Unable to get weather"
                return
            }
            
            self.currentWeatherLabel.text = "\(windData.direction.shortDescription) - \(windData.speed)"
        }
    }
}

extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as! ForecastTableViewCell
        
        let windData = forecast[indexPath.row]
        
        cell.dateLabel.text = dateFormatter.string(from: windData.date)
        cell.directionLabel.text = windData.direction.shortDescription
        cell.vaneImageView.image = WeatherAppStyleKit.imageOfWindVane(windDirection: CGFloat(windData.degrees),
                                                                      windSpeed: CGFloat(windData.speed.value))
        
        return cell
    }
}

class ForecastTableViewCell: UITableViewCell {
    
    let vaneImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        i.heightAnchor.constraint(equalTo: i.widthAnchor).isActive = true
        return i
    }()
    
    let directionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .darkGray
        l.font = UIFont.systemFont(ofSize: 21)
        l.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        return l
    }()
    
    let dateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .darkGray
        l.textAlignment = .right
        return l
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        
        let stackView: UIStackView = {
            let s = UIStackView(arrangedSubviews: [vaneImageView, directionLabel, dateLabel])
            s.translatesAutoresizingMaskIntoConstraints = false
            s.axis = .horizontal
            s.distribution = .fill
            s.alignment = .center
            s.spacing = 16
            s.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            s.isLayoutMarginsRelativeArrangement = true
            return s
        }()
        
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
