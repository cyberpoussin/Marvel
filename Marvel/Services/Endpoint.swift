//
//  Endpoint.swift
//  Endpoint
//
//  Created by Adrien S on 01/09/2021.
//

import Foundation

struct Endpoint<ResponseType: Decodable>: RequestBuilderWithReponseType {
    enum Get {
        case fetchAllCharacters
    }
    enum Post {
        case none
    }
    
    var request: URLRequest? {
        var request = URLRequest(url: components.url!)
        request.httpBody = data
        return request
    }
    
    private var components: URLComponents
    var data: Data?
        
    init() {
        components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/"
        let ts = "\(Date().timeIntervalSince1970)"
        let publicKey = "f5e7ff0c9a0c749188fe15528ca9ea0f"
        let privateKey = "2fa7a078baeb5e075c6ffc7a43cad70d87db128f"
        let hash = (ts+privateKey+publicKey).MD5()
        components.queryItems = [
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "series", value: "3971"),

        ]
    }
    
    init(_ endpoint: Get) {
        self.init()
        switch endpoint {
        case .fetchAllCharacters:
            components.path += "characters"
        }
    }
    
    init<Body: Encodable>(_ endpoint: Post, body: Body) {
        self.init()
        switch endpoint {
        case .none:
            break
        }
        self.data = try? JSONEncoder().encode(body)
    }
}

extension RequestBuilderWithReponseType where Self == Endpoint<CharactersRequestResponse>  {
    static func fetchAllCharacters() -> Self {
        return Endpoint(.fetchAllCharacters)
    }
}
