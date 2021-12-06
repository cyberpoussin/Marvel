//
//  APISession.swift
//  LocalformanceBeta
//
//  Created by Admin on 27/05/2021.
//

import Combine
import Foundation


class APISession: NSObject, NetworkService {
    lazy var decoder: JSONDecoder = {
        let jd = JSONDecoder()
        // jd.dateDecodingStrategy = .secondsSince1970
        return jd
    }()

    lazy var session: URLSession = {
        .init(configuration: .default, delegate: self, delegateQueue: nil)
    }()

    func execute(_ request: URLRequest) -> AnyPublisher<Data, NetworkServiceError> {
        print("requête : \(request); \(request.httpMethod!); \(String(data: request.httpBody ?? Data(), encoding: .utf8)!)")
        guard let _ = request.url else {
            return Fail(error: NetworkServiceError.invalidRequest).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkServiceError.unknownError
                }
                print(String(data: data, encoding: .utf8)!)
                switch response.statusCode {
                case 200 ... 299: return data
                default: throw self.httpError(response.statusCode)
                }
            }
            .mapError { error in
                self.handleError(error)
            }
            .eraseToAnyPublisher()
    }
}


extension APISession {
    func download(_ 
        request: URLRequest
    ) -> AnyPublisher<FileResponse, NetworkServiceError> {
        return session.downloadTaskPublisher(request: request)
            .tryMap { (data, response, progress) -> FileResponse in
                guard response != nil else { return FileResponse.progress(percentage: progress) }
                guard let data = data else { throw NetworkServiceError.readingDownloadedFileError }
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkServiceError.unknownError
                }
                switch response.statusCode {
                case 200 ... 299: return .data(data)
                default: throw self.httpError(response.statusCode)
                }
            }
            .mapError { error in
                self.handleError(error)
            }
            .eraseToAnyPublisher()
    }
}

extension APISession: URLSessionTaskDelegate, URLSessionDelegate {
       
}

