//
//  ContentView.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/03.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI
import Swift
import StoreKit
import Firebase

struct ContentView: View {

    @EnvironmentObject var animeSession: AnimeSessionStore
    @EnvironmentObject var appleMusicStore: AppleMusicStore

    var body: some View {
        NavigationView {
            VStack {
                Text("Anime")
                    .font(.largeTitle)

                if animeSession.list.count < 1 {
                    Text("Loading... ^-^")
                } else {
                    List(animeSession.list) { anime in
                        NavigationLink(destination: AnimeView(anime: anime), label: {
                            AnimeCellView(anime: anime)
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            self.animeSession.getAnimeList()
            self.appleMusicStore.requestUserToken()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
