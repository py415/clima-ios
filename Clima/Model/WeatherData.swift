//
//  WeatherData.swift
//  Clima
//
//  Created by Philip Yu on 4/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    
    // MARK: - Properties
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    
    // MARK: - Properties
    let temp: Double
    
}

struct Weather: Codable {
    
    // MARK: - Properties
    let description: String
    let id: Int
    
}
