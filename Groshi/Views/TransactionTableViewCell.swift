//
//  TransactionTableViewCell.swift
//  Groshi
//
//  Created by Lesha Mednikov on 08.05.2023.
//

import UIKit
class TransactionTableViewCell: UITableViewCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 17)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let sumLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        label.font =  UIFont(name: "Avenir Next Regular", size: 17)
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(sumLabel)
        categoryLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
            maker.left.equalToSuperview().inset(10)
            }
        sumLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview().dividedBy(2)
            maker.right.equalToSuperview().inset(10)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        selectedBackgroundView?.backgroundColor = #colorLiteral(red: 0.6274510622, green: 0.6274510026, blue: 0.6274510026, alpha: 1)
    }
}
