//
//  LaunchView.swift
//  Groshi
//
//  Created by Lesha Mednikov on 16.06.2023.
//

import UIKit
import SnapKit
class LaunchView: UIView {
    let groshiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GroshiLaunchScreen")
        imageView.backgroundColor = .green
        return imageView
    }()
    func setupConstraints() {
        groshiImageView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(groshiImageView)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
