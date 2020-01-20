//
//  Anime.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import Combine


class Anime: Identifiable, Decodable, ObservableObject {
    var id: String
    var songs: [Song] = []
    var openings: [Song] = []
    var endings: [Song] = []
    var imageURL: String
    var songIds = [String]()


    @Published var image: UIImage?
    var disposables = Set<AnyCancellable>()

    enum CodingKeys: String, CodingKey {
        case id, songs, imageURL
    }

    // Initialize and load image
    init(id: String, imageURL: String) {
        self.id = id
        self.imageURL = imageURL
        let imageL = ImageLoader()
        _ = imageL.getImage(urlString: imageURL)
            .sink(receiveValue: { image in
                if let image = image {
                    self.image = image
                }
            })
        .store(in: &disposables)
    }

}


extension Anime {
    // initialize Anime instance from JSON
    convenience init?(json: [String: Any]) {
        guard let id = json["id"] as? String,
              let songs = json["songs"] as? [String: Any],
              let imageURL = json["imageURL"] as? String
            else {
                return nil
        }

        self.init(id: id, imageURL: imageURL)

        // initialize song, and add to Set<Song>
        for (_ , value) in songs {
            if let songsDict = value as? [String: Any],
                let song = Song(json: songsDict) {
                self.songs.append(song)
                if song.type == .opening {
                    self.openings.append(song)
                }
                if song.type == .ending {
                    self.endings.append(song)
                }
                songIds.append(song.id)
            }
        }
    }
}
