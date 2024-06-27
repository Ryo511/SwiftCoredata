//
//  GeoApi.swift
//  IOS203PhotoMap_33
//
//  Created by OLIVER LIAO on 2024/6/25.
//

import Foundation

struct Local: Codable {
    let response: Response
}

struct Response: Codable {
    let location: [Location]
}

struct Location: Codable, Identifiable {
    var id = UUID()
    let city: String
    let city_kana: String
    let town: String
    let town_kana: String
    let x: String
    let y: String
    let distance: Double
    let prefecture: String
    let postal: String
    
    private enum CodingKeys: String, CodingKey {
        case city, city_kana, town, town_kana, x, y, distance, prefecture, postal
    }
}

class GeoApi: ObservableObject {
    
    @Published var location: [Location] = []
    func getlocation(x: Double, y: Double) async {
        guard let url = URL(string: "https://geoapi.heartrails.com/api/json?method=searchByGeoLocation&x=\(x)&y=\(y)") else { return }
        
        print(url)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let localdata = try JSONDecoder().decode(Local.self, from: data)
            print("localdata: \(localdata)")
            
            DispatchQueue.main.async {
                self.location = localdata.response.location
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
