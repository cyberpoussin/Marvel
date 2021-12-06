//
//  HeroDetailsScreen.swift
//  TestsForJoot
//
//  Created by Admin on 06/12/2021.
//

import SwiftUI

class HeroDetailsViewModel: ObservableObject {
    let hero: Hero
    private var store: HeroesStore
    var recruited: Bool

    init(hero: Hero, store: HeroesStore) {
        self.hero = hero
        self.store = store
        recruited = store.favoriteHeroes.contains(where: { $0.id == hero.id })
    }

    func recruit(_ recruit: Bool) {
        if recruit {
            store.input.send(.addToFavorites(hero))
        } else {
            store.input.send(.deleteFavorite(hero))
        }
    }
    func refresh() {
        store.input.send(.initialize)
    }
}

struct HeroDetailsScreen: View {
    @ObservedObject var vm: HeroDetailsViewModel
    var body: some View {
        HeroDetailsView(hero: vm.hero,
                        recruited: vm.recruited,
                        onRecruit: vm.recruit,
                        onDismiss: vm.refresh)
    }
}
struct HeroDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        HeroDetailsScreen(vm: HeroDetailsViewModel(hero: Hero.HERO1, store: HeroesStore(services: Services())))
    }
}
