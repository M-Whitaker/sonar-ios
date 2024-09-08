//
//  ViewUtils.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/09/2024.
//

enum ViewLoadingState<T: Equatable>: Equatable {
    case isLoading
    case loaded(T)
    case failed(Error)

    static func == (lhs: ViewLoadingState<T>, rhs: ViewLoadingState<T>) -> Bool {
        switch (lhs, rhs) {
        case let (.loaded(lhsObj), .loaded(rhsObj)):
            lhsObj == rhsObj
        case let (.failed(lhsErr), .failed(rhsErr)):
            lhsErr.localizedDescription == rhsErr.localizedDescription
        case (.isLoading, .isLoading):
            true
        default:
            false
        }
    }
}
