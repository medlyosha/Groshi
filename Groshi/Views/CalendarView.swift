//
//  CalendarView.swift
//  Groshi
//
//  Created by Lesha Mednikov on 05.05.2023.
//

import UIKit
import SnapKit
class CalendarView: UIView {
    let calendar: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        datePicker.tintColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        datePicker.contentMode = .center
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date().startOfYear()
        datePicker.maximumDate = Date.now
        return datePicker
    }()
    let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    func setupConstraints() {
        calendar.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
        okButton.snp.makeConstraints { maker in
            maker.width.equalToSuperview().dividedBy(5)
            maker.height.equalToSuperview().dividedBy(10)
            maker.centerX.equalToSuperview()
            maker.top.equalTo(calendar.snp.bottom).offset(50)
        }
    }
    func addOkButtonTarget(_ target: Any?, action: Selector) {
        okButton.addTarget(target, action: action, for: .touchUpInside)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        self.addSubview(calendar)
        self.addSubview(okButton)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
