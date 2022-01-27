//
//  RepositoryHeaderTableViewCell.swift
//  GitSearchApp
//
//  Created by Ivan on 27.01.2022.
//

import UIKit

// Profile picture,ownerLabel, title, button share
class RepositoryHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "RepositoryHeaderTableViewCell"
 
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let repoTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(headerImageView)
        contentView.addSubview(repoTitleLabel)
        contentView.addSubview(shareButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        headerImageView.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//        repoTitleLabel.frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        repoTitleLabel.text = nil
        headerImageView.image = nil
    }
    
    func configure() {
  
    }

}
