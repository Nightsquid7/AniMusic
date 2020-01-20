//
//  ImageLoader.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/17.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation
import class UIKit.UIImage
import Combine

class ImageLoader: ObservableObject {


    func getImage(urlString: String) -> AnyPublisher<UIImage?,Never> {
        let url = URL(string: urlString)
        return URLSession.shared
            .dataTaskPublisher(for: url ?? URL(string: "https://developer.apple.com/")!)
            .map { data, _ in UIImage(data: data)}
//            .print("image")
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .eraseToAnyPublisher()

    }

    func getImage(url: URL?) -> AnyPublisher<UIImage?,Never> {

            return URLSession.shared
                .dataTaskPublisher(for: url ?? URL(string: "https://developer.apple.com/")!)
                .map { data, _ in UIImage(data: data)}
//                .print("image: ")
                .receive(on: DispatchQueue.main)
                .replaceError(with: nil)
                .eraseToAnyPublisher()

        }


}
