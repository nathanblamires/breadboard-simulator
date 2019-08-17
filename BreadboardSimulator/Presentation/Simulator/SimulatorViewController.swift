//
//  ViewController.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 4/1/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimulatorViewController: UIViewController {
    
    @IBOutlet var dmdContainerView: DMDView!
    @IBOutlet var activeControlLinesStackView: UIStackView!
    @IBOutlet var speedSlider: UISlider!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var runStopButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    // Internal Value Labels
    @IBOutlet weak var reg1Label: UILabel!
    @IBOutlet weak var reg2Label: UILabel!
    @IBOutlet weak var reg3Label: UILabel!
    @IBOutlet weak var reg4Label: UILabel!
    @IBOutlet weak var aluLabel: UILabel!
    @IBOutlet weak var decimalOutputLabel: UILabel!
    @IBOutlet weak var romAddressLabel: UILabel!
    @IBOutlet weak var romValueLabel: UILabel!
    @IBOutlet weak var ramAddressLabel: UILabel!
    @IBOutlet weak var ramValueLabel: UILabel!
    @IBOutlet weak var programCounterLabel: UILabel!
    @IBOutlet weak var instructionRegisterLabel: UILabel!
    @IBOutlet weak var stepCounterLabel: UILabel!
    @IBOutlet weak var aluIsZeroLabel: UILabel!
    @IBOutlet weak var overflowLabel: UILabel!
    
    private var viewModel = SimulatorViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK:- Setup Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "8-Bit Computer Simulator"
        setupStateUpdating()
        setupControls()
        setupSpeedSlider()
        updateSpeedLabel(value: Double(self.speedSlider.value))
    }
    
    private func setupStateUpdating() {
        viewModel.computerStateObservable
            .throttle(0.5, latest: true, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] state in
                self.update(state: state)
            })
            .disposed(by: disposeBag)
        viewModel.dmdValuesObservable
            .subscribe(onNext: { [unowned self] values in
                self.updateDMDView(values: values)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupControls() {
        viewModel.nextButtonEnabled
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        viewModel.runStopButtonText
            .subscribe(onNext: { [unowned self] text in
                self.runStopButton.setTitle(text, for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSpeedLabel(value: Double) {
        let hertz = round(1.0 / value)
        self.speedLabel.text = "\(hertz) hertz"
    }
    
    private func setupSpeedSlider() {
        speedSlider.value = Float(viewModel.speed)
        speedSlider.rx.controlEvent([.valueChanged])
            .debounce(0.25, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [unowned self] in
                self.viewModel.updateRunSpeed(Double(self.speedSlider.value))
                self.updateSpeedLabel(value: Double(self.speedSlider.value))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK:- View Updating
    
    private func updateDMDView(values: [UInt8]) {
        var section = 0
        let dmdValues = Array<UInt8>(values[0..<64])
        dmdValues.enumerated().forEach { byteNumber, byte in
            let column = byteNumber - (section * 16)
            for bit in 0..<8 {
                let row = (7 - bit) + (8 * section)
                let isOn = (byte & (1 << bit)) > 0
                self.dmdContainerView.cell(row: row, column: column)?.toggle(on: isOn)
            }
            if column == 15 {
                section += 1
            }
        }
    }
    
    private func update(state: ComputerState) {
        updateInternalValues(with: state)
        updateControlLinesList(with: state)
    }
    
    private func updateInternalValues(with state: ComputerState) {
        reg1Label.text = state.register1.asBinaryText()
        reg2Label.text = state.register2.asBinaryText()
        reg3Label.text = state.register3.asBinaryText()
        reg4Label.text = state.register4.asBinaryText()
        aluLabel.text = state.aluOutput.asBinaryText()
        decimalOutputLabel.text = state.decimalDisplay.asDecimalText()
        romAddressLabel.text = state.romAddress.asBinaryText()
        romValueLabel.text = state.currentROMValue.asBinaryText()
        ramAddressLabel.text = state.ramAddress.asBinaryText()
        ramValueLabel.text = state.currentRAMValue.asBinaryText()
        programCounterLabel.text = state.programCounter.asBinaryText()
        instructionRegisterLabel.text = state.instructionRegister.asBinaryText()
        stepCounterLabel.text = state.stepCounter.asBinaryText()
        aluIsZeroLabel.text = "\(state.isZero)"
        overflowLabel.text = "\(state.isOverflow)"
    }
    
    private func updateControlLinesList(with state: ComputerState) {
        clearOutControlLinesList()
        state.controlLines
            .filter { $0.isOn }
            .forEach {
                let label = UILabel(text: $0.title)
                activeControlLinesStackView.addArrangedSubview(label)
            }
    }
    
    // MARK:- Helper Methods
    
    private func clearOutControlLinesList() {
        activeControlLinesStackView.arrangedSubviews.forEach {
            activeControlLinesStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    // MARK:- Button Actions
    
    @IBAction func runButtonSelected() {
        viewModel.runStopButtonSelected()
    }
    
    @IBAction func nextSelected() {
        viewModel.runNextStep()
    }
}
