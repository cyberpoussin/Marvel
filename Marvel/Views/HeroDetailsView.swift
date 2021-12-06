//
//  HeroDetailsView.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import SwiftUI

// MARK: HeroDetailsView
// Displays informations about an Hero.
// User can interact in two ways :
// dismiss the view, or tap "recruit" button.
// This button displays an alert.
// A user confirmation trigger an onRecruit closure.
struct HeroDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    let hero: Hero
    var onRecruit: (Bool) -> Void
    var onDismiss: () -> Void
    @State private var alertIsPresented = false
    @State private var recruited: Bool

    init(hero: Hero, recruited: Bool = false,
         onRecruit: @escaping (Bool) -> Void = { _ in },
         onDismiss: @escaping () -> Void = {}
    ) {
        _recruited = State(initialValue: recruited)
        self.hero = hero
        self.onRecruit = onRecruit
        self.onDismiss = onDismiss
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ImageLoader(imageUrl: hero.imageURL,
                            mask: Rectangle()) {
                    Rectangle()
                        .frame(height: UIScreen.main.bounds.height / 2, alignment: .bottom)
                        .padding(.bottom, -50)
                }
                .mask(
                    VStack {
                        Rectangle()
                            .frame(height: 420, alignment: .bottom)
                        Spacer()
                    }
                )
                .clipped()

                VStack(alignment: .leading, spacing: 15) {
                    Text(hero.name)
                        .font(Font.Details.title)
                    Button {
                        alertIsPresented.toggle()
                    } label: {
                        Text(!recruited ? "💪 Recruit to Squad" : "🔥 Fire from Squad")
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .background(!recruited ? Color.button : Color.background)
                            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(lineWidth: 5)
                                .fill(Color.button)
                            )
                            .cornerRadius(6)
                            .shadow(color: Color.button.opacity(0.6), radius: 10, x: 0, y: 4)
                            .font(Font.Details.button)
                    }
                    Text(hero.description)
                        .font(Font.Details.text)
                    //Spacer()
                }
                .padding(.horizontal, 13)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    onDismiss()
                } label: {
                    Image.back
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: [.top])
        .foregroundColor(Color.font)
        .background(Color.background.ignoresSafeArea())
        .alert(isPresented: $alertIsPresented) {
            Alert(
                title: Text("\(recruited ? "Fire" : "Recruit")"),
                message: Text("Do you really want to \(recruited ? "fire" : "recruit") this hero ?"),
                primaryButton: .destructive(Text("Ok"), action: {
                    recruited.toggle()
                    onRecruit(recruited)
                }),
                secondaryButton: .cancel(Text("Cancel"), action: {
                })
            )
        }
    }
}

struct HeroDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HeroDetailsView(hero: Hero.HERO1, recruited: true)
            }
            HeroDetailsView(hero: Hero.HERO2, recruited: false).previewDevice("iPhone SE (1st generation)")
            HeroDetailsView(hero: Hero.HERO1, recruited: true).previewDevice("iPhone SE (2nd generation)")
            HeroDetailsView(hero: Hero.HERO3, recruited: true)
        }
    }
}
