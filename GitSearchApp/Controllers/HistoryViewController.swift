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
    
    
    private let chooseFilterAction = ["From high rate stars to low", "From low  rate stars to high"]
    var selectedRow = 0
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        //        table.backgroundColor = .red
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
        
       
        self.tableView.contentInset.bottom = self.tabBarController?.tabBar.frame.height ?? 0
        
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
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
    
    
    @objc private func didTapFilter() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Filter", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = filterButton
        alert.popoverPresentationController?.sourceRect = filterButton.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            
            let selected = Array(self.chooseFilterAction)[self.selectedRow]
            
            if selected.contains("From high rate stars to low") {
                //                self.searchDataAll.sort {
                //                            $0.stargazers_count > $1.stargazers_count
                //                        }
                //                self.tableView.scrollToTop()
                
                print("selected From high rate stars to low" )
            }
            if selected.contains("From low  rate stars to high"){
                //                self.searchDataAll.sort {
                //                            $0.stargazers_count < $1.stargazers_count
                //                        }
                //                self.tableView.scrollToTop()
                print("selected From low  rate stars to high" )
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
    
    
    
    
}


extension HistoryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return chooseFilterAction.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(chooseFilterAction)[row]
        label.sizeToFit()
        return label
    }
    
}
