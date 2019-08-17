//
//  Store.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class Store {

    static let instance: Store = {
        let saveAppStateUseCase = SaveAppStateUseCase(userDefaults: UserDefaults.standard)
        let appState = saveAppStateUseCase.savedAppState() ?? AppState()
        let useCases = UseCases(saveAppStateUseCase: saveAppStateUseCase)
        return Store(appState: appState, useCases: useCases)
    }()

    private let appStateSubject: BehaviorRelay<AppState>

    var appState: AppState {
        didSet {
            appStateSubject.accept(appState)
        }
    }
    
    let useCases: UseCases

    init(appState: AppState, useCases: UseCases) {
        appStateSubject = BehaviorRelay<AppState>(value: appState)
        self.appState = appState
        self.useCases = useCases
        useCases.setup(store: self)
    }
}

// MARK: - Helper Functions

extension Store {

    func observable<T: Equatable>(of path: KeyPath<AppState, T>) -> Observable<T> {
        return appStateSubject
            .map { $0[keyPath: path] }
            .distinctUntilChanged()
    }
}
