//
//  Samples.swift
//  Marvel
//
//  Created by Admin on 06/12/2021.
//

import Foundation

extension Hero {
    static var HERO1: Hero = Array.HEROES[0]
    static var HERO2: Hero = Array.HEROES[1]
    static var HERO3: Hero = Array.HEROES[2]
}

extension Array where Element == Hero {
    static var HEROES: [Hero] = [
        Hero(id: 1011334, name: "3-D Man", description: "", imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")),
        Hero(id: 1017100, name: "A-Bomb (HAS)", description: "Rick Jones has been Hulk\'s best bud since day one, but now he\'s more than a friend...he\'s a teammate! Transformed by a Gamma energy explosion, A-Bomb\'s thick, armored skin is just as strong and powerful as it is blue. And when he curls into action, he uses it like a giant bowling ball of destruction! ", imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg")),
        Hero(id: 1009144, name: "A.I.M.", description: "AIM is a terrorist organization bent on destroying the world.", imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/6/20/52602f21f29ec.jpg")),
        Hero(id: 1010699, name: "Aaron Stack", description: "", imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg")),
        Hero(id: 1009146, name: "Abomination (Emil Blonsky)", description: "Formerly known as Emil Blonsky, a spy of Soviet Yugoslavian origin working for the KGB, the Abomination gained his powers after receiving a dose of gamma radiation similar to that which transformed Bruce Banner into the incredible Hulk.", imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/50/4ce18691cbf04.jpg"))
    ]
}
