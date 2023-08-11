//
//  LaunchScreenViewController.swift
//  Groshi
//
//  Created by Lesha Mednikov on 16.06.2023.
//

import UIKit
import SnapKit
class LaunchScreenViewController: UIViewController {
    weak var launchView: LaunchView? {return self.view as? LaunchView}
    override func loadView() {
        self.view = LaunchView(frame: UIScreen.main.bounds)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
