//
//  Movie.swift
//  RumblApp
//
//  Created by Umamaheshwari on 29/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import Foundation
import UIKit
struct Movie: Codable {
    var title: String?
    var nodes: [VideoNode]
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case nodes = "nodes"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        nodes = try values.decode([VideoNode].self, forKey: .nodes)
    }
}
    
struct VideoNode: Codable {
    var video: Video
    enum CodingKeys: String, CodingKey {
        case video = "video"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        video = try values.decode(Video.self, forKey: .video)

    }
}

struct Video: Codable {
    var encodeUrl: String
    var downloadedImage: UIImage?
    enum CodingKeys: String, CodingKey {
        case encodeUrl = "encodeUrl"
    }
}

struct CellViewModel {
    let image: UIImage
}
