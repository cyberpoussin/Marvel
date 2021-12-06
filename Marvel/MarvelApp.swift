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
            HeroesList(heroes: Array.HEROES, favorites: [Hero.HERO1, Hero.HERO2]) { hero in
                HeroDetailsView(hero: hero, recruited: true)
            }
        }
    }
}
