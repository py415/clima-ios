//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // MARK: - Proprties
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Ask user for accessing location permission
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Set WeatherViewController as delegate
        weatherManager.delegate = self
        searchTextField.delegate = self
    
    }
    
    // MARK: - IBAction Section
    
    @IBAction func locationPressed(_ sender: UIButton) {
        
        // Fetch GPS location
        locationManager.requestLocation()
        
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
    }
    
}

// MARK: - UITextFieldDelegate Section

extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTextField.endEditing(true)
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city"
            return false
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Get the weather data for that city.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city: city)
        }
        
        searchTextField.text = ""
        
    }
    
}

// MARK: - WeatherManagerDelegate Section

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage.init(systemName: weather.conditionName)
            self.cityLabel.text = weather.city
        }
        
    }
    
    func didFailWithError(_ error: Error) {
        
        print(error)
        
    }
    
}

// MARK: - CLLocationManagerDelegate Section

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let location = locations.last
        locationManager.stopUpdatingLocation()
        let lat = location?.coordinate.latitude
        let lon = location?.coordinate.longitude
        
        if lat != nil && lon != nil {
            weatherManager.fetchWeather(latitude: lat!, longitude: lon!)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print(error)
        
    }
    
}
