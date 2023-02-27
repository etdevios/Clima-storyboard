//
//  WeatherManager.swift
//  Clima
//
//  Created by Eduard Tokarev on 25.02.2023.
//
// Example request: https://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=6e879ca81ef0e27f38403ef140bdf34d&lang=ru&units=metric

import Foundation
import CoreLocation

struct WeatherManager {
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(
        cityName: String?,
        _ latitude: String? = nil,
        _ longitude: String? = nil
    ) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "appid", value: K.API.openWeatherMapAPIKey),
            .init(name: "units", value: "metric"),
            .init(name: "lang", value: "ru"),
            .init(name: "q", value: cityName),
            .init(name: "lat", value: latitude),
            .init(name: "lon", value: longitude)
        ]
        
        guard let url = urlComponents.url else { fatalError("The URL request was set incorrectly") }
        performRequest(with: url)
    }
    
    func performRequest(with url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                delegate?.didFailWithError(error: error!)
                return
            }
            
            guard
                let safeData = data else {fatalError()}
            if let weather = self.parseJSON(safeData) {
                delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            guard
                let id = decodedData.weather[0]?.id,
                let temp = decodedData.main?.temp,
                let name = decodedData.name
            else { fatalError() }
            let weather = WeatherModel(
                conditionID: id,
                cityName: name,
                temperature: temp
            )
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
