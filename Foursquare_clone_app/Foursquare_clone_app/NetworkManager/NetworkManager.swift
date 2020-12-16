//
//  NetworkManager.swift
//  Foursquare_clone_app
//
//  Created by maks on 15.12.2020.
//  Copyright © 2020 maks. All rights reserved.
//

import Foundation

class NetworkManager {

    private let clientId = "Q4YNTPHGHLDSQ53JZKYRTME42RCAGUNE4DL5VBU15NLTQCQB"
    private let clientSecret = "XXZHEWMXAXNSVSAWRZS31HI3WKYCVRWPJQGLA2J21GCYKOKA"
    private let versionAPI = "20201015"

    static var shared: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()

    func searchQuery (categoryName: String, completion: @escaping (Request?) -> Void) {
        let urlString = "https://api.foursquare.com/v2/venues/search"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"
        + "&ll=40.7099,-73.9622&intent=checkin&radius=2000&query=\(categoryName)"

        guard let url = URL(string: urlString) else {return}

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in
            guard let data = data else {return}

            do {
                let json = try JSONDecoder().decode(Request.self, from: data)

                completion(json)
            } catch {
                print(error)
            }
        }.resume()
    }
}
