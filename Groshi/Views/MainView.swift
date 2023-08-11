//
//  MainView.swift
//  Groshi
//
//  Created by Lesha Mednikov on 01.05.2023.
//

import UIKit
import SnapKit
import Charts
final class MainView: UIView {
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Bold", size: 20)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        return button
    }()
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        return button
    }()
    let transactionsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        tableView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()
    let expenseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("expense", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return button
    }()
    let incomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("income", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return button
    }()
    let periodLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 17)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()
    let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 17)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    let chooseTransactionView: UIView = {
        let transactionView = UIView()
        transactionView.layer.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        transactionView.layer.cornerRadius = 10
        transactionView.isHidden = true
        return transactionView
    }()
    var periodSegmentControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [TimePeriod.today.rawValue, TimePeriod.week.rawValue, TimePeriod.month.rawValue, TimePeriod.year.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        segmentedControl.tintColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        let font = UIFont(name: "Avenir Next Regular", size: 17)
        let attributes = [NSAttributedString.Key.font: font]
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)], for: .selected)
        return segmentedControl
    }()
    let scrollChartView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.delaysContentTouches = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        return scrollView
    }()
    let noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.text = "Add your expense"
        label.font =  UIFont(name: "Avenir Next Regular", size: 30)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    lazy var horizontalBarChartView: HorizontalBarChartView = {
        let chartView = HorizontalBarChartView()
        chartView.legend.enabled = false
        chartView.xAxis.granularity = 1
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.labelPosition = .bottomInside
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelFont = UIFont(name: "Avenir Next Regular", size: 14)!
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelTextColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        chartView.xAxis.axisLineColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        chartView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        chartView.rightAxis.enabled = false
        let yAxis = chartView.leftAxis
        yAxis.granularityEnabled = true
        yAxis.granularity = 1
        yAxis.axisMinimum = 0
        yAxis.spaceTop = 0.8
        yAxis.drawLabelsEnabled = false
        yAxis.labelFont = UIFont(name: "Avenir Next Regular", size: 11)!
        yAxis.drawGridLinesEnabled = false
        yAxis.drawAxisLineEnabled = false
        yAxis.labelTextColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        yAxis.axisLineColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        chartView.isUserInteractionEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.animate(yAxisDuration: 1.5)
        return chartView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        self.addSubview(plusButton)
        self.addSubview(chooseTransactionView)
        self.addSubview(transactionsTableView)
        self.addSubview(periodLabel)
        self.addSubview(balanceLabel)
        self.addSubview(periodSegmentControl)
        self.addSubview(scrollChartView)
        self.addSubview(noDataLabel)
        self.addSubview(settingsButton)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        plusButton.layer.cornerRadius = plusButton.frame.height / 2
        settingsButton.layer.cornerRadius = plusButton.frame.height / 2
        transactionsTableView.sectionHeaderHeight = transactionsTableView.frame.height / 5
        transactionsTableView.rowHeight = transactionsTableView.frame.height / 5
        horizontalBarChartView.extraLeftOffset = horizontalBarChartView.frame.width / 2
        horizontalBarChartView.xAxis.xOffset = -horizontalBarChartView.frame.width / 3
        expenseButton.layer.cornerRadius = expenseButton.frame.height / 2
        incomeButton.layer.cornerRadius = incomeButton.frame.height / 2
        updateChartHeight()
        horizontalBarChartView.layoutIfNeeded()
        incomeButton.layoutIfNeeded()
        expenseButton.layoutIfNeeded()
        transactionsTableView.layoutIfNeeded()
        settingsButton.layoutIfNeeded()
        plusButton.layoutIfNeeded()
        }
    func configureHeaderView(_ headerView: UIView, with title: String) {
        headerView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 0.8032106311)
        let titleLabel = UILabel()
        titleLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        titleLabel.font = UIFont(name: "Avenir Next Regular", size: 17)
        titleLabel.text = title
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: titleLabel.textColor!,
            .font: titleLabel.font!
        ]
        let attributedText = NSAttributedString(string: titleLabel.text!, attributes: attributes)
        titleLabel.attributedText = attributedText
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
    func setupConstraints() {
        plusButton.snp.makeConstraints {maker in
            maker.width.equalToSuperview().dividedBy(15)
            maker.height.equalTo(plusButton.snp.width)
            maker.right.equalTo(super.safeAreaLayoutGuide.snp.right).inset(15)
            maker.top.equalTo(super.safeAreaLayoutGuide.snp.top).inset(5)
        }
        settingsButton.snp.makeConstraints {maker in
            maker.width.equalToSuperview().dividedBy(15)
            maker.height.equalTo(settingsButton.snp.width)
            maker.right.equalTo(plusButton.snp.left).inset(-5)
            maker.top.equalTo(super.safeAreaLayoutGuide.snp.top).inset(5)
        }
        chooseTransactionView.snp.makeConstraints {maker in
            maker.leading.trailing.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            chooseTransactionView.addSubview(expenseButton)
            chooseTransactionView.addSubview(incomeButton)
        }
        expenseButton.snp.makeConstraints {maker in
            maker.width.equalTo(transactionsTableView).dividedBy(3)
            maker.height.equalTo(expenseButton.snp.width)
            maker.centerY.equalToSuperview()
            maker.right.equalTo(chooseTransactionView).inset(20)
            chooseTransactionView.addSubview(expenseButton)
        }
        incomeButton.snp.makeConstraints {maker in
            maker.width.equalTo(transactionsTableView).dividedBy(3)
            maker.height.equalTo(incomeButton.snp.width)
            maker.centerY.equalToSuperview()
            maker.left.equalTo(chooseTransactionView).inset(20)
            chooseTransactionView.addSubview(expenseButton)
        }
        transactionsTableView.snp.makeConstraints {maker in
            maker.height.equalToSuperview().dividedBy(3)
            maker.bottom.equalTo(periodSegmentControl.snp.top).inset(-50)
            maker.trailing.leading.equalToSuperview().inset(10)
        }
        periodLabel.snp.makeConstraints {maker in
            maker.height.equalTo(periodLabel.snp.width).dividedBy(3)
            maker.width.equalToSuperview().dividedBy(4)
            maker.left.equalToSuperview().inset(10)
            maker.top.equalTo(transactionsTableView.snp.bottom)
        }
        balanceLabel.snp.makeConstraints {maker in
            maker.height.equalTo(periodLabel.snp.width).dividedBy(3)
            maker.width.equalToSuperview().dividedBy(2)
            maker.right.equalToSuperview().inset(10)
            maker.top.equalTo(transactionsTableView.snp.bottom)
        }
        periodSegmentControl.snp.makeConstraints {maker in
            maker.bottom.equalTo(super.safeAreaLayoutGuide.snp.bottom).inset(30)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(transactionsTableView.snp.width).dividedBy(1.2)
        }
        scrollChartView.snp.makeConstraints {maker in
            maker.bottom.equalTo(transactionsTableView.snp.top).inset(-30)
            maker.leading.trailing.equalToSuperview().inset(10)
            maker.height.equalToSuperview().dividedBy(3)
            scrollChartView.addSubview(horizontalBarChartView)
        }
        noDataLabel.snp.makeConstraints {maker in
            maker.bottom.equalTo(transactionsTableView.snp.top).inset(-30)
            maker.leading.trailing.equalToSuperview().inset(10)
            maker.height.equalToSuperview().dividedBy(3)
        }
    }
    func updateChartHeight() {
        let barCount = horizontalBarChartView.data?.dataSets.first?.entryCount
        let newHeight = CGFloat(barCount ?? 0) * 50
            horizontalBarChartView.snp.remakeConstraints {maker in
                maker.height.equalTo(newHeight)
                maker.width.equalToSuperview()
                maker.top.equalToSuperview()
                maker.bottom.equalToSuperview()
        }
        scrollChartView.contentSize = CGSize(width: scrollChartView.bounds.width, height: newHeight)
        ifNoData()
        horizontalBarChartView.layoutIfNeeded()
       }
    func ifNoData() {
        let barCount = horizontalBarChartView.data?.dataSets.first?.entryCount
        if barCount == 0 {
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
    }
    func addPlusButtonTarget(_ target: Any?, action: Selector) {
        plusButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addSettingsButtonTarget(_ target: Any?, action: Selector) {
        settingsButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addExpenseButtonTarget(_ target: Any?, action: Selector) {
        expenseButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addIncomeButtonTarget(_ target: Any?, action: Selector) {
        incomeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    func addSegmentedControlTarget(_ target: Any?, action: Selector) {
        periodSegmentControl.addTarget(target, action: action, for: .valueChanged)
    }
}
