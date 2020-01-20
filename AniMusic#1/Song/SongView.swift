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
    let padding: CGFloat = 20
    
    init (song: Song) {
        self.song = song
        self.storeId = song.id
    }

    var song: Song


    var body: some View {
        GeometryReader { g in

            VStack {

                Image(uiImage: self.song.image ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: g.size.width - self.padding, height: g.size.width - self.padding)

                Text(self.song.name)

                Text(self.song.artist)

                PlayerControls(storeId: self.storeId)
                    .padding(.horizontal, self.padding)

                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .cornerRadius(3)
                        .onTapGesture {
                            if let url = URL(string: self.song.appleMusicURL) {
                                UIApplication.shared.open(url)
                            }
                    }

                    Text("+ add song to Library")
                        .foregroundColor(Color.white)

                } // ZStack
                    .padding(.horizontal, self.padding)
            }
        }

    }
}

//struct SongView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongView(song: Song(name: "son", artist: "artist", type: SongType(rawValue: "opening")!, imageURL: "www.", previewURL: "www.", appleMusicURL: "www."))
//    }
//}
