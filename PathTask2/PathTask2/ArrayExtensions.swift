//
//  ArrayExtensions.swift
//  PathTask2
//
//  Created by Алексей Перов on 8/29/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObjFromArray(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
}

extension Array {
    
    func get(_ index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
    
    func checkIndex(_ num: Int) -> Bool {
        if let _ = get(num) {
            return true
        } else {
            return false
        }
    }
    
}
