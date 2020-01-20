//
//  Song.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/04.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import Combine
import MediaPlayer

class Song: Decodable, Identifiable, ObservableObject {
    var id: String
    var name: String
    var artist: String
    var type: SongType
    var imageURL: URL?
    var appleMusicURL: String

    @Published var image: UIImage?
    var disposables = Set<AnyCancellable>()

    enum CodingKeys: String, CodingKey {
        case id, name, artist, type, appleMusicURL
    }

    init(id: String, name: String, artist: String, type: String, imageURL: URL,  appleMusicURL: String) {
        self.id = id
        self.name = name
        self.artist = artist
        self.type = SongType.init(rawValue: type)!
        self.appleMusicURL = appleMusicURL
        let imageL = ImageLoader()
        _ = imageL.getImage(url: imageURL)
            .sink(receiveValue: { image in
                if let image = image {

                    self.image = image
                }
            })
            .store(in: &disposables)
    }
}

enum SongType: String, Codable {
    case opening = "opening"
    case ending = "ending"
}

extension Song {
    convenience init?(json: [String: Any]) {

        guard let attributes = json["attributes"] as? [String: Any],
            let id = json["storeId"] as? String,
            let artwork = attributes["artwork"] as? [String: Any],
            let height = artwork["height"] as? Double,
            let imageUrlString = artwork["url"] as? String,
            let imageURL = imageUrlString.getImageUrl(with: height)

            else {
                print("couldn't initialize Song\n\n \(json)")
                return nil
        }

        self.init(id: id,
                  name: attributes["name"] as? String ?? "",
                  artist: attributes["artistName"] as? String ?? "",
                  type: json["type"] as? String ?? "opening",
                  imageURL: imageURL,
                  appleMusicURL: attributes["url"] as? String ?? "")

    }
}


