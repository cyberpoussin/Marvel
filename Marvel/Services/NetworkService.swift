//
//  Services.swift
//  Services
//
//  Created by Admin on 01/09/2021.
//

import Combine
import Foundation

public protocol NetworkService {
    var decoder: JSONDecoder { get }

    func execute(_ request: URLRequest) -> AnyPublisher<Data, NetworkServiceError>
    
    func execute<T: Decodable>(_ request: URLRequest, decoding type: T.Type) -> AnyPublisher<T, Error>
    
    func execute<Builder: RequestBuilder, DecodingType: Decodable>(requestBuiltBy builder: Builder, decoding type: DecodingType.Type) -> AnyPublisher<DecodingType, Error>
    
    func execute<Builder: RequestBuilderWithReponseType>(requestBuiltBy builder: Builder) -> AnyPublisher<Builder.ResponseType, Error>
    
    func download(_ 
        request: URLRequest
    ) -> AnyPublisher<FileResponse, NetworkServiceError>
}

public enum FileResponse {
    case progress(percentage: Double)
    case data(Data)
}

extension NetworkService {
    func httpError(_ statusCode: Int) -> NetworkServiceError {
            switch statusCode {
            case 400: return .badRequest
            case 401: return .unauthorized
            case 403: return .forbidden
            case 404: return .notFound
            case 402, 405...499: return .error4xx(statusCode)
            case 500: return .serverError
            case 501...599: return .error5xx(statusCode)
            default: return .unknownError
            }
        }
    func handleError(_ error: Error) -> NetworkServiceError {
            switch error {
            case is Swift.DecodingError:
                return .decodingError
            case let urlError as URLError:
                return .urlSessionFailed(urlError)
            case let error as NetworkServiceError:
                return error
            default:
                return .unknownError
            }
        }
}

extension NetworkService {
    func execute<T: Decodable>(_ request: URLRequest, decoding type: T.Type) -> AnyPublisher<T, Error> {
        execute(request)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func execute<Builder: RequestBuilder, DecodingType: Decodable>(requestBuiltBy builder: Builder, decoding type: DecodingType.Type) -> AnyPublisher<DecodingType, Error> {
        guard let request = builder.request else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return execute(request, decoding: type.self)
            .eraseToAnyPublisher()
    }
    
    func execute<Builder: RequestBuilderWithReponseType>(requestBuiltBy builder: Builder) -> AnyPublisher<Builder.ResponseType, Error> {
        guard let request = builder.request else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return execute(request, decoding: Builder.ResponseType.self)
            .eraseToAnyPublisher()
    }
    
}


public protocol RequestBuilderWithReponseType: RequestBuilder {
    var request: URLRequest? { get }
    associatedtype ResponseType: Decodable
}

public protocol RequestBuilder {
    var request: URLRequest? {get}
} 

public enum NetworkServiceError: LocalizedError, Equatable {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case readingDownloadedFileError
    case urlSessionFailed(_ error: URLError)
    case unknownError
}

