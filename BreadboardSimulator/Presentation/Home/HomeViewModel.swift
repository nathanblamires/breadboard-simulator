//
//  HomeViewModel.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModel {

    let versionText: Observable<String>

    override init(store: Store = Store.instance) {
        versionText = store
            .observable(of: \.self)
            .map {  "The number is \($0.testValue)" }
        super.init(store: store)
    }

    func buttonSelected() {
        store.appState.testValue = Int.random(in: 0...100)
    }
}
