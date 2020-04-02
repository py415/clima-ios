//
//  WeatherManager.swift
//  Clima
//
//  Created by Philip Yu on 3/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate: class {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    
    func didFailWithError(_ error: Error)
    
}

struct WeatherManager {
    
    // TODO: Remove API Key (appID) before commiting to Git
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    var appID: String = "***REMOVED***"
    var units: String = "imperial" // USA customary units
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        
        var newCity: String?
        
        if (city.rangeOfCharacter(from: .whitespaces) != nil) {
            newCity = city.replacingOccurrences(of: " ", with: "%20")
        }
        
        let urlString = "\(weatherURL)"
            + "appid=\(appID)"
            + "&units=\(units)"
            + "&q=\(newCity ?? city)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let urlString = "\(weatherURL)"
            + "appid=\(appID)"
            + "&units=\(units)"
            + "&lat=\(latitude)"
            + "&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            })
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weatherId = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: weatherId, city: name, temperature: temp)
            
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
        
    }
    
}
