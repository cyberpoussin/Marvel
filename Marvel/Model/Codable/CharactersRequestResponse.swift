//
//  CharactersRequestResponse.swift
//  Marvel
//
//  Created by Adrien S on 04/12/2021.
//

import Foundation

struct CharactersRequestResponse: Codable {
    var data: ResponseWrapper
}

extension CharactersRequestResponse {
    struct ResponseWrapper: Codable {
        var results: [Hero]
    }
}

extension Hero: Codable {
    enum ThumbnailCodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let thumbnailContainer = try container.nestedContainer(keyedBy: ThumbnailCodingKeys.self, forKey: .thumbnail)
        let path = try thumbnailContainer.decode(String.self, forKey: .path)
        let ext = try thumbnailContainer.decode(String.self, forKey: .ext)
        var components = URLComponents(string: path)
        components?.scheme = "https"
        var url = components?.url
        url?.appendPathExtension(ext)
        imageURL = url

    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        var thumbnailContainer = container.nestedContainer(keyedBy: ThumbnailCodingKeys.self, forKey: .thumbnail)
        try thumbnailContainer.encode(imageURL?.pathExtension, forKey: .ext)
        let path = imageURL?.deletingPathExtension()
        try thumbnailContainer.encode(path?.absoluteString, forKey: .path)
    }
}


