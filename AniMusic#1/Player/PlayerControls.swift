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

            ZStack {
                Rectangle()
                    .fill(Color.black)
                    .cornerRadius(3)
                Image(systemName: self.playbackStateImageName)
                    .resizable()
                    .frame(height: g.size.height)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(Color.white)

            } // ZStack
            .onTapGesture {
                self.playManager.playBtnTapped(storeId: self.storeId)
                self.setPlaybackStateImage()
            }
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
