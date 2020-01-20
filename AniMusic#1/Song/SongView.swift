//
//  SongView.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI
import MediaPlayer


struct SongView: View {


    var storeId: String
    @EnvironmentObject var player: PlayManager
    
    init (song: Song) {
        self.song = song
        self.storeId = song.id
    }

    var song: Song



    var body: some View {
        VStack {
            Image(uiImage: song.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal)
            Text(song.name)

            Text(song.artist)

            ZStack {
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(7)
                    .onTapGesture {
                        if let url = URL(string: self.song.appleMusicURL) {
                            UIApplication.shared.open(url)
                        }
                }

                Text("+")
                    .font(.title)
            }


            PlayerControls(storeId: self.storeId)


        }
    }
}

//struct SongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongView(song: Song(name: "son", artist: "artist", type: SongType(rawValue: "opening")!, imageURL: "www.", previewURL: "www.", appleMusicURL: "www."))
//    }
//}
