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
    private let urlFoursquare = "https://api.foursquare.com"
    private let urlFoursquareLogin = "https://foursquare.com/oauth2"
    let redirectUrl = "https://myCloneApp.com"

    static var shared: NetworkManager = {
        let networkManager = NetworkManager()
        return networkManager
    }()

    func getVenues (categoryName: String, completion: @escaping (Request?) -> Void) {
        let urlString = "\(urlFoursquare)/v2/venues/search"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"
        + "&ll=40.7099,-73.9622&intent=checkin&radius=2000&query=\(categoryName)"

        guard let url = URL(string: urlString) else {
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                return
            }

            do {
                let venuesId = try JSONDecoder().decode(Request.self, from: data)

                completion(venuesId)
            } catch {
                print(error)
            }
        }.resume()
    }

    func getDetailInfoVenue (venueId: String, completion: @escaping (DetailsVenue?) -> Void) {
        let urlString = "\(urlFoursquare)/v2/venues/"
        + "\(venueId)"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                return
            }

            do {
                let detailInfoVenue = try JSONDecoder().decode(DetailInfo.self, from: data)
                let detail = detailInfoVenue.response.venue

                let localDetailVenue = MappingReceivedDataToDetailsVenue.shared
                    .mappingReceivedDataToDetailsVenue(apiModel: detail)
                completion(localDetailVenue)

            } catch {
                print("Could not get detail info venue: \(error)")
            }
        }.resume()
    }

    func autorizationFoursquare (completion: @escaping (URL?, Bool) -> Void) {
        let urlString = "\(urlFoursquareLogin)/authenticate?"
        + "client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUrl)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }
        completion(url, true)
    }

    func getAccessToken (code: String?, completion: @escaping (String?, Bool) -> Void) {

        guard let code = code else {
            completion(nil, false)
            return
        }

        let urlString = "\(urlFoursquareLogin)/access_token?"
        + "client_id=\(clientId)&client_secret=\(clientSecret)&"
        + "grant_type=authorization_code&redirect_uri=\(redirectUrl)&code=\(code)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let accessToken = try JSONDecoder().decode(Token.self, from: data)

                completion(accessToken.access_token, true)
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }

    func getUserInfo (accessToken: String, completion: @escaping (String?, Bool) -> Void) {

        let urlString = "\(urlFoursquare)/v2/users/self?oauth_token=\(accessToken)&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let userInfo = try JSONDecoder().decode(User.self, from: data)
                let userFullName = "\(userInfo.response.user.firstName) "
                + "\(userInfo.response.user.lastName)"
                completion(userFullName, true)

            } catch {
                print(error)
            }

        }.resume()
    }
    func getInfoAboutUserLists (token: String, completion: @escaping ([GetUserListsGroup]?) -> Void) {

        let urlString = "\(urlFoursquare)/v2/users/self/lists?oauth_token=\(token)&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            return
        }

        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in

            guard let data = data else {
                return
            }

            do {
                let infoAboutUserLists = try JSONDecoder().decode(GetUserLists.self, from: data)

                completion(infoAboutUserLists.response.lists.groups)
            } catch {
                print(error)
            }
        }.resume()
    }
}
