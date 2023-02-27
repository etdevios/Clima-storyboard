//
//  WeatherDelegate.swift
//  Clima
//
//  Created by Eduard Tokarev on 26.02.2023.
//

import Foundation

protocol WeatherManagerDelegate: AnyObject {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
