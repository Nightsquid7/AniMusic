//
//  AppleMusicStore.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/26.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import StoreKit
import Combine

class AppleMusicStore: ObservableObject {

    @Published var userToken: String?
    @Published var appleMusicEnabled: Bool = false
    @Published var authorizationStatus: Bool  = false
    var disposables = Set<AnyCancellable>()

    var developerToken: String = ""

    init() {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) {
            self.developerToken = (dictionary["developerToken"] as? String)!
        }
    }


    // create a playlist in the user's library with songs from Anime
    // based on type - all, openings, or endings
    func createAnimePlaylist(from anime: Anime, type: DisplayType) {

        var components = URLComponents()
        components.scheme = "https"
        components.host   = "api.music.apple.com"
        components.path   = "/v1/me/library/playlists"

        var songDataArray: [[String: String]] = anime.songs.map { song in
            return ["id": song.id,
                    "type": song.type.rawValue]
        }

        if type != .all {
            // filter only openings or endings based on type
            songDataArray = songDataArray.filter( { $0["type"] == type.rawValue } )
        }

        // give playlist name/description based on type
        var name: String = ""
        var description = ""
        switch type {
            case .all:
                name = anime.id
                description = "all songs from \(anime.id)"
            case .openings:
                name = "\(anime.id) openings"
                description = "all openings from \(anime.id)"
            case .endings:
                name = "\(anime.id) endings"
                description = "all endings from \(anime.id)"
        }

        let json: [String: Any] =
            ["attributes": [
            "name": name,
            "description": description],
               "relationships": [
                    "tracks": [
                        "data": songDataArray
                    ]
                ]
        ]


        let url = components.url!

        var request = URLRequest(url: url)
        request.setValue(userToken, forHTTPHeaderField: "Music-User-Token")
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        _ = URLSession.shared.dataTaskPublisher(for: request)
            .sink(receiveCompletion: { completion in
                print("completed")
                },receiveValue: { data, response in
                    print(String(data: data, encoding: String.Encoding.utf8) as Any)
            })
            .store(in: &disposables)

    }


    let controller = SKCloudServiceController()

    func requestUserToken() {
        controller.requestUserToken(forDeveloperToken: developerToken) { userToken, error in
            // Use this value for recommendation requests.
            if let userToken  = userToken {
                self.userToken = userToken
            } else {
                print("did not get user Token")
            }
        }
    }


    func checkAuthorizationStatus() {
        SKCloudServiceController.requestAuthorization { status in
            DispatchQueue.main.async {
                self.authorizationStatus = (status == .authorized)
            }
        }
    }

    func requestAppleMusicCapabilities() {

        let controller = SKCloudServiceController()
        print(SKCloudServiceController.authorizationStatus() == .authorized)
            controller.requestCapabilities { capabilities, error in()

                print("capabilities: \n\(capabilities)")

            if capabilities.contains(.musicCatalogPlayback) {
                // User has Apple Music account
                DispatchQueue.main.async {
                    self.appleMusicEnabled = true
                }
            }
            else if capabilities.contains(.musicCatalogSubscriptionEligible) {
                // User can sign up to Apple Music

            }
        }

    }
}
