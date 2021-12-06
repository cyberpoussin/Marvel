//
//  ContentView.swift
//  Marvel
//
//  Created by Admin on 03/12/2021.
//
import Combine
import SwiftUI

struct ContentView: View {
    @State private var c = Set<AnyCancellable>()
    @State private var heroes: [Hero] = []
    let heroesProvider = HeroesProvider(services: Services())
    var body: some View {
        VStack {
            ForEach(heroes) {hero in
                Text(hero.name)
            }
        }
            .padding()
            .onAppear {
                heroesProvider.fetchAllHeroes()
                    .replaceError(with: [])
                    .sink {
                        self.heroes = $0
                    }
                    .store(in: &c)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
