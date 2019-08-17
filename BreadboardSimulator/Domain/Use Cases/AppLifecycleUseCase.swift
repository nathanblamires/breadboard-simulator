//
//  AppLifecycleChangedUseCase.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 15/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

class AppLifecycleUseCase {
    
    private var disposeBag = DisposeBag()

    init(dependencies: Dependencies = .standard) {
        dependencies.didFinishLaunching
            .subscribe(onNext: { [unowned self] _ in self.didFinishLaunching() })
            .disposed(by: disposeBag)
        dependencies.willEnterForeground
            .subscribe(onNext: { [unowned self] _ in self.willEnterForeground() })
            .disposed(by: disposeBag)
        dependencies.didBecomeActive
            .subscribe(onNext: { [unowned self] _ in self.didBecomeActive() })
            .disposed(by: disposeBag)
        dependencies.willResignActive
            .subscribe(onNext: { [unowned self] _ in self.willResignActive() })
            .disposed(by: disposeBag)
        dependencies.didEnterBackground
            .subscribe(onNext: { [unowned self] _ in self.didEnterBackground() })
            .disposed(by: disposeBag)
        dependencies.willTerminate
            .subscribe(onNext: { [unowned self] _ in self.willTerminate() })
            .disposed(by: disposeBag)
    }
    
    func didFinishLaunching() {
        Logger.info(topic: .domain, message: "didFinishLaunching")
    }
    
    func willEnterForeground() {
        Logger.info(topic: .domain, message: "willEnterForeground")
    }
    
    func didBecomeActive() {
        Logger.info(topic: .domain, message: "didBecomeActive")
    }
    
    func willResignActive() {
        Logger.info(topic: .domain, message: "willResignActive")
    }
    
    func didEnterBackground() {
        Logger.info(topic: .domain, message: "didEnterBackground")
    }
    
    func willTerminate() {
        Logger.info(topic: .domain, message: "willTerminate")
    }
}

// MARK:- Notifications Dependencies

extension AppLifecycleUseCase {
    
    struct Dependencies {
        let didFinishLaunching: Observable<Void>
        let willEnterForeground: Observable<Void>
        let didBecomeActive: Observable<Void>
        let willResignActive: Observable<Void>
        let didEnterBackground: Observable<Void>
        let willTerminate: Observable<Void>
        static var standard: Dependencies {
            Dependencies(
                didFinishLaunching: NotificationCenter.default.rx.notification(UIApplication.didFinishLaunchingNotification).map { _ in () },
                willEnterForeground: NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).map { _ in () },
                didBecomeActive: NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification).map { _ in () },
                willResignActive: NotificationCenter.default.rx.notification(UIApplication.willResignActiveNotification).map { _ in () },
                didEnterBackground: NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).map { _ in () },
                willTerminate: NotificationCenter.default.rx.notification(UIApplication.willTerminateNotification).map { _ in () }
            )
        }
    }

}
