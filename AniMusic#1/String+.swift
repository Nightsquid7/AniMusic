//
//  String+.swift
//  AniMusic#1
//
//  Created by Steven Berkowitz on R 1/12/27.
//  Copyright © Reiwa 1 nightsquid. All rights reserved.
//

import Foundation

//contains extensions on String

extension String {
    // replace {w} and {h} with height of image in pixels
    // from AppleMusic urlString and get URL
    func getImageUrl(with height: Double) -> URL? {
        var returnString = ""
        let heightToString = String(format: "%.0f", height)

        if let wRange = self.range(of: "{w}"){
            returnString = self.replacingCharacters(in: wRange, with: heightToString)
        }
        if let hRange = returnString.range(of: "{h}") {
            returnString = returnString.replacingCharacters(in: hRange, with: heightToString)
        }
        return URL(string: returnString)
    }
}
