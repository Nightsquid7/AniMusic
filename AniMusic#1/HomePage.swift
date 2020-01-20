//
//  HomePage.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI

struct HomePage: View {

    @EnvironmentObject var animeSession: AnimeSessionStore
    @EnvironmentObject var appleMusicStore: AppleMusicStore

    var body: some View {
        NavigationView {
            VStack {

            if animeSession.list.count < 1 {
                Text("No Animes")
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

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
