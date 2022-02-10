//
//  HistoryViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit
import RealmSwift
import SafariServices

class HistoryViewController: UIViewController {
    
    let results = DatabaseManager.shared.database.objects(RepositoryRealm.self)
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        return table
    }()
    
    private let repositoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Last 20 viewed repository"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private let noRepositoryLabel:UILabel = {
        let label = UILabel()
        label.text = "No viewed repository"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        view.backgroundColor = .systemBackground
        title = "History"
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(didTapClear))
        self.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        addSubviews()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DatabaseManager.shared.getDataFromDB().count == 21{
            guard let first = results.first else {
                return
            }
            
            DatabaseManager.shared.deleteFromDb(object: first)
        }
        tableView.reloadData()
        if results.count == 0 {
            noRepositoryLabel.isHidden = false
        }
        else {
            noRepositoryLabel.isHidden = true
        }
    }
    
    
    private func addSubviews() {
        view.addSubview(filterButton)
        view.addSubview(tableView)
        view.addSubview(repositoryLabel)
        view.addSubview(noRepositoryLabel)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        filterButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
        
        repositoryLabel.frame = CGRect(
            x: 0,
            y: navigationBarBottom ,
            width: view.width-20,
            height: 35
        )
        
        noRepositoryLabel.frame = CGRect(
            x: 10,
            y: (view.height-100)/2,
            width: view.width-20,
            height: 100
        )
        
        tableView.frame = CGRect(
            x: 0,
            y: repositoryLabel.bottom ,
            width: view.width,
            height: view.height
        )
        
        
    }
    
    @objc private func didTapClear() {
        let sheet = UIAlertController(title: "Clear", message: "Are you wanna clear history ?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Clear All", style: .destructive, handler: { _ in
            
            DatabaseManager.shared.deleteAllFromDatabase()
            self.tableView.reloadData()
            self.noRepositoryLabel.isHidden = false
        }))
        present(sheet, animated: true, completion: nil)
    }
    
    
}

//MARK: Table View
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return results.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
            fatalError()
        }
        
        
        // Reverse repo array by recent date
        let reverseResult = results.sorted(byKeyPath: "updated", ascending: false)
        
        let id = reverseResult[indexPath.row].id
        let name = reverseResult[indexPath.row].name
        let owner = reverseResult[indexPath.row].owner
        let description = reverseResult[indexPath.row].descriptionRepo ?? ""
        //        let stargazersCount = results.reversed()[indexPath.row].stargazers_count
        
        cell.config(withId: String(id), name: name, owner: owner, andDescription: description)
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reverseResult = results.sorted(byKeyPath: "updated", ascending: false)
        let data = reverseResult[indexPath.row]
        
        guard let url = URL(string: data.html_url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            let reverseResult = results.sorted(byKeyPath: "updated", ascending: false)
            tableView.beginUpdates()
            
            
            DatabaseManager.shared.deleteFromDb(object: reverseResult[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .left)
            
            tableView.endUpdates()
        }
    }
    
}

