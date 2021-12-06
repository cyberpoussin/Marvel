//
//  HeroesStore.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import Combine
import SwiftUI

/// A Store for heroes fetched from MarvelApi (allHeroes) and favoriteHeroes (the squad)
/// Interacts with HeroesProvider (to fetch the Api) and KeyValueService (to save favorites on disk).
/// Accepts Inputs (from ViewModels)
class HeroesStore: ObservableObject {
    // MARK: - Inputs
    enum Input {
        case initialize
        case addToFavorites(Hero)
        case deleteFavorite(Hero)
    }
    var input = PassthroughSubject<Input, Never>()

    // MARK: - Outputs
    @Published private var allHeroes: [Hero]
    @Published private(set) var heroes: [Hero]
    @Published private(set) var favoriteHeroes: [Hero]

    private var bag = Set<AnyCancellable>()
    private var services: Services
    private var heroesProvider: HeroesProvider
    
    /// init(services:)
    /// - Parameter services: the services that will be used to fetch heroes and save them on disk
    init(services: Services) {
        self.allHeroes = []
        self.heroes = []
        self.favoriteHeroes = []
        self.services = services
        self.heroesProvider = HeroesProvider(services: services)
        
        // MARK: - Computed properties
        // The heroes property depends of allHeroes and favorites
        $favoriteHeroes
            .withLatestFrom($allHeroes)
            .compactMap { favorites, allHeroes in
                allHeroes.filter {hero in !favorites.contains {$0.id == hero.id}}
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$heroes)
        
        $allHeroes
            .withLatestFrom($favoriteHeroes)
            .map {heroes, favorites in heroes.filter {hero in !favorites.contains {$0.id == hero.id}} }
            .receive(on: DispatchQueue.main)
            .assign(to: &$heroes)
        
        // MARK: - From Input to Actions
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
        
        // MARK: - Side effects
        // On initialization or refresh, if the allHeroes array is empty, we fetch the marvel api to populate it
        input.withLatestFrom($heroes)
            .compactMap {input, heroes -> Input? in
                guard heroes.isEmpty else {return nil}
                switch input {
                case .initialize: return input
                default: return nil
                }
            }
            .flatMap {[weak heroesProvider] _ in
                heroesProvider?.fetchAllHeroes() ?? Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: &$allHeroes)
    }
    
    /// saveToDisk(favorites:)
    /// - Parameter favorites: the favorite heroes to save on disk
    func saveToDisk(favorites: [Hero]) {
        services.keyValueService[key: "Favorites", type: [Hero].self] = favorites
    }
}
