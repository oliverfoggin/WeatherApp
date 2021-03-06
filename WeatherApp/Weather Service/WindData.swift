//
//  WindData.swift
//  WeatherApp
//
//  Created by Oliver Foggin on 21/02/2017.
//  Copyright © 2017 Oliver Foggin. All rights reserved.
//

import Foundation

struct WindData {
    enum Direction {
        case north
        case northEast
        case east
        case southEast
        case south
        case southWest
        case west
        case northWest
        
        var shortDescription: String {
            switch self {
            case .north:
                return "N"
            case .northEast:
                return "NE"
            case .east:
                return "E"
            case .southEast:
                return "SE"
            case .south:
                return "S"
            case .southWest:
                return "SW"
            case .west:
                return "W"
            case .northWest:
                return "NW"
            }
        }
    }
    
    let date: Date
    let speed: Measurement<UnitSpeed>
    let degrees: Double
    let direction: Direction
    
    init?(jsonData: [String : Any], dateStamp: Int64) {
        guard let speed = jsonData["speed"] as? Double,
            let degrees = jsonData["deg"] as? Double else {
                return nil
        }
        
        self.speed = Measurement(value: speed, unit: .metersPerSecond)
        self.degrees = degrees
        self.date = Date(timeIntervalSince1970: TimeInterval(integerLiteral: dateStamp))
        
        self.direction = {
            switch degrees {
            case 0..<22.5:
                return .north
            case 22.5..<67.5:
                return .northEast
            case 67.5..<112.5:
                return .east
            case 112.5..<157.5:
                return .southEast
            case 157.5..<202.5:
                return .south
            case 202.5..<247.5:
                return .southWest
            case 247.5..<292.5:
                return .west
            case 292.5..<337.5:
                return .northWest
            default:
                return .north
            }
        }()
    }
}
