//
//  Font+extension.swift
//  Marvel
//
//  Created by Adrien S on 06/12/2021.
//

import SwiftUI

extension Font {
    struct List {
        static var squadTitle: Font {
            Font.system(size: 20, weight: .bold, design: .rounded)
        }
        
        static var squad: Font {
            Font.system(size: 16, weight: .regular, design: .rounded)
        }
        
        static var cell: Font {
            Font.system(size: 18, weight: .semibold, design: .rounded)
        }
    }
    
    struct Details {
        static var title: Font {
            Font.system(size: 35, weight: .bold, design: .rounded)
        }
        
        static var text: Font {
            Font.system(size: 20, weight: .regular, design: .rounded)
        }
        
        static var button: Font {
            Font.system(size: 20, weight: .semibold, design: .rounded)
        }
    }
}
