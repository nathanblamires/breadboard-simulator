//
//  SimulatorViewModel.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 9/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SimulatorViewModel: ViewModel {
    
    var simulator: Simulator
    var computerStateObservable: Observable<Computer>
    var dmdValuesObservable: Observable<[UInt8]>
    
    var nextButtonEnabled: Observable<Bool>
    var runStopButtonText: Observable<String>
    var isRunningObservable: BehaviorRelay<Bool>
    private var programIsFinished: Bool = false
    
    private var timerDisposeBag = DisposeBag()
    private var runProgramTimer: Timer?
    private(set) var speedInHertz: Int = 10
    
    // clock speed tracking
    private var firstClockTickOfSecond: Date = Date()
    private var clockTicksThisSecond: Int = 0
    
    private var generalDisposeBag = DisposeBag()
    
    // MARK:- Setup Methods
    
    override init(store: Store = Store.instance) {
        simulator = store.simulator!
        computerStateObservable = Store.instance.observable(of: \.computerState)
        dmdValuesObservable = Store.instance.observable(of: \.computerState.ioValues)
        nextButtonEnabled = Store.instance.observable(of: \AppState.computerState.finished).map { !$0 }
        isRunningObservable = BehaviorRelay<Bool>(value: false)
        runStopButtonText = isRunningObservable.map { $0 ? "Stop" : "Run" }
        super.init(store: store)
        setupIsFinishedPropertyUpdating()
        loadProgram()
    }
    
    private func loadProgram() {
        guard let instructions = store.appState.currentProgram?.instructions else {
            Logger.error(topic: .presentation, message: "currentProgram is nil")
            return
        }
        simulator.load(instructions: instructions)
    }
    
    private func setupIsFinishedPropertyUpdating() {
        computerStateObservable
            .subscribe(onNext: { [unowned self] state in
                self.programIsFinished = state.finished
            })
            .disposed(by: generalDisposeBag)
    }
    
    // MARK:- Public Methods
    
    func runStopButtonSelected() {
        if isRunningObservable.value {
            stopProgram()
        } else {
            runProgram()
        }
    }
    
    func runNextStep() {
        trackRunningClockSpeed(clockTick: Date())
        if programIsFinished {
            loadProgram()
        }
        simulator.clockTick()
    }
    
    func updateRunSpeed(_ speed: Int) {
        self.speedInHertz = speed
        timerDisposeBag = DisposeBag()
        if isRunningObservable.value {
            runProgram()
        }
    }
    
    // MARK:- Execution Methods

    private func runProgram() {
        if programIsFinished {
            loadProgram()
        }
        isRunningObservable.accept(true)
        Observable<Int>.interval(1.0 / Double(speedInHertz), scheduler: MainScheduler.instance)
            .withLatestFrom(computerStateObservable)
            .subscribe(onNext: { state in
                if state.finished {
                    self.stopProgram()
                } else {
                    self.runNextStep()
                }
            }).disposed(by: timerDisposeBag)
    }
    
    private func stopProgram() {
        timerDisposeBag = DisposeBag()
        isRunningObservable.accept(false)
    }
    
    // MARK:- Helper Methods
    
    private func trackRunningClockSpeed(clockTick: Date) {
        let newSecond = clockTick.timeIntervalSince1970 - firstClockTickOfSecond.timeIntervalSince1970 > 1
        if newSecond {
            print("Hertz: \(clockTicksThisSecond)")
            firstClockTickOfSecond = clockTick
            clockTicksThisSecond = 0
        } else {
            clockTicksThisSecond += 1
        }
    }
}
