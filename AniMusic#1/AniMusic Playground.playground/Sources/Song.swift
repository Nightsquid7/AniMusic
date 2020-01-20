//
//  Song.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/04.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation

public struct Song: Codable {
    var name: String
    var artist: Artist
    var albumName: String
    var artwork: String?
    var composerName: String?
    var discNumber: Int?
    var durationInMillis = 193202;
    var href: String

    enum CodingKeys: String, CodingKey {
        case name, artist, albumName, artwork, href

    }
}

extension Song {
    public init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let artist = json["artist"] as? Artist,
            let albumName = json["albumName"] as? String,
            let href = json["href"] as? String

        else {
            return nil
        }
        self.name = name
        self.artist = artist
        self.albumName = albumName
        self.href = href
    }

}








    //
    // https://github.com/ikesyo/Himotoki
    //    var genreNames =             (
    //        "\U30dd\U30c3\U30d7",
    //        "\U30df\U30e5\U30fc\U30b8\U30c3\U30af"
    //    )

    //
    //    var hasLyrics = 1;
    //    not sure what this is...
    //    var varisrc = USA2P1627750;


    /*
     albumName = "One Piece (Legacy Mix) - Single";
         artistName = Neotokio3;
         artwork =             {
             bgColor = 010f01;
             height = 1400;
             textColor1 = ffffff;
             textColor2 = ff6d00;
             textColor3 = cccecc;
             textColor4 = cc5a00;
             url = "https://is4-ssl.mzstatic.com/image/thumb/Music69/v4/13/a1/e0/13a1e025-454e-24a2-beea-fcd04fde07eb/889326595700_Cover.jpg/{w}x{h}bb.jpeg";
             width = 1400;
         };
         composerName = Neotokio3;
         discNumber = 1;
         durationInMillis = 193202;
         genreNames =             (
             "\U30dd\U30c3\U30d7",
             "\U30df\U30e5\U30fc\U30b8\U30c3\U30af"
         );
         hasLyrics = 1;
         isrc = USA2P1627750;
         name = "One Piece (Legacy Mix)";
         playParams =             {
             id = 1097194752;
             kind = song;
         };
         previews =             (
                             {
                 url = "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview20/v4/2c/69/b9/2c69b933-3e7e-ebae-c5e1-bce1e2d4f72c/mzaf_4854412078756699132.plus.aac.p.m4a";
             }
         );
         releaseDate = "2016-03-21";
         trackNumber = 1;
         url = "https://music.apple.com/jp/album/one-piece-legacy-mix/1097194105?i=1097194752";
     };
     href = "/v1/catalog/jp/songs/1097194752";
     id = 1097194752;
     type = songs;
     */

