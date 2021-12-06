//
//  HeroesListScreen.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//
import Combine
import SwiftUI

class HeroesListViewModel: ObservableObject {
    @Published var heroes: [Hero] = []
    @Published var favoriteHeroes: [Hero] = []

    var store: HeroesStore
    
    init(store: HeroesStore) {
        self.store = store
        
        store.$heroes
            .receive(on: DispatchQueue.main)
            .assign(to: &$heroes)
        
        store.$favoriteHeroes
            .assign(to: &$favoriteHeroes)
    }
    
    func destination(hero: Hero) -> some View {
        HeroDetailsScreen(vm: HeroDetailsViewModel(hero: hero, store: store))
    }
    
    func onAppear() {
        store.input.send(.initialize)
    }
}

struct HeroesListScreen: View {
    @ObservedObject var vm: HeroesListViewModel
    var body: some View {
        if vm.heroes.isEmpty {
            LoadingView()
                .onAppear(perform: vm.onAppear)
        } else {
            HeroesList(
                heroes: vm.heroes,
                favorites: vm.favoriteHeroes,
                destination: vm.destination
            )
        }
    }
}

struct LoadingView: View {
    @State private var text = "Loading"
    var body: some View {
        Text(text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(Font.Details.title)
            .foregroundColor(Color.font)
            .background(Color.background.ignoresSafeArea())
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    text += "..."
                }
            }
    }
}

struct HeroesListScreen_Previews: PreviewProvider {
    static var previews: some View {
        HeroesListScreen(vm: HeroesListViewModel(store: HeroesStore(services: Services())))
    }
}
