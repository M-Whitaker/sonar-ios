//
//  ArrayUtils.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

import Foundation

extension Array {
    func find(at index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }

        return self[index]
    }
}
