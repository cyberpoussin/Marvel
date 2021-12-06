//
//  ScrollViewWithConfiguration.swift
//  Marvel
//
//  Created by Adrien S on 05/12/2021.
//

import Foundation
import SwiftUI

enum TableViewConfiguration {
    case backgroundColored(Color)
    case rowsColored(Color)
    case colored(background: Color, rows: Color)
}

struct TableViewConfigurator: UIViewControllerRepresentable {
    let refresh: Bool
    var configuration: TableViewConfiguration
    func makeUIViewController(context: UIViewControllerRepresentableContext<TableViewConfigurator>) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TableViewConfigurator>) {
        let tableViews = uiViewController.navigationController?.topViewController?.view.subviews(ofType: UITableView.self) ?? [UITableView]()

        for tableView in tableViews {
            tableView.separatorColor = .clear
            switch configuration {
            case .backgroundColored(let color):
                tableView.backgroundColor = UIColor(color)
            case .rowsColored(let color):
                for cell in tableView.subviews(ofType: UITableViewCell.self) {
                    cell.backgroundColor = UIColor(color)
                    cell.selectedBackgroundView = {
                        let view = UIView()
                        view.backgroundColor = .blue
                        return view
                    }()
                }
            case .colored(let backgroundColor, let rowsColor):
                tableView.backgroundColor = UIColor(backgroundColor)
                for cell in tableView.subviews(ofType: UITableViewCell.self) {
                    cell.backgroundColor = UIColor(rowsColor)
                    cell.selectedBackgroundView = {
                        let view = UIView()
                        view.backgroundColor = UIColor.gray
                        return view
                    }()
                }
            }
        }
    }
}

extension UIView {
    func subviews<T:UIView>(ofType WhatType:T.Type) -> [T] {
        var result = self.subviews.compactMap {$0 as? T}
        for sub in self.subviews {
            result.append(contentsOf: sub.subviews(ofType:WhatType))
        }
        return result
    }
}


struct WithConfiguration: ViewModifier {
    let configuration: TableViewConfiguration
    @State private var refresh = false
    func body(content: Content) -> some View {
        content
            .background(TableViewConfigurator(refresh: refresh, configuration: configuration))
            .onAppear {
                if !refresh {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        refresh.toggle()
                    }
                }
            }
    }
}

extension List {
    @ViewBuilder func listConfiguration(_ config: TableViewConfiguration) -> some View {
        if #available(iOS 15, *) {
            self
        } else {
            modifier(WithConfiguration(configuration: config))
        }
    }
}

