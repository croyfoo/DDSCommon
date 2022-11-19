//
//  DispatchQueue.swift
//  Tes
//
//  Created by David Croy on 5/30/22.
//  Copyright © 2022 DoubleDog Software. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    public static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (()->Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
