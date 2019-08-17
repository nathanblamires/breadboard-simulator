//
//  UseCases.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxSwift

class UseCases {

    let saveAppState: SaveAppStateUseCase
    let appLifecycle: AppLifecycleUseCase

    init(saveAppStateUseCase: SaveAppStateUseCase) {
        self.saveAppState = saveAppStateUseCase
        self.appLifecycle = AppLifecycleUseCase()
    }

    // run code that requires the Store to be fully initialised
    func setup(store: Store) {
        saveAppState.startSaving(store.observable(of: \.self))
    }
}
