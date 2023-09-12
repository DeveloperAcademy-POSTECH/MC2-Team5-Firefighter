//
//  ImageCacheManager.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/09/07.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
}
