//
//  SingleImageItem.swift
//  New Collection design
//
//  Created by Anas Almomany on 17/01/2022.
//

import Foundation

struct SingleImageItem: Codable {
    struct Image: Codable {
        var url: String
        var width: Double
        var height: Double
    }

    var titleInfo: String

    // Url to pass if want to display full hd
    var mainImage: Image?
    var thumbnail: Image?

    static func generateDumyImage() -> SingleImageItem {
        let randomImageH = Int.random(in: 300...2000)
        let randomImageW = Int.random(in: 300...2000)

        let urlString = "https://source.unsplash.com/random/\(randomImageH)x\(randomImageW)?sig=\(Int.random(in: 0...5000))"
        let mockedDummy = SingleImageItem(
            titleInfo: "Dummy",
            // Full hd image to be used afte user tap on thumb
            mainImage: Image(url: urlString,
                             width: Double(randomImageW),
                             height: Double(randomImageH))
            ,
            thumbnail: Image(url: urlString,
                             width: Double(randomImageW),
                             height: Double(randomImageH))
            )
        return mockedDummy
    }
}
