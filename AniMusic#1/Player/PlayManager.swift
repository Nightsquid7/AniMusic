//
//  Player.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/18.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import MediaPlayer
import Combine

class PlayManager: ObservableObject {

    @Published var  player = MPMusicPlayerController.systemMusicPlayer
    @Published var queue: MPMusicPlayerStoreQueueDescriptor?
    @Published var currentPlaybackTime: TimeInterval = 0.0

    let publisher = NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange)
    var disposables = Set<AnyCancellable>()
    let timePublisher = Timer.publish(every: 1.0/14, on: .main, in: .common)

    init() {
        player.beginGeneratingPlaybackNotifications()
       _ = timePublisher
            .autoconnect()
            .sink(receiveValue: { _ in
                self.currentPlaybackTime = self.player.currentPlaybackTime
            })
            .store(in: &disposables)

    }

    // play, pause or stop the player based on
    // player state

    //
    func playBtnTapped(storeId: String) {
        if player.nowPlayingItem?.playbackStoreID != storeId {
            player.setQueue(with: [storeId])
            player.skipToNextItem()
            player.play()
        }
        else {
            switch player.playbackState {
                case .paused, .stopped, .interrupted:
                    player.play()
                case .playing:
                    player.pause()
                default:
                    print("default...")
                }
        }

    }


}
