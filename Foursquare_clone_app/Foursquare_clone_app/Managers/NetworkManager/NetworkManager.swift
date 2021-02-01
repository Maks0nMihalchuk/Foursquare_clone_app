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

    var mapper: Mapper

    init () {
       mapper = Mapper()
    }

    func getVenues(categoryName: String,
                   coordinates: (lat: Double, long: Double),
                   completion: @escaping ([Venue]?, Bool) -> Void) {
        let lat = coordinates.lat
        let long = coordinates.long
        let urlHostAllowed = "\(urlFoursquare)/v2/venues/search"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"
        + "&ll=\(lat),\(long)&intent=checkin&radius=2000&query=\(categoryName)"
        guard
            let urlString = urlHostAllowed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            completion(nil, false)
            return
        }

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        makeDataTaskRequest(with: url) { (data, error) in
            if error != nil {
                completion(nil, false)
                return
            }

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let venues = try JSONDecoder().decode(Request.self, from: data)
                StorageManager.shared.putVenues(of: venues.response.venues)
                completion(StorageManager.shared.getVenues(), true)
            } catch {
                completion(nil, false)
            }
        }
    }

    func getDetailInfoVenue(venueId: String, completion: @escaping (DetailVenueModel?, Bool) -> Void) {
        let urlString = "\(urlFoursquare)/v2/venues/"
        + "\(venueId)"
        + "?client_id=\(clientId)"
        + "&client_secret=\(clientSecret)"
        + "&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        makeDataTaskRequest(with: url) { (data, error) in
            if error != nil {
                completion(nil, false)
                return
            }

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let detailInfoVenue = try JSONDecoder().decode(DetailInfo.self, from: data)
                let detailVenue = detailInfoVenue.response.venue
                let mapper = NetworkManager.shared.mapper
                let convertedDeteilVenue = mapper.mapReceivedDataFromDetailsVenue(apiModel: detailVenue)
                StorageManager.shared.putDetailVanue(of: convertedDeteilVenue)
                completion(StorageManager.shared.getDetailVanue(), true)
            } catch {
                completion(nil, false)
            }
        }
    }

    func autorizationFoursquare(completion: @escaping (URL?, Bool) -> Void) {
        let urlString = "\(urlFoursquareLogin)/authenticate?"
        + "client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUrl)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }
        completion(url, true)
    }

    func getAccessToken(code: String?, completion: @escaping (String?, Bool) -> Void) {

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

        makeDataTaskRequest(with: url) { (data, error) in
            if error != nil {
                completion(nil, false)
                return
            }

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let accessToken = try JSONDecoder().decode(Token.self, from: data)

                completion(accessToken.access_token, true)
            } catch {
                completion(nil, false)
            }
        }
    }

    func getUserInfo(accessToken: String, completion: @escaping (String?, Bool) -> Void) {

        let urlString = "\(urlFoursquare)/v2/users/self?oauth_token=\(accessToken)&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        makeDataTaskRequest(with: url) { (data, error) in
            if error != nil {
                completion(nil, false)
                return
            }

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
                completion(nil, false)
            }
        }
    }

    func getUserLists(token: String, completion: @escaping ([GetUserListsGroup]?, Bool) -> Void) {

        let urlString = "\(urlFoursquare)/v2/users/self/lists?oauth_token=\(token)&v=\(versionAPI)"

        guard let url = URL(string: urlString) else {
            completion(nil, false)
            return
        }

        makeDataTaskRequest(with: url) { (data, error) in
            if error != nil {
                completion(nil, false)
                return
            }

            guard let data = data else {
                completion(nil, false)
                return
            }

            do {
                let userLists = try JSONDecoder().decode(GetUserLists.self, from: data)
                StorageManager.shared.putUserIntoArray(of: userLists.response.lists.groups)
                completion(StorageManager.shared.getUserLists(), true)
            } catch {
                completion(nil, false)
            }
        }
    }

    func postRequestForCreateNewList(token: String,
                                     listName: String,
                                     descriptionList: String,
                                     collaborativeFlag: Bool) {

        let optionUrl = setupUrlToCreateUserList(token: token,
                               listName: listName,
                               description: descriptionList,
                               collaborative: collaborativeFlag)

        guard let url = optionUrl else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, _) in

            guard let data = data else {
                return
            }

            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
            } catch {

            }
        }.resume()
    }
}

// MARK: - setting request tasks and setup url to create user list
private extension NetworkManager {

    func makeDataTaskRequest(with url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let session = URLSession.shared
        session.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }.resume()
    }

    func setupUrlToCreateUserList(token: String,
                                  listName: String,
                                  description: String,
                                  collaborative: Bool) -> URL? {
        let urlHostAllowed = "\(urlFoursquare)/v2/lists/add?"
        + "oauth_token=\(token)&client_id=\(clientId)"
        + "&client_secret=\(clientSecret)&v=\(versionAPI)"
        + "&name=\(listName)&description=\(description)&collaborative =\(collaborative)"

        guard
            let urlString = urlHostAllowed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        else {
            return nil
        }

        guard let url = URL(string: urlString) else {
            return nil
        }
        return url
    }
}
