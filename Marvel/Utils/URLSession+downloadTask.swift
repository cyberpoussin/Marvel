//
//  URLSession+extension.swift
//  NetworkTemplate
//
//  Created by Admin on 21/10/2021.
//

import Combine
import Foundation

extension URLSession {

    func downloadTaskPublisher(
        request: URLRequest
    ) -> AnyPublisher<(Data?, URLResponse?, Double), Error> {
        let subject: PassthroughSubject<(Data?, URLResponse?, Double), Error> = .init()
        let task: URLSessionDownloadTask = downloadTask(
            with: request
        ) { url, response, error in
            if let error = error {
                subject.send(completion: .failure(error))
                return
            }
            guard let url = url, let data = try? Data(contentsOf: url, options: [.dataReadingMapped, .uncached]) else {
                let error = URLError(.fileDoesNotExist)
                subject.send(completion: .failure(error))
                return
            }
            subject.send((data, response, 1))
            subject.send(completion: .finished)
        }
        let receivedPublisher = task.publisher(for: \.countOfBytesReceived)
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true) // adjust
        let expectedPublisher = task.publisher(for: \.countOfBytesExpectedToReceive, options: [.initial, .new])
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
        task.resume()
        return Publishers.CombineLatest(receivedPublisher, expectedPublisher)
            .setFailureType(to: Error.self)
            .map { received, expected in
                print("received : \(received) and expected: \(expected)")
                guard expected != 0 else { return (nil, nil, 0) }
                return (nil, nil, Double(received) / Double(expected))
            }
            .merge(with: subject)
            .handleEvents(receiveCancel: {
                task.cancel()
            })
            .eraseToAnyPublisher()
    }
    
    
}
