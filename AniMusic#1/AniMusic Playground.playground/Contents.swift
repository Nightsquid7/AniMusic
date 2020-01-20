import UIKit
import StoreKit

let developerToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkdSM1VBNjM2TEwifQ.eyJpc3MiOiJFOTM5QkJaNlg0IiwiaWF0IjoxNTc1NTI3MDU4LCJleHAiOjE1OTEyODQyNTh9.nG18YH_R3Yj-n7T7dcTUubby1GZx52ic0WlxlI-KTmK1XEwWVgpZefSTRO7fryfcC6IJqb0a1BHAYODrumM5cA"
let userToken = "AsQiY9HDyM4hgBgVpZc4fENYD012ePAEplznIQlac2BUsrDUbwzvqCFMdWAs5aiSVDCTytpQ/eT8Huk9Cb703qAXH/CEDdBSPvAHDQlmzNre2y9bku6JkA+1Cwl3sf8IkjZ8adMMIz9D2UTGN8P+HsCo2/sKcyVc0KJlAFR1SI7bTRhufBVqiZtb33jBdqTcFzdTCyZNuTgm3oomxlXEvGoOGALLKQjtSpt0D8X5/S4Xz9noSA=="

let anime = Anime(id: "Hunter X Hunter",imageURL: "www.com")
var components = URLComponents()

        components.scheme = "https"
        components.host   = "api.music.apple.com"
        components.path   = "/v1/me/library/playlists"

        var json: [String: Any] =
            ["attributes": [
            "name": anime.id,
            "description": "contains all songs from \(anime.id)"],
           "relationships": [
            "tracks": [
                "data":  [
                    "id": anime.songIds[0],
                    "type": "songs"
                ]

            ]
            ]]
        anime.songIds.forEach { id in
            if let relationships = json["relationships"] as? [String: Any],
                let tracks = relationships["tracks"] as? [String: Any],
                let data = tracks["data"]  as? [[String: String]] {
//                data.append(id)
                print("data: \(data)")
            }
            else {
                print("did not get it...")
            }
        }
        let url = components.url!

        var request = URLRequest(url: url)
        request.setValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        request.setValue(userToken, forHTTPHeaderField: "Music-User-Token")
