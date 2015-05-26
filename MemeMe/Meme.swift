//
//  Meme.swift
//  MemeMe
//
//  Created by Anita Seagraves on 5/6/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var top: String
    var bottom: String
    var image: UIImage
    var memedImage: UIImage
    
    init(top: String, bottom: String, image: UIImage, memedImage: UIImage) {
        self.top = top
        self.bottom = bottom
        self.image = image
        self.memedImage = memedImage
    }
    
}
