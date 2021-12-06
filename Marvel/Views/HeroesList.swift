//
//  HeroesList.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import SwiftUI

struct HeroesList<Destination: View>: View {
    let heroes: [Hero]
    let favorites: [Hero]

    @State private var selectedHero: Hero?
    var destination: (Hero) -> Destination
    @ViewBuilder func destinationBuilder() -> some View {
        if let selectedHero = selectedHero {
            destination(selectedHero)
        } else {
            Text("error")
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.cell)
                    .frame(height: 1)
                NavigationLink(
                    destination: destinationBuilder(),
                    isActive: Binding(get: { selectedHero != nil }, set: { _ in selectedHero = nil })) {
                    EmptyView()
                }

                List {
                    if !favorites.isEmpty {
                        VStack {
                            Text("My squad")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(10)
                                .padding(.horizontal, 20)

                                .font(Font.List.squadTitle)
                            ScrollView(.horizontal) {
                                HStack(alignment: .top, spacing: 0) {
                                    ForEach(favorites) { hero in
                                        Button {
                                            selectedHero = hero
                                        } label: {
                                            FavoritesListCell(hero: hero)
                                        }
                                    }
                                    Spacer()
                                }
                                .frame(height: 140)
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.horizontal, -20)
                        .listRowBackground(Color.background)
                    }
                    Spacer()
                        .frame(height: 1)
                        .listRowBackground(Color.background)
                    ForEach(heroes) { hero in
                        Button {
                            selectedHero = hero
                        } label: {
                            HeroesListCell(hero: hero)
                        }
                        .listRowBackground(selectedHero?.id == hero.id ? Color(UIColor.gray) : Color.background)
                    }
                }
                .listConfiguration(.colored(background: Color.background, rows: Color.background))
                .environment(\.defaultMinListRowHeight, 10)
                .listStyle(PlainListStyle())
            }
            .foregroundColor(Color.font)

            .onAppear {
                selectedHero = nil
            }
            .background(Color.background.ignoresSafeArea())
            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    Image.logo
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .withNavBarConfiguration(.colored(.clear))
        }
    }
}

struct HeroesListCell: View {
    let hero: Hero
    var body: some View {
        HStack(spacing: 15) {
            ImageLoader(imageUrl: hero.imageURL, mask: Circle(), placeHolder: {
                Circle()
                    .foregroundColor(Color.gray)
            })
                .foregroundColor(Color.cell)
                .frame(width: 40, height: 40)
            Text(hero.name)
                .font(Font.List.cell)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Color.chevron)
        }
        .padding()
        .background(Color.cell)
        .cornerRadius(6)
    }
}

struct FavoritesListCell: View {
    let hero: Hero
    var body: some View {
        VStack {
            ImageLoader(imageUrl: hero.imageURL, mask: Circle(), placeHolder: {
                Circle()
                    .foregroundColor(Color.gray)
            })
                .frame(width: 80, height: 80)

            Text(hero.name)
                .font(Font.List.squad)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(width: 100)
    }
}

struct HeroesList_Previews: PreviewProvider {
    static var previews: some View {
        HeroesList(heroes: Array.HEROES, favorites: []) { hero in
            HeroDetailsView(hero: hero, recruited: true)
        }
        HeroesList(heroes: Array.HEROES, favorites: [Hero.HERO1, Hero.HERO2]) { hero in
            HeroDetailsView(hero: hero, recruited: true)
        }
        HeroesList(heroes: [], favorites: [Hero.HERO1, Hero.HERO2]) { hero in
            HeroDetailsView(hero: hero, recruited: true)
        }
        HeroesList(heroes: [], favorites: []) { hero in
            HeroDetailsView(hero: hero, recruited: true)
        }
    }
}
