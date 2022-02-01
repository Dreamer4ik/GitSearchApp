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

    private let idLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .heavy)
        return label
    }()
    
    private let repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        idLabel.frame = CGRect(
            x: 10,
            y: contentView.top + 20,
            width: contentView.frame.size.width - 20,
            height: 20
        )
        
        ownerLabel.frame = CGRect(
            x: 10,
            y: idLabel.bottom + 5,
            width: contentView.frame.size.width - 20,
            height: 20
        )
        
        nameLabel.frame = CGRect(
            x: 10,
            y: ownerLabel.bottom + 5,
            width: contentView.frame.size.width - 20,
            height: 20
        )
 
        repoDescriptionLabel.frame = CGRect(
            x: 20,
            y: nameLabel.bottom ,
            width: contentView.frame.size.width - 20,
            height: 90
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = nil
        nameLabel.text = nil
        ownerLabel.text = nil
        repoDescriptionLabel.text = nil
        
    }
    
    func config(withId: String, name: String, owner:String, andDescription: String) {
        idLabel.text = withId
        nameLabel.text = name
        ownerLabel.text = owner
        repoDescriptionLabel.text = andDescription
    }
    
    
    private func addSubViews(){
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(repoDescriptionLabel)
        
    }
}
