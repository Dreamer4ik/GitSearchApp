//
//  HomeViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit

class HomeViewController: UIViewController {
    static let shared = HomeViewController()
    
    
    var allReposData = [Int : [ViewModelDataPack]]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search GitHub..."
        bar.layer.cornerRadius = 8
        bar.clipsToBounds = true
        bar.backgroundColor = .systemBackground
        return bar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapLogOut))
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        
        view.backgroundColor = .red
        
        searchBar.delegate = self
        setUpTableView()
        addSubviews()
        
        APICaller.shared.getData()
        print("viewDidLoad allReposData element: \(allReposData)")
        print("viewDidLoad allReposData elements \(allReposData.count)")
        print("viewDidLoad allReposData isEmpty \(allReposData.isEmpty)")
//        tableView.reloadData()
    }
    
    
    
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 20, y: view.top + 150, width: view.width - 40, height: 35)
        tableView.frame = CGRect(x: 0, y: searchBar.bottom + 10, width: view.width, height: view.height)
    }
    
    //MARK:  Data
    
    func viewReposData(pagePack: [Int : [ViewModelDataPack]]) {
//        print(pagePack)
        allReposData[(pagePack.first?.key)!] = pagePack.first?.value
        
//        print("pagePack.first?.value :\(pagePack.first?.value)")
        print("Func viewReposData  allReposData elements: \(allReposData.count)")
        print("viewReposData allReposData isEmpty \(allReposData.isEmpty)")
        
    }

    
    ///Log out
    @objc private func didTapLogOut() {
        let sheet = UIAlertController(title: "Log out", message: "Are you sure you'd like to log out?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            
            UserDefaults.standard.setValue(false, forKey: "LogIn")
            let signInVc = LoginViewController()
            let navVc = UINavigationController(rootViewController: signInVc)
            navVc.modalPresentationStyle = .fullScreen
            self.present(navVc, animated: true, completion: nil)
        }))
        present(sheet, animated: true, completion: nil)
    }
    
}

//MARK: SearchBar
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        
        searchBar.resignFirstResponder()
        print("Text search: \(text)")
    }
}

//MARK: Table View
//var sharedAllRepos = APICaller.shared.allReposData

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        print("allReposData numberOfSections \(allReposData.count)")
//        return allReposData.count
        print("numberOfSections  allReposData elements: \(allReposData.count)")
        print("numberOfSections allReposData isEmpty \(allReposData.isEmpty)")
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let dataInSection = allReposData[section+1] as [ViewModelDataPack]? else {
//            return 0
//        }
//        print("dataInSection numberOfRowsInSection \(dataInSection.count)")
//        return dataInSection.count
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        guard let dataInSection = allReposData[indexPath.section+1] as [ViewModelDataPack]? else {
//            return UITableViewCell()
//        }
//
//        guard let currentData = dataInSection[indexPath.row] as ViewModelDataPack? else {
//            return UITableViewCell()
//        }
//
//
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
//            fatalError()
//        }
//
//        cell.config(withId: currentData.idStr, name: currentData.nameSrt, owner: currentData.ownerStr, andDescription: currentData.descriptionStr ?? "Not description")
        
        
//        return cell
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Details")
    }
    
    
}
