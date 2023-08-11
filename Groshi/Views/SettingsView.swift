//
//  SettingsView.swift
//  Groshi
//
//  Created by Lesha Mednikov on 06.06.2023.
//

import UIKit
import SnapKit
class SettingsView: UIView {
    let deleteDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete all transactions", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return button
    }()
    let contactDevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Contact developer", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return button
    }()
    func setupConstraints() {
        deleteDataButton.snp.makeConstraints { maker in
            maker.top.equalTo(super.safeAreaLayoutGuide.snp.top).inset(100)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
        }
        contactDevButton.snp.makeConstraints { maker in
            maker.top.equalTo(deleteDataButton.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.addSubview(deleteDataButton)
        self.addSubview(contactDevButton)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addDeleteDataButtonTarget(_ target: Any?, action: Selector) {
        deleteDataButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addContactDevButtonTarget(_ target: Any?, action: Selector) {
        contactDevButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
