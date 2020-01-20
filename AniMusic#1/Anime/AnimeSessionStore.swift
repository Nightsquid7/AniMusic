//
//  AnimeSessionStore.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/16.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine

class AnimeSessionStore: ObservableObject {
    @Published var list = [Anime]()

    let db = Firestore.firestore()

    func getAnimeList() {

        db.collection("Anime").getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error), \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        if let anime = Anime.init(json: document.data()) {
                            self.list.append(anime)
                        }
                    }
                }
        }
    }
}
