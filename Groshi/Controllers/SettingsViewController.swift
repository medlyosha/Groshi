//
//  SettingsViewController.swift
//  Groshi
//
//  Created by Lesha Mednikov on 06.06.2023.
//

import UIKit
import MessageUI
protocol SettingsViewControllerDelegate: AnyObject {
    func didDeleteAlldata()
}
class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    weak var settingsView: SettingsView? {return self.view as? SettingsView}
    weak var deleteDataDelegate: SettingsViewControllerDelegate?
    override func loadView() {
        self.view = SettingsView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView?.addDeleteDataButtonTarget(self, action: #selector(deleteDataButtonPressed))
        settingsView?.addContactDevButtonTarget(self, action: #selector(contactDeveloperButtonPressed))
    }
    @objc func deleteDataButtonPressed () {
        let alertController = UIAlertController(title: "Delete all transactions?", message: "", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_: UIAlertAction!) in
            self.deleteDataDelegate?.didDeleteAlldata()
            self.dismiss(animated: true)
      }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_: UIAlertAction!) in
            print("Handle Cancel logic here")
      }))
        present(alertController, animated: true)
    }
    @objc func contactDeveloperButtonPressed() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["lyoshamedn@gmail.com"])
            mailComposer.setSubject("Question from user")
            present(mailComposer, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No internet connection", message: "Please, connect to the internet", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (_: UIAlertAction!) in
                print("There is no internet connection on the device")
            }))
            present(alertController, animated: true)
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
