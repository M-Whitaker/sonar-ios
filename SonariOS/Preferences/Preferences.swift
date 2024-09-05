//
//  Preferences.swift
//  SonariOS
//
//  Created by Matt Whitaker on 23/08/2024.
//

import Combine
import Foundation
import SwiftUI

private let WRAPPED_VALUE_FATAL_ERROR = "Wrapped value should not be used."

/**
 https://www.avanderlee.com/swift/appstorage-explained
 */
final class Preferences {
    static let standard = Preferences(userDefaults: .standard)

    fileprivate let userDefaults: UserDefaults

    /// Sends through the changed key path whenever a change occurs.
    var preferencesChangedSubject = PassthroughSubject<AnyKeyPath, Never>()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    @CustomUserDefault("profiles")
    var profiles: [SonarUserDefaultsWrapper] = []

    @UserDefault("current_profile_idx")
    var currentProfileIdx: Int = 0
}

final class PublisherObservableObject: ObservableObject {
    var subscriber: AnyCancellable?

    init(publisher: AnyPublisher<Void, Never>) {
        subscriber = publisher.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        })
    }
}

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get { fatalError(WRAPPED_VALUE_FATAL_ERROR) }
        set { fatalError(WRAPPED_VALUE_FATAL_ERROR) }
    }

    init(wrappedValue: Value, _ key: String) {
        defaultValue = wrappedValue
        self.key = key
    }

    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let instanceKey = instance[keyPath: storageKeyPath].key
            let instanceDefaultValue = instance[keyPath: storageKeyPath].defaultValue
            return container.object(forKey: instanceKey) as? Value ?? instanceDefaultValue
        }
        set {
            let container = instance.userDefaults
            let instanceKey = instance[keyPath: storageKeyPath].key
            container.set(newValue, forKey: instanceKey)
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

@propertyWrapper
struct CustomUserDefault<Value: Codable> {
    let key: String
    let defaultValue: Value

    var wrappedValue: Value {
        get { fatalError(WRAPPED_VALUE_FATAL_ERROR) }
        set { fatalError(WRAPPED_VALUE_FATAL_ERROR) }
    }

    init(wrappedValue: Value, _ key: String) {
        defaultValue = wrappedValue
        self.key = key
    }

    public static subscript(
        _enclosingInstance instance: Preferences,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<Preferences, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<Preferences, Self>
    ) -> Value {
        get {
            let container = instance.userDefaults
            let instanceKey = instance[keyPath: storageKeyPath].key
            let instanceDefaultValue = instance[keyPath: storageKeyPath].defaultValue
            if let data = container.object(forKey: instanceKey) as? Data,
               let userDefault = try? JSONDecoder().decode(Value.self, from: data)
            {
                return userDefault
            }
            return instanceDefaultValue
        }
        set {
            let container = instance.userDefaults
            let instanceKey = instance[keyPath: storageKeyPath].key
            if let encoded = try? JSONEncoder().encode(newValue) {
                container.set(encoded, forKey: instanceKey)
            }
            instance.preferencesChangedSubject.send(wrappedKeyPath)
        }
    }
}

@propertyWrapper
struct Preference<Value>: DynamicProperty {
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<Preferences, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<Preferences, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get { preferences[keyPath: keyPath] }
        nonmutating set { preferences[keyPath: keyPath] = newValue }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

@propertyWrapper
struct UserScopedPreference<Value>: DynamicProperty {
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<SonarUserDefaults, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<SonarUserDefaults, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get {
            assert(!preferences.profiles.isEmpty)
            return preferences.profiles[preferences.currentProfileIdx].userDefaults[keyPath: keyPath]
        }
        nonmutating set {
            assert(!preferences.profiles.isEmpty)
            preferences.profiles[preferences.currentProfileIdx].userDefaults[keyPath: keyPath] = newValue
        }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}

@propertyWrapper
struct SonarQubeUserScopedPreference<Value>: DynamicProperty {
    @ObservedObject private var preferencesObserver: PublisherObservableObject
    private let keyPath: ReferenceWritableKeyPath<SonarQubeUserDefaults, Value>
    private let preferences: Preferences

    init(_ keyPath: ReferenceWritableKeyPath<SonarQubeUserDefaults, Value>, preferences: Preferences = .standard) {
        self.keyPath = keyPath
        self.preferences = preferences
        let publisher = preferences
            .preferencesChangedSubject
            .filter { changedKeyPath in
                changedKeyPath == keyPath
            }.map { _ in () }
            .eraseToAnyPublisher()
        preferencesObserver = .init(publisher: publisher)
    }

    var wrappedValue: Value {
        get {
            assert(!preferences.profiles.isEmpty)
            guard let currProfile = preferences.profiles[preferences.currentProfileIdx].userDefaults as? SonarQubeUserDefaults else {
                preconditionFailure("Should be used on type of SonarQubeUserDefaults")
            }
            return currProfile[keyPath: keyPath]
        }
        nonmutating set {
            assert(!preferences.profiles.isEmpty)
            guard let currProfile = preferences.profiles[preferences.currentProfileIdx].userDefaults as? SonarQubeUserDefaults else {
                preconditionFailure("Should be used on type of SonarQubeUserDefaults")
            }
            currProfile[keyPath: keyPath] = newValue
        }
    }

    var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }
}
