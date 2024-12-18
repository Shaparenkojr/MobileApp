//
//  SaleView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 18.10.2024.
//

import Foundation
import UIKit

class SaleView: UIView {
    
    private lazy var saleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-5%"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel(text: Int) {
        saleLabel.text = "-\(text)%"
    }
    
}

private extension SaleView {
    
    func setupView() {
        addSubview(saleLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            saleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            saleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            saleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -6),
            saleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}
