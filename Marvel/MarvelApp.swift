//
//  MarvelApp.swift
//  Marvel
//
//  Created by Adrien S on 03/12/2021.
//

import SwiftUI

@main
struct MarvelApp: App {
    var body: some Scene {
        WindowGroup {
            HeroesListScreen(vm: HeroesListViewModel(store: HeroesStore(services: Services())))
        }
    }
}
