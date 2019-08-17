//
//  SaveAppStateUseCaseSpec.swift
//  BreadboardSimulatorTests
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Quick
import Nimble

@testable import BreadboardSimulator

class SaveAppStateUseCaseSpec: QuickSpec {
    
    override func spec() {
        
        var newAppState: AppState!
        var userDefaults: UserDefaults!
        var saveAppStateUseCase: SaveAppStateUseCase!
        var appStateSubject: BehaviorRelay<AppState>!
        
        describe("Given the app has setup AppState saving") {
            
            beforeEach {
                userDefaults = UserDefaults(suiteName: "test")
                appStateSubject = BehaviorRelay<AppState>(value: AppState())
                saveAppStateUseCase = SaveAppStateUseCase(userDefaults: userDefaults)
                saveAppStateUseCase.startSaving(appStateSubject.asObservable(), debounceTime: 0.05)
            }

            context("when a new AppState is published") {
                
                beforeEach {
                    newAppState = AppState()
                    newAppState.testValue = 123
                    appStateSubject.accept(newAppState)
                }
                
                it("then it will be saved after the debounce time") {
                    waitUntil(timeout: 1) { done in
                        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.06) {
                            let savedState = saveAppStateUseCase.savedAppState()
                            expect(savedState) == newAppState
                            done()
                        }
                    }
                }
            }
            
            afterEach {
                userDefaults.removePersistentDomain(forName: "test")
            }
        }
    }
}

