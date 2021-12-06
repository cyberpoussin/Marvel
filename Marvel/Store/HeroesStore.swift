//
//  HeroesStore.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import Combine
import SwiftUI

class HeroesStore: ObservableObject {
    enum Input {
        case initialize
        case addToFavorites(Hero)
        case deleteFavorite(Hero)
    }
    @Published private(set) var heroes: [Hero]
    @Published private(set) var favoriteHeroes: [Hero]
    var input = PassthroughSubject<Input, Never>()
    private var bag = Set<AnyCancellable>()
    private var services: Services
    private var heroesProvider: HeroesProvider
    init(services: Services) {
        self.heroes = []
        self.favoriteHeroes = []
        self.services = services
        self.heroesProvider = HeroesProvider(services: services)
        $favoriteHeroes
            .compactMap { [weak self] favorites in
                self?.heroes.filter {hero in !favorites.contains {$0.id == hero.id}}
            }
            .assign(to: &$heroes)
        input
            .sink {[weak self ] input in
                guard let self = self else {return}
                switch input {
                case .initialize:
                    self.favoriteHeroes = services.keyValueService[key: "Favorites", type: [Hero].self] ?? []
                case .addToFavorites(let hero):
                    self.saveToDisk(favorites: self.favoriteHeroes + [hero])
                case .deleteFavorite(let hero):
                    self.saveToDisk(favorites: self.favoriteHeroes.filter {$0.id != hero.id})
                }
            }
            .store(in: &bag)
        
        input.withLatestFrom($heroes)
            .compactMap {input, heroes -> Input? in
                guard !heroes.isEmpty else {return nil}
                switch input {
                case .initialize: return input
                default: return nil
                }
            }
            .flatMap {[weak heroesProvider] _ in
                heroesProvider?.fetchAllHeroes() ?? Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .assign(to: &$heroes)
            
    }
    
    func saveToDisk(favorites: [Hero]) {
        services.keyValueService[key: "Favorites", type: [Hero].self] = favorites
    }
}
