
//
//  NavigationBarWithConfiguration.swift
//  Marvel
//
//  Created by Adrien S on 08/10/2021.
//

import SwiftUI


enum NavigationBarConfiguration {
    case transparent
    case colored(Color)
    var backgroundColor: UIColor {
        switch self {
        case .transparent: return .clear
        case let .colored(color): return UIColor(color)
        }
    }

    var scrollBGColor: UIColor {
        switch self {
        case .transparent: return .clear
        case let .colored(color):
            _ = color
            let scrollColor = UIColor(color.opacity(1))
//            if let components = scrollColor.rgba {
//                scrollColor = UIColor(red: components.red - 0.1, green: components.green - 0.1, blue: components.blue - 0.1, alpha: 0.3)
//            }
            return scrollColor
        }
    }

    var blurEffect: UIBlurEffect? {
        switch self {
        case .transparent: return nil
        case .colored: return nil
            // return UIBlurEffect(style: .regular)
        }
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    let configuration: NavigationBarConfiguration?
    let refresh: Bool
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) -> UIViewController {
        let uiViewController = UIViewController()
        return uiViewController
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: UIViewControllerRepresentableContext<NavigationConfigurator>
    ) {
        guard let nav = uiViewController.navigationController, let bar = uiViewController.navigationController?.navigationBar else { return }
        initialize(bar: bar)
    }
    
    func initialize(bar: UINavigationBar) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = configuration?.backgroundColor ?? .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        bar.compactAppearance = coloredAppearance
        bar.scrollEdgeAppearance = coloredAppearance
        bar.tintColor = .clear
        let scrolledApperance = coloredAppearance.copy()
        let scrollColor = configuration?.scrollBGColor ?? .clear
        scrolledApperance.backgroundColor = scrollColor
        scrolledApperance.backgroundEffect = configuration?.blurEffect
        bar.setBackgroundImage(UIImage(), for: .default)
        bar.standardAppearance = scrolledApperance
    }
}



struct NavigationBarWithConfiguration: ViewModifier {
    let configuration: NavigationBarConfiguration
    @State private var refresh = false
    func body(content: Content) -> some View {
        content
            .background(NavigationConfigurator(configuration: configuration, refresh: refresh))
            .onAppear {
                if !refresh {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        refresh.toggle()
                    }
                }
            }
    }
}

extension View {
    func withNavBarConfiguration(_ config: NavigationBarConfiguration) -> some View {
        modifier(NavigationBarWithConfiguration(configuration: config))
    }
}

struct NavigationViewWithConfiguration<Content: View>: View {
    var configuration: NavigationBarConfiguration?
    var content: () -> Content

    @State private var refresh: Bool = false

    var body: some View {
        NavigationView {
            content()
                .background(NavigationConfigurator(configuration: configuration, refresh: refresh))
                .onAppear {
                    if !refresh {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            refresh.toggle()
                        }
                    }
                }
        }
    }
}

extension NavigationViewWithConfiguration {
    init(_ configuration: NavigationBarConfiguration, configure: @escaping (UINavigationController) -> Void = { _ in }, content: @escaping () -> Content) {
        self.configuration = configuration
        self.content = content
    }
}


