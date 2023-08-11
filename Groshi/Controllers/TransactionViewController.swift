//
//  TransactionViewController.swift
//  Groshi
//
//  Created by Lesha Mednikov on 03.05.2023.
//

import UIKit
protocol TransactionDelegate: AnyObject {
    func addTransaction(category: String, sum: String, date: String)
}
class TransactionViewController: UIViewController {
    weak var transactionView: TransactionView? {return self.view as? TransactionView}
    var typeOfButton: String?
    var categoryTransactionModel = Category()
    var transactionDelegate: TransactionDelegate?
    var transactionModel = TransactionModel()
    override func loadView() {
        self.view = TransactionView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        transactionView?.addEraseButtonTarget(self, action: #selector(backspaceButtonTapped))
        transactionView?.addDecimalButtonTarget(self, action: #selector(decimalButtonTapped))
        transactionView?.addNumberButtonTarget(self, action: #selector(numberButtonTapped))
        transactionView?.addTransactionButtonTarget(self, action: #selector(addButtonPressed))
        transactionView?.addCalendarButtonTarget(self, action: #selector(calendarButtonPressed))
        transactionView?.addNewCategoryButtonTarget(self, action: #selector(addCategoryButtonPressed))
        transactionView?.categoryTableView.delegate = self
        transactionView?.categoryTableView.dataSource = self
        categoryTransactionModel.launchCategories()
        categoryTransactionModel.fetchExpense()
        categoryTransactionModel.fetchIncomes()
    }
    @objc func backspaceButtonTapped() {
        if transactionView?.transactionLabel.text != "" {
            transactionView?.transactionLabel.text?.removeLast()
        }
    }
    @objc func decimalButtonTapped() {
        let dot = "."
        if transactionView?.transactionLabel.text != "" && transactionView?.transactionLabel.text?.range(of: dot) != nil { return }
        transactionView?.transactionLabel.text! += dot
        if transactionView?.transactionLabel.text?.first == "." {
            transactionView?.transactionLabel.text? = "0."
        }
    }
    @objc func numberButtonTapped(_ sender: UIButton) {
        guard let numberString = sender.titleLabel?.text else { return }
        if numberString == "0" && transactionView?.transactionLabel.text! == "0" { return
        } else if numberString != "0" && transactionView?.transactionLabel.text! == "0" { transactionView?.transactionLabel.text! = numberString
        } else { transactionView?.transactionLabel.text! += numberString
        }
    }
    @objc func addButtonPressed() {
        if transactionView?.transactionLabel.text != "" && Double((transactionView?.transactionLabel.text!)!) != 0 {
            transactionView?.categoryTableView.isHidden = false
        }
    }
    @objc func calendarButtonPressed() {
        let viewController = CalendarViewController()
        viewController.dateDelegate = self
        self.present(viewController, animated: true)
    }
    @objc func addCategoryButtonPressed() {
        let textField = transactionView?.addCategoryTextField
        if textField!.text != "" && textField!.text?.first != " " {
            if let text = textField!.text, !text.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    if self?.typeOfButton == "expense" {
                        self?.categoryTransactionModel.saveExpenseCategory(categorySave: text)
                        self?.transactionView?.categoryTableView.reloadData()
                    } else {
                        self?.categoryTransactionModel.saveIncomeCategory(categorySave: text)
                        self?.transactionView?.categoryTableView.reloadData()
                    }
                }
            }
            transactionView?.categoryTableView.reloadData()
            transactionView?.addNewCategoryView.endEditing(true)
            transactionView?.addNewCategoryView.isHidden = true
            transactionView?.categoryTableView.isHidden = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        transactionView?.categoryTableView.isHidden = true
        transactionView?.addNewCategoryView.isHidden = true
        transactionView?.addNewCategoryView.endEditing(true)
    }
}
extension TransactionViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if typeOfButton == "expense" {
            return categoryTransactionModel.expensesCategories.count
        } else {
            return  categoryTransactionModel.incomesCategories.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath {
            cell.textLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.selectionStyle = .none
            cell.backgroundColor = #colorLiteral(red: 0.02982655168, green: 0.6277089715, blue: 0.009839610197, alpha: 1)
        } else {
            cell.textLabel?.font = UIFont(name: "Avenir Next Regular", size: 17)
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        }
        if typeOfButton == "expense" {
            cell.textLabel?.text = categoryTransactionModel.expensesCategories[indexPath.row].value(forKey: "category") as? String
        } else {
            cell.textLabel?.text = categoryTransactionModel.incomesCategories[indexPath.row].value(forKey: "category") as? String
        }
                return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == NSIndexPath(row: 0, section: 0) as IndexPath {
            transactionView?.addNewCategoryView.isHidden = false
            tableView.isHidden = true
            } else if (transactionView?.categoryTableView.indexPathForSelectedRow != nil) == true && NSIndexPath(row: 0, section: 0) as IndexPath != transactionView?.categoryTableView.indexPathForSelectedRow {
                guard let indexPath = transactionView?.categoryTableView.indexPathForSelectedRow else { return }
                let currentCell = transactionView?.categoryTableView.cellForRow(at: indexPath)
                var tempCategory = ""
                tempCategory = (currentCell?.textLabel!.text)!
                if self.typeOfButton == "expense" {
                    transactionDelegate?.addTransaction(category: tempCategory, sum: "-" + (transactionView?.transactionLabel.text)!, date: (transactionView?.dateLabel.text!)!)
                } else {
                    transactionDelegate?.addTransaction(category: tempCategory, sum: (transactionView?.transactionLabel.text)!, date: (transactionView?.dateLabel.text!)!)
                }
                dismiss(animated: true)
            }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if typeOfButton == "expense" {
                categoryTransactionModel.deleteExpenseCategory(at: indexPath, view: transactionView!, model: categoryTransactionModel)
                tableView.reloadData()
            } else {
                categoryTransactionModel.deleteIncomeCategory(at: indexPath, view: transactionView!, model: categoryTransactionModel)
                tableView.reloadData()
            }
        }
    }
}
extension TransactionViewController: CalendarViewControllerDelegate {
    func setDate(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        transactionView?.dateLabel.text = date
    }
}
