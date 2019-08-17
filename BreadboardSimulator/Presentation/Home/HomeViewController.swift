//
//  HomeViewController.swift
//  BreadboardSimulator
//
//  Created by Nathan Blamires on 10/8/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeViewController: UIViewController {

    private let viewModel = HomeViewModel()
    private var disposeBag = DisposeBag()
    
    @IBOutlet var label: UILabel!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.versionText
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.viewModel.buttonSelected()
            })
            .disposed(by: disposeBag)
    }
}
