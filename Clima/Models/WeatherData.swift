//
//  WeatherData.swift
//  Clima
//
//  Created by Eduard Tokarev on 26.02.2023.
//

import Foundation

struct WeatherData: Decodable {
    let coord: Coord?
    let weather: [Weather?]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

extension WeatherData {
    struct Coord: Decodable {
        let lon: Float?
        let lat: Float?
    }
    
    struct Weather: Decodable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
    struct Main: Decodable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, humidity, seaLevel, grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Wind: Decodable {
        let speed: Float?
            let deg: Float?
            let gust: Float?
    }
    
    struct Clouds: Decodable {
        let all: Int?
    }
    
    struct Sys: Decodable {
        let type, id: Int?
            let country: String?
            let sunrise, sunset: Int?
    }
}

