//
//  StringExtension.swift
//  CountOnMe
//
//  Created by Thomas on 24/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension String {
    func isConvertibleToInt() -> Bool {
        return Int(self) != nil
    }
    
    func formatIfNeeded() -> String {
        var result = self
        
        if result.last == "0" {
            result.removeLast()

            if result.last == "." {
                result.removeLast()
            }
        }
        return result
    }
}
