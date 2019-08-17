//
//  DMDView.swift
//  8BitSimulator
//
//  Created by Nathan Blamires on 2/3/19.
//  Copyright © 2019 nathanblamires. All rights reserved.
//

import UIKit

class DMDView: UIView {
    
    private var columnStackView: UIStackView!
    
    private let numberOfRows = 32
    private let numberOfColumns = 16
    private let spacing: CGFloat = 5
    private let insetPadding: CGFloat = 15
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawDMD()
    }
    
    // MARK:- Setup Methods
    
    private func drawDMD() {
        subviews.forEach { $0.removeFromSuperview() }
        let containerView = setupContainerView()
        columnStackView = setupColumnStackView(in: containerView)
        setupRowViews(in: columnStackView)
    }
    
    private func setupContainerView() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insetPadding).isActive = true
        trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: insetPadding).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: insetPadding).isActive = true
        bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: insetPadding).isActive = true
        return containerView
    }
    
    private func setupRowViews(in columnStackView: UIStackView) {
        for _ in 0..<numberOfRows {
            let rowView =  UIStackView()
            rowView.distribution = .fillEqually
            rowView.spacing = spacing
            for _ in 0..<numberOfColumns {
                let ledView = LEDView.create()
                rowView.addArrangedSubview(ledView)
            }
            columnStackView.addArrangedSubview(rowView)
        }
    }
    
    private func setupColumnStackView(in containerView: UIView) -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        containerView.addSubview(stackView)
        layoutColumnStackView(stackView, inContainer: containerView)
        return stackView
    }
    
    private func layoutColumnStackView(_ stackView: UIStackView, inContainer containerView: UIView) {
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let leading = stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0)
        leading.priority = .defaultHigh
        leading.isActive = true
        let trailing = stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0)
        trailing.priority = .defaultHigh
        trailing.isActive = true
        let top = stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        top.priority = .defaultHigh
        top.isActive = true
        let bottom = stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        bottom.priority = .defaultHigh
        bottom.isActive = true
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        let multiplier = CGFloat(numberOfColumns) / CGFloat(numberOfRows)
        stackView.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    // MARK:- Retrieval Methods
    
    func cell(row: Int, column: Int) -> LEDView? {
        guard let rowStackView = columnStackView.arrangedSubviews[row] as? UIStackView else { return nil }
        return rowStackView.arrangedSubviews[column] as? LEDView
    }
}

