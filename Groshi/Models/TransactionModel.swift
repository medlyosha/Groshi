//
//  TransactionModel.swift
//  Groshi
//
//  Created by Lesha Mednikov on 03.05.2023.
//

import UIKit
import CoreData
import Charts
struct Transaction {
    var category: String
    var sum: String
    var date: String
}
enum TimePeriod: String {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}
class EntityTransactions: NSManagedObject {
   @NSManaged var category: String
   @NSManaged var sum: String
   @NSManaged var date: String
    var transact: Transaction {
        get {
            return Transaction(category: self.category, sum: self.sum, date: self.date)
        }
        set {
            category = newValue.category
            sum = newValue.sum
            date = newValue.date
        }
    }
}
class TransactionModel {
    let dateFormatter = DateFormatter()
    let startWeek = Date().startOfWeek
    let startMonth = Date().startOfMonth()
    let startYear = Date().startOfYear()
    var tran = Transaction(category: "", sum: "", date: "")
    var nowTransactions = [Transaction]()
    var allTransactions = [Transaction]()
    var weekTransactions = [Transaction]()
    var monthTransactions = [Transaction]()
    var yearTransactions = [Transaction]()
    var uniqueNowDates = [String]()
    var uniqueWeekDates = [String]()
    var uniqueMonthDates = [String]()
    var uniqueYearDates = [String]()
    func makeUniqueDates() {
        for transaction in nowTransactions {
            if !uniqueNowDates.contains(transaction.date) {
                uniqueNowDates.append(transaction.date)
            }
        }
        for transaction in weekTransactions {
            if !uniqueWeekDates.contains(transaction.date) {
                uniqueWeekDates.append(transaction.date)
                uniqueWeekDates = uniqueWeekDates.sorted(by: {dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)!})
            }
        }
        for transaction in monthTransactions {
            if !uniqueMonthDates.contains(transaction.date) {
                uniqueMonthDates.append(transaction.date)
                uniqueMonthDates = uniqueMonthDates.sorted(by: {dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)!})
            }
        }
        for transaction in yearTransactions {
            if !uniqueYearDates.contains(transaction.date) {
                uniqueYearDates.append(transaction.date)
                uniqueYearDates = uniqueYearDates.sorted(by: {dateFormatter.date(from: $0)! > dateFormatter.date(from: $1)!})
            }
        }
    }
    func filterTransactions(model: TransactionModel) {
        model.nowTransactions = model.allTransactions.filter { $0.date == model.dateFormatter.string(from: Date.now) }
        model.weekTransactions = model.allTransactions.filter { model.dateFormatter.date(from: $0.date)! >=  model.startWeek!}.sorted(by: {model.dateFormatter.date(from: $0.date)! > model.dateFormatter.date(from: $1.date)!})
        model.monthTransactions = model.allTransactions.filter { model.dateFormatter.date(from: $0.date)! >=  model.startMonth}.sorted(by: {model.dateFormatter.date(from: $0.date)! > model.dateFormatter.date(from: $1.date)!})
        model.yearTransactions = model.allTransactions.filter { model.dateFormatter.date(from: $0.date)! >=  model.startYear}.sorted(by: {model.dateFormatter.date(from: $0.date)! > model.dateFormatter.date(from: $1.date)!})
    }
    func makeBalance(view: MainView) {
        var nowSum = [Double]()
        var weekSum = [Double]()
        var monthSum = [Double]()
        var yearSum = [Double]()
        guard let currentPeriod = view.periodLabel.text,
              let period = TimePeriod(rawValue: currentPeriod) else {
            return
        }
        switch period {
        case .today:
            nowSum = nowTransactions.map { Double($0.sum)! }
            let todaySumma =  nowSum.reduce(0, +)
            view.balanceLabel.text = "💰 Balance: " + String(todaySumma)
        case .week:
            weekSum = weekTransactions.map { Double($0.sum)! }
            let weekSumma =  weekSum.reduce(0, +)
            view.balanceLabel.text = "💰 Balance: " + String(weekSumma)
        case .month:
            monthSum = monthTransactions.map { Double($0.sum)! }
            let monthSumma =  monthSum.reduce(0, +)
            view.balanceLabel.text = "💰 Balance: " + String(monthSumma)
        case .year:
            yearSum = yearTransactions.map { Double($0.sum)! }
            let yearSumma =  yearSum.reduce(0, +)
            view.balanceLabel.text = "💰 Balance: " + String(yearSumma)
        }
    }
    func saveTransaction(transactions: [Transaction]) {
        guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let managedTransaction = NSEntityDescription.insertNewObject(forEntityName: "EntityTransactions", into: context)
        for transaction in transactions {
            managedTransaction.setValue(transaction.category, forKey: "category")
            managedTransaction.setValue(transaction.sum, forKey: "sum")
            managedTransaction.setValue(transaction.date, forKey: "date")
            context.insert(managedTransaction)
        }
        do {
            try context.save()
        } catch {
        }
    }
    func retrieveTransactions() {
        guard let appDelegate =
                 UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
        do {
            let results = try context.fetch(fetchRequest)
                for result in results {
                let category = result.value(forKey: "category") as? String
                let sum = result.value(forKey: "sum") as? String
                let date = result.value(forKey: "date") as? String
                    result.transact = Transaction(category: category!, sum: sum!, date: date!)
                    allTransactions.append(result.transact)
            }
        } catch {
        }
    }
    func deleteTransaction(at indexPath: IndexPath, view: MainView, model: TransactionModel) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        var transactions: [Transaction] = []
        guard let currentPeriod = view.periodLabel.text,
              let period = TimePeriod(rawValue: currentPeriod) else {
            return
        }
        switch period {
        case .today:
            transactions = model.nowTransactions.filter { $0.date == model.uniqueNowDates[indexPath.section] }
        case .week:
            transactions = model.weekTransactions.filter { $0.date == model.uniqueWeekDates[indexPath.section] }
        case .month:
            transactions = model.monthTransactions.filter { $0.date == model.uniqueMonthDates[indexPath.section] }
        case .year:
                    transactions = model.yearTransactions.filter { $0.date == model.uniqueYearDates[indexPath.section] }
                }
                let transaction = transactions[indexPath.row]
                let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
                do {
                    let results = try context.fetch(fetchRequest)
                    if let index = model.allTransactions.firstIndex(where: { $0.date == transaction.date && $0.sum == transaction.sum && $0.category == transaction.category }) {
                        model.allTransactions.remove(at: index)
                        filterTransactions(model: self)
                        makeUniqueDates()
                        view.transactionsTableView.reloadData()
                    }
                    if let index2 = results.firstIndex(where: { $0.date == transaction.date && $0.sum == transaction.sum && $0.category == transaction.category }) {
                        context.delete(results[index2])
                        filterTransactions(model: self)
                        makeUniqueDates()
                        view.transactionsTableView.reloadData()
                    }
                    if transactions.count == 1 {
                        for _ in model.uniqueNowDates {
                            if model.uniqueNowDates.contains(transactions[indexPath.row].date) {
                                model.uniqueNowDates.remove(at: indexPath.section)
                            }
                        }
                        for _ in model.uniqueWeekDates {
                            if model.uniqueWeekDates.contains(transactions[indexPath.row].date) {
                                model.uniqueWeekDates.remove(at: indexPath.section)
                            }
                        }
                        for _ in model.uniqueMonthDates {
                            if model.uniqueMonthDates.contains(transactions[indexPath.row].date) {
                                model.uniqueMonthDates.remove(at: indexPath.section)
                            }
                        }
                        for _ in model.uniqueYearDates {
                            if model.uniqueYearDates.contains(transactions[indexPath.row].date) {
                                model.uniqueYearDates.remove(at: indexPath.section)
                            }
                        }
                    }
                    try context.save()
                } catch {
                    print("Failed to save context: \(error)")
                }
            }
    func deleteAllTransactions() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<EntityTransactions>(entityName: "EntityTransactions")
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                context.delete(result)
            }
            allTransactions.removeAll()
            nowTransactions.removeAll()
            weekTransactions.removeAll()
            monthTransactions.removeAll()
            yearTransactions.removeAll()
            uniqueNowDates.removeAll()
            uniqueWeekDates.removeAll()
            uniqueMonthDates.removeAll()
            uniqueYearDates.removeAll()
            try context.save()
        } catch {
        }
    }
    func prepareData(for transactions: [Transaction]) -> [BarChartDataEntry] {
        var dataEntries: [BarChartDataEntry] = []
        var categorySumDict: [String: Double] = [:]
        var expenseArray = transactions.filter { $0.sum.hasPrefix("-") }
        expenseArray = expenseArray.map { transaction in
            var updatedTransaction = transaction
            updatedTransaction.sum.remove(at: transaction.sum.startIndex)
            return updatedTransaction
        }
        categorySumDict = expenseArray.reduce(into: [String: Double]()) { $0[$1.category, default: 0] += Double($1.sum)! }
        var index = 0
        for (category, sum) in categorySumDict {
            let dataEntry = BarChartDataEntry(x: Double(index), y: sum, data: category as String)
            dataEntries.append(dataEntry)
            index += 1
        }
        return dataEntries
    }
    func displayChart(view: MainView) {
        guard let currentPeriod = view.periodLabel.text,
              let period = TimePeriod(rawValue: currentPeriod) else {
            return
        }
        switch period {
        case .today:
            let nowDataEntries = prepareData(for: nowTransactions)
            let nowChartDataSet = BarChartDataSet(entries: nowDataEntries, label: "Today")
            let nowChartData = BarChartData(dataSet: nowChartDataSet)
            nowChartDataSet.drawValuesEnabled = true
            nowChartDataSet.valueFont = UIFont(name: "Avenir Next Regular", size: 14)!
            nowChartDataSet.valueColors = ChartColorTemplates.joyful()
            nowChartDataSet.colors = ChartColorTemplates.joyful()
            nowChartDataSet.form = .circle
            view.horizontalBarChartView.data = nowChartData
            view.horizontalBarChartView.animate(yAxisDuration: 1.5)
            view.horizontalBarChartView.xAxis.labelCount = nowDataEntries.count
            view.horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: nowDataEntries.map { $0.data as? String ?? ""  })
        case .week:
            let weekDataEntries = prepareData(for: weekTransactions)
            let weekChartDataSet = BarChartDataSet(entries: weekDataEntries, label: "Week")
            let weekChartData = BarChartData(dataSet: weekChartDataSet)
            weekChartDataSet.drawValuesEnabled = true
            weekChartDataSet.valueFont = UIFont(name: "Avenir Next Regular", size: 14)!
            weekChartDataSet.valueColors = ChartColorTemplates.joyful()
            weekChartDataSet.colors = ChartColorTemplates.joyful()
            weekChartDataSet.form = .circle
            view.horizontalBarChartView.data = weekChartData
            view.horizontalBarChartView.animate(yAxisDuration: 1.5)
            view.horizontalBarChartView.xAxis.labelCount = weekDataEntries.count
            view.horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: weekDataEntries.map { $0.data as? String ?? "" })
        case .month:
            let monthDataEntries = prepareData(for: monthTransactions)
            let monthChartDataSet = BarChartDataSet(entries: monthDataEntries, label: "Month")
            let monthChartData = BarChartData(dataSet: monthChartDataSet)
            monthChartDataSet.drawValuesEnabled = true
            monthChartDataSet.valueFont = UIFont(name: "Avenir Next Regular", size: 14)!
            monthChartDataSet.valueColors = ChartColorTemplates.joyful()
            monthChartDataSet.colors = ChartColorTemplates.joyful()
            monthChartDataSet.form = .circle
            view.horizontalBarChartView.data = monthChartData
            view.horizontalBarChartView.animate(yAxisDuration: 1.5)
            view.horizontalBarChartView.xAxis.labelCount = monthDataEntries.count
            view.horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: monthDataEntries.map { $0.data as? String ?? "" })
        case .year:
            let yearDataEntries = prepareData(for: yearTransactions)
            let yearChartDataSet = BarChartDataSet(entries: yearDataEntries, label: "Year")
            let yearChartData = BarChartData(dataSet: yearChartDataSet)
            yearChartDataSet.drawValuesEnabled = true
            yearChartDataSet.valueFont = UIFont(name: "Avenir Next Regular", size: 14)!
            yearChartDataSet.valueColors = ChartColorTemplates.joyful()
            yearChartDataSet.colors = ChartColorTemplates.joyful()
            yearChartDataSet.form = .circle
            view.horizontalBarChartView.data = yearChartData
            view.horizontalBarChartView.animate(yAxisDuration: 1.5)
            view.horizontalBarChartView.xAxis.labelCount = yearDataEntries.count
            view.horizontalBarChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: yearDataEntries.map { $0.data as? String ?? "" })
        }
    }
}
extension Date {
    var startOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 1, to: sunday)
    }
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
}
extension Date {
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
}
extension Date {
    var startOfNextyear: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let nextYear = gregorian.date(from: gregorian.dateComponents([.year], from: self)) else { return nil }
        return gregorian.date(byAdding: .year, value: 1, to: nextYear)
    }
}
