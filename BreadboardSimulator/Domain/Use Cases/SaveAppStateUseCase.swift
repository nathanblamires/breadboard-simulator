//
//  SaveAppStateUseCase.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxSwift

class SaveAppStateUseCase {

    private let appStateStorageKey = "AppState"

    private let userDefaults: UserDefaults
    private var disposeBag = DisposeBag()

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func startSaving(_ appStateObservable: Observable<AppState>, debounceTime: TimeInterval = 1) {
        appStateObservable
            .debounce(debounceTime, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] appState in
                self?.save(appState: appState)
            }).disposed(by: disposeBag)
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .withLatestFrom(appStateObservable)
            .subscribe(onNext: { [weak self] appState in
                self?.save(appState: appState)
            }).disposed(by: disposeBag)
    }
    
    /// Returns the last saved instance of the AppState
    func savedAppState() -> AppState? {
        guard let data = userDefaults.data(forKey: appStateStorageKey) else {
            return nil
        }
        do {
            return try JSONDecoder().decode(AppState.self, from: data)
        } catch {
            Logger.log(level: .warning, topic: .domain, message: "Error retrieving saved AppState, \(error)")
            return nil
        }
    }
    
    private func save(appState: AppState) {
        Logger.log(level: .info, topic: .domain, message: "Saving AppState")
        do {
            let data = try JSONEncoder().encode(appState)
            userDefaults.set(data, forKey: appStateStorageKey)
        } catch {
            Logger.log(level: .warning, topic: .domain, message: "Error encoding the AppState")
        }
    }
}
