//
//  HeroesProvider.swift
//  Marvel
//
//  Created by Admin on 04/12/2021.
//
import Combine
import Foundation

class HeroesProvider {
    let networkService: NetworkService
    init(services: Services) {
        networkService = services.networkService
    }
    func fetchAllHeroes() -> AnyPublisher<[Hero], Error> {
        networkService.execute(requestBuiltBy: .fetchAllCharacters())
            .map {
                $0.data.results
            }
            .eraseToAnyPublisher()
    }
}
