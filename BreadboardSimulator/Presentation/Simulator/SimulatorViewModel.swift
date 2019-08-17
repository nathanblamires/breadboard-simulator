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

class SimulatorViewModel {
    
    var simulator = Simulator.shared
    var computerStateObservable: Observable<ComputerState>
    var dmdValuesObservable: Observable<[UInt8]>
    
    var nextButtonEnabled: Observable<Bool>
    var runStopButtonText: Observable<String>
    var isRunningObservable: BehaviorRelay<Bool>
    private var programIsFinished: Bool = false
    
    private var timerDisposeBag = DisposeBag()
    private var runProgramTimer: Timer?
    private(set) var speed: Double = 1.0 / 10_000 
    
    // clock speed tracking
    private var firstClockTickOfSecond: Date = Date()
    private var clockTicksThisSecond: Int = 0
    
    private var generalDisposeBag = DisposeBag()
    
    // MARK:- Setup Methods
    
    init() {
        computerStateObservable = Store.instance.observable(of: \.computerState)
        dmdValuesObservable = Store.instance.observable(of: \.computerState.ioValues)
        nextButtonEnabled = Store.instance.observable(of: \AppState.computerState.finished).map { !$0 }
        isRunningObservable = BehaviorRelay<Bool>(value: false)
        runStopButtonText = isRunningObservable.map { $0 ? "Stop" : "Run" }
        setupIsFinishedPropertyUpdating()
        loadProgram()
    }
    
    private func loadProgram() {
        let instructions = Program.shared.generate()
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
    
    func updateRunSpeed(_ speed: Double) {
        self.speed = speed
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
        Observable<Int>.interval(speed, scheduler: MainScheduler.instance)
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
            firstClockTickOfSecond = clockTick
            clockTicksThisSecond = 1
            print("Hertz: \(clockTicksThisSecond)")
        } else {
            clockTicksThisSecond += 1
        }
    }
}
