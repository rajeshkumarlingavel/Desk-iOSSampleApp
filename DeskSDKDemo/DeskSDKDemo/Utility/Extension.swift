//
//  Extension.swift
//  DeskSDKDemo
//
//  Created by Rajeshkumar Lingavel on 26/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import Foundation

extension UIImageView {
    func showImage(_ imageURLString: String) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self.image = data != nil ? UIImage(data: data!) : UIImage(named: "default.png")
            }
        }
    }
}

