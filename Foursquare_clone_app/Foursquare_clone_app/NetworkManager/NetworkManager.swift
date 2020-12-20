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
    private let clientSecret = "B0F1TYQH1NDTXGCDPEHMRZ2JQKK4RBOZOJ22R5AACVUYRZ5P"
    private let versionAPI = "20201015"

    static var shared: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()

    func getVenues (categoryName: String, completion: @escaping (Request?) -> Void) {
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
                let venuesId = try JSONDecoder().decode(Request.self, from: data)

                completion(venuesId)
            } catch {
                print(error)
            }
        }.resume()
    }

    func getDetailInfoVenue (venueId: String, completion: @escaping (LocalVenueModel?) -> Void) {
        let urlString = "https://api.foursquare.com/v2/venues/"
        + "\(venueId)"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {return}

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in
            guard let data = data else {return}

            do {
                let detailInfoVenue = try JSONDecoder().decode(DetailInfo.self, from: data)
                let detail = detailInfoVenue.response.venue

                let localDetailVenue = Mapping.shared.dataMapping(apiModel: detail)
                completion(localDetailVenue)

            } catch {
                print("Could not get detail info venue: \(error)")
            }
        }.resume()
    }
}
