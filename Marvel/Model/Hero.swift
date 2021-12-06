//
//  Hero.swift
//  Marvel
//
//  Created by Adrien S on 04/12/2021.
//

import Foundation

struct Hero: Identifiable, Equatable {
    var id: Int
    var name: String
    let description: String
    let imageURL: URL?
}
