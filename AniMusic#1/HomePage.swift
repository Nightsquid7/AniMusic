//
//  HomePage.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI
import StoreKit

struct HomePage: View {

    @EnvironmentObject var animeSession: AnimeSessionStore
    @EnvironmentObject var appleMusicStore: AppleMusicStore
    @State var searchTerm: String = ""

    // default photo
    let sfPhoto = UIImage(systemName: "photo")!

    func checkAuthorizationStatus() {
        appleMusicStore.checkAuthorizationStatus()
    }

    func requestAppleMusicCapabilities() {
        appleMusicStore.requestAppleMusicCapabilities()
    }

    func requestUserToken() {
        appleMusicStore.requestUserToken()
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {

                    ZStack {
                        Rectangle()
                            .fill(appleMusicStore.authorizationStatus ? Color.blue : Color.red)
                        .onTapGesture {
                            self.checkAuthorizationStatus()
                    }
                        Text("Enable music")

                    }


                    ZStack {
                        Rectangle()
                            .fill(appleMusicStore.appleMusicEnabled ? Color.blue : Color.red)
                            .onTapGesture {
                                self.requestAppleMusicCapabilities()
                        }
                        Text("request capabilities")
                    }


                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .onTapGesture {
                                self.animeSession.list.removeAll()
                                self.animeSession.getAnimeList()
                        }
                        Text("Re load AnimeList")
                            .foregroundColor(Color.white)
                    }
                    }
                                        .frame(height: 100)
                    .padding(.horizontal, 20)


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
            self.requestUserToken()
        })
    }

}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
