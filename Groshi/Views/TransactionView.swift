//
//  TransactionView.swift
//  Groshi
//
//  Created by Lesha Mednikov on 03.05.2023.
//

import UIKit
import SnapKit
final class TransactionView: UIView {
    let buttonTitles = ["0", ",", "⌫", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let stackViewButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    let firstStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    let secondStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    let thirdStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    let fourthStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    let transactionLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 50)
        label.adjustsFontSizeToFitWidth = true
        label.text = ""
        label.textAlignment = .right
        return label
    }()
    let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    let calendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗓", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 30)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        tableView.isHidden = true
        return tableView
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 15)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        label.text = dateFormatter.string(from: currentDate)
        return label
    }()
    let addCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    let addCategoryTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "Avenir Next Regular", size: 17)
        textField.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return textField
    }()
    let addNewCategoryView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        view.isHidden = true
        return view
    }()
    func setupConstraints() {
        stackViewButtons.addArrangedSubview(firstStackView)
        stackViewButtons.addArrangedSubview(secondStackView)
        stackViewButtons.addArrangedSubview(thirdStackView)
        stackViewButtons.addArrangedSubview(fourthStackView)
        stackViewButtons.snp.makeConstraints {maker in
            maker.height.equalToSuperview().dividedBy(2)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(30)
        }
        transactionLabel.snp.makeConstraints {maker in
            maker.width.equalTo(stackViewButtons)
            maker.height.equalTo(transactionLabel.snp.width).dividedBy(5)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(addTransactionButton.snp.top).offset(-20)
        }
        addTransactionButton.snp.makeConstraints {maker in
            maker.width.equalTo(stackViewButtons).dividedBy(2)
            maker.height.equalTo(transactionLabel.snp.height)
            maker.right.equalTo(stackViewButtons.snp.right)
            maker.bottom.equalTo(stackViewButtons.snp.top).offset(-20)
        }
        calendarButton.snp.makeConstraints {maker in
            maker.width.equalTo(stackViewButtons).dividedBy(2)
            maker.height.equalTo(addTransactionButton)
            maker.left.equalTo(stackViewButtons.snp.left)
            maker.bottom.equalTo(stackViewButtons.snp.top).offset(-20)
        }
        dateLabel.snp.makeConstraints { maker in
            maker.width.equalTo(transactionLabel.snp.width).dividedBy(2)
            maker.bottom.equalTo(transactionLabel.snp.top).offset(-20)
            maker.right.equalTo(transactionLabel)
        }
        categoryTableView.snp.makeConstraints { maker in
            maker.width.equalTo(stackViewButtons)
//            maker.height.equalTo(stackViewButtons)
            maker.top.equalTo(calendarButton.snp.top)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(30)
        }
        addNewCategoryView.snp.makeConstraints { maker in
            maker.width.equalTo(stackViewButtons)
            maker.top.equalTo(calendarButton)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(30)
            addNewCategoryView.addSubview(addCategoryButton)
            addNewCategoryView.addSubview(addCategoryTextField)
        }
        addCategoryButton.snp.makeConstraints { maker in
            maker.width.equalTo(addTransactionButton).dividedBy(2)
            maker.height.equalTo(addTransactionButton)
            maker.right.equalTo(addNewCategoryView)
            maker.top.equalTo(addNewCategoryView)
        }
        addCategoryTextField.snp.makeConstraints { maker in
//            maker.width.equalTo(addNewCategoryView).dividedBy(1.5)
            maker.right.equalTo(addCategoryButton.snp.left)
            maker.height.equalTo(addTransactionButton)
            maker.left.equalTo(addNewCategoryView)
            maker.top.equalTo(addNewCategoryView)
        }
    }
    func makeButtons() {
        for (index, title) in buttonTitles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 30)
            button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
            button.titleLabel?.textAlignment = .center
            button.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
            if index < 3 {
                fourthStackView.addArrangedSubview(button)
            } else if index < 6 {
                thirdStackView.addArrangedSubview(button)
            } else if index < 9 {
                secondStackView.addArrangedSubview(button)
            } else {
                firstStackView.addArrangedSubview(button)
            }
        }
    }
    func addEraseButtonTarget(_ target: Any?, action: Selector) {
        for arrangedSubview in firstStackView.arrangedSubviews + secondStackView.arrangedSubviews + thirdStackView.arrangedSubviews + fourthStackView.arrangedSubviews {
            guard let button = arrangedSubview as? UIButton else { continue }
            if button.titleLabel?.text == "⌫" {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
    func addDecimalButtonTarget(_ target: Any?, action: Selector) {
        for arrangedSubview in firstStackView.arrangedSubviews + secondStackView.arrangedSubviews + thirdStackView.arrangedSubviews + fourthStackView.arrangedSubviews {
            guard let button = arrangedSubview as? UIButton else { continue }
            if button.titleLabel?.text == "," {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
    func addNumberButtonTarget(_ target: Any?, action: Selector) {
        for arrangedSubview in firstStackView.arrangedSubviews + secondStackView.arrangedSubviews + thirdStackView.arrangedSubviews + fourthStackView.arrangedSubviews {
            guard let button = arrangedSubview as? UIButton else { continue }
            if button.titleLabel?.text != "⌫" && button.titleLabel?.text != "," {
                button.addTarget(target, action: action, for: .touchUpInside)
            }
        }
    }
    func addTransactionButtonTarget(_ target: Any?, action: Selector) {
        addTransactionButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addCalendarButtonTarget(_ target: Any?, action: Selector) {
        calendarButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addNewCategoryButtonTarget(_ target: Any?, action: Selector) {
        addCategoryButton.addTarget(target, action: action, for: .touchUpInside)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        for arrangedSubview in firstStackView.arrangedSubviews + secondStackView.arrangedSubviews + thirdStackView.arrangedSubviews + fourthStackView.arrangedSubviews {
            guard let button = arrangedSubview as? UIButton else { continue }
            button.snp.makeConstraints { maker in
                maker.height.equalTo(button.snp.width)
            }
            button.layoutIfNeeded()
            button.layer.cornerRadius = button.frame.height / 2
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.addSubview(stackViewButtons)
        self.addSubview(transactionLabel)
        self.addSubview(addTransactionButton)
        self.addSubview(calendarButton)
        self.addSubview(dateLabel)
        self.addSubview(categoryTableView)
        self.addSubview(addNewCategoryView)
        makeButtons()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
