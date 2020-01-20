//
//  PlayerControls.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/19.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import SwiftUI
import MediaPlayer

struct PlayerControls: View {

    @EnvironmentObject var playManager: PlayManager
    var storeId: String
    @State var playbackStateImageName = "play.circle"

    func setPlaybackStateImage() {
            switch self.playManager.player.playbackState {
                case .playing:
                    self.playbackStateImageName = "pause.circle"
                case .paused:
                    self.playbackStateImageName = "play.circle"
                case .stopped, .interrupted:
                    self.playbackStateImageName = "play.circle"
                default:
                    print("Default setPlaybackStateImage")

        }
    }

    var body: some View {
        GeometryReader { g in

            HStack {
                Image(systemName: self.playbackStateImageName)
                    .resizable()
                    .foregroundColor(Color.red)
                    .frame(width: g.size.width/2, height: g.size.width/2)
                    .onTapGesture {

                        self.playManager.playBtnTapped(storeId: self.storeId)
                        self.setPlaybackStateImage()
                }// imageTapGesture
                Text("\(self.playManager.currentPlaybackTime)")
            } // HStack
        }
        .onAppear(perform: {
            // if storeId matched current playing item - reflect the playback state
            if self.playManager.player.nowPlayingItem?.playbackStoreID == self.storeId {
                self.setPlaybackStateImage()
            }
            // else - the play button will play new song from storeId
        })
    }
}


struct PlayerControls_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControls(storeId: "2534618695")
    }
}
