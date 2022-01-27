//
//  GeneralTableViewCell.swift
//  GitSearchApp
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

//Stars, language, contributors
class GeneralTableViewCell: UITableViewCell {
    static let identifier = "GeneralTableViewCell"
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
       
    }
    
    func configure() {
  
    }
    
}
