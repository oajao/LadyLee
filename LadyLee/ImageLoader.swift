//
//  Image.swift
//  LadyLeae
//
//  Created by Spence on 6/26/19.
//  Copyright © 2019 Olly. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
