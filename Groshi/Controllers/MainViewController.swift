//
//  MainViewController.swift
//  Groshi
//
//  Created by Lesha Mednikov on 01.05.2023.
//

import UIKit
class MainViewController: UIViewController {
    weak var mainView: MainView? {return self.view as? MainView}
    var transactionModel = TransactionModel()
    var transactionTableViewCell: TransactionTableViewCell?
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        configureUI()
        setupTableView()
        setupTransactionModel()
        reloadDataTableView()
    }
    private func configureUI() {
        mainView?.addPlusButtonTarget(self, action: #selector(chooseTransaction))
        mainView?.addSettingsButtonTarget(self, action: #selector(settingsButtonPressed))
        mainView?.addExpenseButtonTarget(self, action: #selector(expenseButtonPressed))
        mainView?.addIncomeButtonTarget(self, action: #selector(incomeButtonPressed))
        mainView?.addSegmentedControlTarget(self, action: #selector(segmentControlValueChanged))
        mainView?.periodLabel.text = TimePeriod.today.rawValue
        mainView?.expenseButton.layoutIfNeeded()
        mainView?.incomeButton.layoutIfNeeded()
        mainView?.updateChartHeight()
    }
    private func setupTableView() {
        mainView?.transactionsTableView.delegate = self
        mainView?.transactionsTableView.dataSource = self
    }
    private func setupTransactionModel() {
        transactionModel.retrieveTransactions()
        transactionModel.dateFormatter.dateFormat = "dd.MM.yy"
        transactionModel.filterTransactions(model: transactionModel)
        transactionModel.makeUniqueDates()
        transactionModel.makeBalance(view: mainView!)
        transactionModel.displayChart(view: mainView!)
    }
    private func reloadDataTableView() {
        mainView?.transactionsTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        mainView?.transactionsTableView.reloadData()
    }
    @objc func chooseTransaction() {
        if mainView?.chooseTransactionView.isHidden == true {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.mainView?.transactionsTableView.isHidden = true
                self?.mainView?.periodLabel.isHidden = true
                self?.mainView?.periodSegmentControl.isHidden = true
                self?.mainView?.balanceLabel.isHidden = true
                self?.mainView?.plusButton.isHidden = true
                self?.mainView?.settingsButton.isHidden = true
                self?.mainView?.scrollChartView.isHidden = true
                self?.mainView?.noDataLabel.isHidden = true
                self?.mainView?.chooseTransactionView.isHidden = false
            }
        }
    }
    @objc func settingsButtonPressed () {
        let viewController = SettingsViewController()
        viewController.deleteDataDelegate = self
        self.present(viewController, animated: true)
    }
    @objc func expenseButtonPressed () {
        let viewController = TransactionViewController()
        viewController.typeOfButton = "expense"
        viewController.transactionDelegate = self
        mainView?.chooseTransactionView.isHidden = true
        self.present(viewController, animated: true)
    }
    @objc func incomeButtonPressed () {
        let viewController = TransactionViewController()
        viewController.typeOfButton = "income"
        viewController.transactionDelegate = self
        mainView?.chooseTransactionView.isHidden = true
        self.present(viewController, animated: true)
    }
    func updatePeriod() {
        transactionModel.dateFormatter.dateFormat = "dd.MM.yy"
        transactionModel.filterTransactions(model: transactionModel)
        transactionModel.makeUniqueDates()
        transactionModel.makeBalance(view: mainView!)
        transactionModel.displayChart(view: mainView!)
        mainView?.ifNoData()
        mainView?.transactionsTableView.reloadData()
    }
    @objc func segmentControlValueChanged(_ segmentControl: UISegmentedControl) {
        let selectedPeriod = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)
        mainView?.periodLabel.text = selectedPeriod
        updatePeriod()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.mainView?.chooseTransactionView.isHidden = true
            self?.mainView?.periodLabel.isHidden = false
            self?.mainView?.balanceLabel.isHidden = false
            self?.mainView?.periodSegmentControl.isHidden = false
            self?.mainView?.transactionsTableView.isHidden = false
            self?.mainView?.plusButton.isHidden = false
            self?.mainView?.settingsButton.isHidden = false
            self?.mainView?.ifNoData()
            self?.mainView?.scrollChartView.isHidden = false
        }
    }
}
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let currentPeriod = mainView?.periodLabel.text,
                  let period = TimePeriod(rawValue: currentPeriod) else {
                return 0
            }
            switch period {
            case .today:
                return transactionModel.uniqueNowDates.count
            case .week:
                return transactionModel.uniqueWeekDates.count
            case .month:
                return transactionModel.uniqueMonthDates.count
            case .year:
                return transactionModel.uniqueYearDates.count
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let currentPeriod = mainView?.periodLabel.text,
                  let period = TimePeriod(rawValue: currentPeriod) else {
                return 0
            }
        switch period {
        case .today:
            let transactionsForSection = transactionModel.nowTransactions.filter { $0.date == transactionModel.uniqueNowDates[section] }
            return transactionsForSection.count
        case .week:
            let transactionsForSection = transactionModel.weekTransactions.filter { $0.date == transactionModel.uniqueWeekDates[section] }
            return transactionsForSection.count
        case .month:
            let transactionsForSection = transactionModel.monthTransactions.filter { $0.date == transactionModel.uniqueMonthDates[section] }
            return transactionsForSection.count
        case .year:
            let transactionsForSection = transactionModel.yearTransactions.filter { $0.date == transactionModel.uniqueYearDates[section] }
            return transactionsForSection.count
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let currentPeriod = mainView?.periodLabel.text,
              let period = TimePeriod(rawValue: currentPeriod) else {
            return nil
        }
        let headerView = UIView()
        switch period {
        case .today:
            let title = transactionModel.uniqueNowDates[section]
            mainView?.configureHeaderView(headerView, with: title)
        case .week:
            let title = transactionModel.uniqueWeekDates[section]
            mainView?.configureHeaderView(headerView, with: title)
        case .month:
            let title = transactionModel.uniqueMonthDates[section]
            mainView?.configureHeaderView(headerView, with: title)
        case .year:
            let title = transactionModel.uniqueYearDates[section]
            mainView?.configureHeaderView(headerView, with: title)
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionTableViewCell
            if let cell = cell {
                guard let currentPeriod = mainView?.periodLabel.text,
                          let period = TimePeriod(rawValue: currentPeriod) else {
                        return cell
                    }
                switch period {
                case .today:
                    let transactionsForSection = transactionModel.nowTransactions.filter { $0.date == transactionModel.uniqueNowDates[indexPath.section] }
                    let transaction = transactionsForSection[indexPath.row]
                    if transaction.sum.hasPrefix("-") {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    } else {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
                    }
                    cell.categoryLabel.text = transaction.category
                    cell.sumLabel.text = transaction.sum
                    return cell
                case .week:
                    let transactionsForSection = transactionModel.weekTransactions.filter { $0.date == transactionModel.uniqueWeekDates[indexPath.section] }
                    let transaction = transactionsForSection[indexPath.row]
                    if transaction.sum.hasPrefix("-") {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    } else {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
                    }
                    cell.categoryLabel.text = transaction.category
                    cell.sumLabel.text = transaction.sum
                    return cell
                case .month:
                    let transactionsForSection = transactionModel.monthTransactions.filter { $0.date == transactionModel.uniqueMonthDates[indexPath.section] }
                    let transaction = transactionsForSection[indexPath.row]
                    if transaction.sum.hasPrefix("-") {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    } else {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
                    }
                    cell.categoryLabel.text = transaction.category
                    cell.sumLabel.text = transaction.sum
                    return cell
                case .year:
                    let transactionsForSection = transactionModel.yearTransactions.filter { $0.date == transactionModel.uniqueYearDates[indexPath.section] }
                    let transaction = transactionsForSection[indexPath.row]
                    if transaction.sum.hasPrefix("-") {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                    } else {
                        cell.sumLabel.textColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
                    }
                    cell.categoryLabel.text = transaction.category
                    cell.sumLabel.text = transaction.sum
                    return cell
                }
            } else {
                return UITableViewCell()
            }
        }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactionModel.deleteTransaction(at: indexPath, view: mainView!, model: transactionModel)
            transactionModel.makeBalance(view: mainView!)
            transactionModel.displayChart(view: mainView!)
            mainView?.ifNoData()
            tableView.reloadData()
        }
    }
}
extension MainViewController: TransactionDelegate, SettingsViewControllerDelegate {
    func addTransaction(category: String, sum: String, date: String) {
        mainView?.periodLabel.isHidden = false
        mainView?.periodSegmentControl.isHidden = false
        mainView?.transactionsTableView.isHidden = false
        mainView?.balanceLabel.isHidden = false
        mainView?.plusButton.isHidden = false
        mainView?.settingsButton.isHidden = false
        mainView?.scrollChartView.isHidden = false
        transactionModel.tran.category = category
        transactionModel.tran.sum = sum
        transactionModel.tran.date = date
        transactionModel.allTransactions.append(transactionModel.tran)
        transactionModel.dateFormatter.dateFormat = "dd.MM.yy"
        transactionModel.saveTransaction(transactions: transactionModel.allTransactions)
        mainView?.periodLabel.text = TimePeriod.today.rawValue
        transactionModel.filterTransactions(model: transactionModel)
        transactionModel.makeUniqueDates()
        transactionModel.makeBalance(view: mainView!)
        transactionModel.displayChart(view: mainView!)
        mainView?.ifNoData()
        mainView?.periodSegmentControl.selectedSegmentIndex = 0
        mainView?.transactionsTableView.reloadData()
    }
    func didDeleteAlldata() {
        transactionModel.deleteAllTransactions()
        transactionModel.makeUniqueDates()
        transactionModel.makeBalance(view: mainView!)
        transactionModel.displayChart(view: mainView!)
        mainView?.ifNoData()
        mainView?.periodSegmentControl.selectedSegmentIndex = 0
        mainView?.transactionsTableView.reloadData()
    }
}
