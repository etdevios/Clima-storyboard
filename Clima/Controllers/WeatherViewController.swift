//  ViewController.swift
//  Clima
//
//  Created by Eduard Tokarev on 24.02.2023.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    @IBOutlet private weak var conditionImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var searchTextField: UITextField!
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction private func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    @IBAction private func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            temperatureLabel.text = weather.temperatureString
            conditionImageView.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        locationManager.stopUpdatingLocation()
        let latString = String(format: "%f", coordinate.latitude)
        let longString = String(format: "%f", coordinate.longitude)
        
        weatherManager.fetchWeather(cityName: nil, latString, longString)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

