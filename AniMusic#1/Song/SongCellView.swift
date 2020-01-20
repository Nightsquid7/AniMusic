//
//  SongCellView.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/18.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI

struct SongCellView: View {
    var song: Song

    var body: some View {
        HStack {
            Image(uiImage: song.image ?? UIImage(systemName: "photo")!)
            .resizable()
            
                .frame(width: 50,height: 50)

            VStack {
                Text(song.name)
                    .font(.subheadline)
                Text(song.artist)
                    .font(.subheadline)
                Text(song.type.rawValue)
                    .font(.subheadline)
            }
        }
    }
}

//struct SongCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongCellView(song: Song(id: "song", name: "name", artist: "artist", type: .opening, imageURL: "www", previewURL: "ww", appleMusicURL: "www", image: nil))
//    }
//}
