//
//  CategoryTransactionModel.swift
//  Groshi
//
//  Created by Lesha Mednikov on 05.05.2023.
//

import UIKit
import CoreData
class Category {
    var incomesCategories = [NSManagedObject]()
    var expensesCategories = [NSManagedObject]()
    func saveIncomeCategory(categorySave: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity =  NSEntityDescription.entity(forEntityName: "IncomesCategories", in: context) else { return }
        let category = NSManagedObject(entity: entity, insertInto: context)
        category.setValue(categorySave, forKey: "category")
        do {
            try context.save()
            incomesCategories.append(category)
        } catch {
        }
    }
    func saveExpenseCategory(categorySave: String) {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity =  NSEntityDescription.entity(forEntityName: "ExpensesCategories", in: context) else { return }
        let category = NSManagedObject(entity: entity, insertInto: context)
        category.setValue(categorySave, forKey: "category")
        do {
            try context.save()
            expensesCategories.append(category)
        } catch {
        }
    }
    func fetchIncomes() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IncomesCategories")
        do {
            let result = try context.fetch(fetchRequest)
            incomesCategories = result as? [NSManagedObject] ?? []
        } catch {
        }
    }
    func fetchExpense() {
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ExpensesCategories")
        do {
            let result = try context.fetch(fetchRequest)
            expensesCategories = result as? [NSManagedObject] ?? []
        } catch {
        }
    }
    func launchCategories() {
        let hasLaunchedKey = "HasLaunchedCategories"
        let defaults = UserDefaults.standard
        let hasLaunched = defaults.bool(forKey: hasLaunchedKey)
        if !hasLaunched {
            defaults.set(true, forKey: hasLaunchedKey)
            let incomesCategories: [String] = ["Create category", "💰 Salary", "🏦 Bank", "🛒 Investments", "🎁 Gift"]
            for category in incomesCategories {
                self.saveIncomeCategory(categorySave: category)
            }
            let expensesCategories: [String] = ["Create category", "💵 Bills", "🍿 Entertainment", "🛒 Food", "🚗 Car", "👕 Clothes", "🐕 Pets"]
            for category in expensesCategories {
                self.saveExpenseCategory(categorySave: category)
            }
        }
    }
    func deleteExpenseCategory(at indexPath: IndexPath, view: TransactionView, model: Category) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if indexPath != NSIndexPath(row: 0, section: 0) as IndexPath {
            context.delete(model.expensesCategories[indexPath.row])
            model.expensesCategories.remove(at: indexPath.row)
            do {
                try context.save()
                view.categoryTableView.reloadData()
            } catch {
            }
        }
    }
    func deleteIncomeCategory(at indexPath: IndexPath, view: TransactionView, model: Category) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        if indexPath != NSIndexPath(row: 0, section: 0) as IndexPath {
            context.delete(model.incomesCategories[indexPath.row])
            model.incomesCategories.remove(at: indexPath.row)
            do {
                try context.save()
                view.categoryTableView.reloadData()
            } catch {
            }
        }
    }
}
