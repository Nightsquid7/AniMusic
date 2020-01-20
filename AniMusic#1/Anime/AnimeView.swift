//
//  AnimeView.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI

enum DisplayType: String {
    case openings = "opening"
    case endings = "ending"
    case all = "all"
}

struct AnimeView: View {

    @EnvironmentObject var appleMusicStore: AppleMusicStore
    @State var displayType: DisplayType = .all
    var anime: Anime

    // show user what types of songs will be added to a playlist
    func getDisplayTypeString() -> String {
        switch displayType {
            case .openings:
                return "add all openings to playlist"
            case .endings:
                return "add all endings to playlist"
            case .all:
                return "add all songs to playlist"
        }
    }

    // returns a list of either all, openings or endings
    func displaySongs() -> some View {

        switch self.displayType {
            case .all:
                return List(anime.songs) { song in
                        NavigationLink(destination: SongView(song: song), label:  {
                            SongCellView(song: song)
                        }) }
            case .openings:
                return List(anime.openings) { song in
                NavigationLink(destination: SongView(song: song), label:  {
                    SongCellView(song: song)
                }) }
            case .endings:
                return List(anime.endings) { song in
                NavigationLink(destination: SongView(song: song), label:  {
                    SongCellView(song: song)
                }) }
        }

    }
    
    var body: some View {
        GeometryReader { g in

        VStack {

            Image(uiImage: self.anime.image ?? UIImage(systemName: "photo")!)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: g.size.width/3)


            Picker(selection: self.$displayType, label: Text(""), content: {
                Text("all").tag(DisplayType.all)
                Text("opening").tag(DisplayType.openings)
                Text("ending").tag(DisplayType.endings)
            })
            .pickerStyle(SegmentedPickerStyle())

            self.displaySongs()

            // add songs to playlist
            ZStack {
                Rectangle()
                    .frame(width: g.size.width - 20, height: g.size.width/7)
                    .onTapGesture {
                        self.appleMusicStore.createAnimePlaylist(from: self.anime, type: self.displayType)
                    }

                HStack {

                    Text("+")
                        .foregroundColor(Color.white)
                    Text(self.getDisplayTypeString())
                        .foregroundColor(Color.white)
                }

            }
            }
        }
        .navigationBarTitle(anime.id)


    }

}

struct AnimeView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeView(anime: Anime(id: "AnimeView-Anime", imageURL: "www.com"))
    }
}
