//
//  CalendarViewController.swift
//  Groshi
//
//  Created by Lesha Mednikov on 05.05.2023.
//

import UIKit
protocol CalendarViewControllerDelegate: AnyObject {
    func setDate(date: String)
}
class CalendarViewController: UIViewController {
    var dateDelegate: CalendarViewControllerDelegate?
    let dateFormatter = DateFormatter()
    var date = ""
    weak var calendarView: CalendarView? {return self.view as? CalendarView}
    override func loadView() {
        self.view = CalendarView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView?.addOkButtonTarget(self, action: #selector(okButtonTapped))
    }
    @objc func okButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        date = dateFormatter.string(from: (calendarView?.calendar.date)!)
        dateDelegate?.setDate(date: date)
        dismiss(animated: true)
    }
}
