//
//  RepositoryCell.swift
//  GitSearchApp
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

//Description
//
class RepositoryCell: UITableViewCell {

    static let identifier = "RepositoryCell"
       
    private let repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .medium)
        return label
    }()
       
    
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
