//
//  AnimeCell.swift
//  abseil
//
//  Created by Steven Berkowitz on R 1/12/17.
//

import SwiftUI

struct AnimeCellView: View {

    @ObservedObject var anime: Anime
    var defaultImage = UIImage(systemName: "photo")!

    init(anime: Anime) {
        self.anime = anime
    }

    var body: some View {
        HStack {
            Image(uiImage: self.anime.image ?? self.defaultImage)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 50, height: 50)

            Text(anime.id)

        }
    }
}

struct AnimeCell_Previews: PreviewProvider {
    static var previews: some View {
        AnimeCellView(anime: Anime(id: "anime", imageURL: "imageURL"))
    }
}
