//
//  Service.swift
//  Marvel
//
//  Created by Admin on 03/12/2021.
//

import CryptoKit
import Foundation
import UIKit

extension String {
    func MD5() -> String {
        let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
