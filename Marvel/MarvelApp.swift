//
//  MarvelApp.swift
//  Marvel
//
//  Created by Admin on 03/12/2021.
//

import SwiftUI

@main
struct MarvelApp: App {
    var body: some Scene {
        WindowGroup {
            ImageLoader(imageUrl: URL(string: "https://images.unsplash.com/photo-1453733190371-0a9bedd82893?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=3264&q=80"), mask: Rectangle()) {
                Rectangle()
            }
        }
    }
}
