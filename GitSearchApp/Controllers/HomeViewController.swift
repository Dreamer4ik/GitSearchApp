//
//  HomeViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class HomeViewController: UIViewController {
    static let shared = HomeViewController()
    
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var currentQuery: String = ""
    
    var allReposData = [ViewModelDataPack]() {
        didSet {
            tableView.reloadData()
        }
    }
    var searchData = [RepositoryInfo]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchDataAll = [RepositoryInfo]() {
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
        getData()
        
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
    
    func getData(){
        var responses = [Response]()
        AF.request(Constants.getPublicRepo, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                var pageData = [ViewModelDataPack]()
                var viewModelsPack = ViewModelDataPack()
                
                for index in 0...json.count {
                    var currentResponse = Response()
                    
                    if let id = json[index]["id"].int {
                        currentResponse.idStr = "\(id)"
                    }
                    
                    if let name = json[index]["name"].string {
                        currentResponse.nameSrt = "\(name)"
                    }
                    
                    if let owner = json[index]["owner"]["login"].string {
                        currentResponse.ownerStr = "\(owner)"
                    }
                    
                    if let description = json[index]["description"].string {
                        currentResponse.descriptionStr = "\(description)"
                    }
                    
                    if let link = json[index]["html_url"].string  {
                        currentResponse.link = "\(link)"
                    }
                    
                    responses.append(currentResponse)
                    
                }
                
                for item in responses {
                    viewModelsPack.idStr = item.idStr
                    viewModelsPack.nameSrt = item.nameSrt
                    viewModelsPack.ownerStr = item.ownerStr
                    viewModelsPack.descriptionStr = item.descriptionStr
                    viewModelsPack.link = item.link
                    pageData.append(viewModelsPack)
                    
                }
                self.allReposData = pageData
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getDataSearch(query: String, page: Int) {
        let urlSearch = "https://api.github.com/search/repositories?q=\(query)&page=\(page)&per_page=15"

        AF.request(urlSearch, method: .get).responseDecodable(of: SearchResponse.self) { response in
            switch response.result {
            case .success(let value):
  
                self.searchData = value.items
                self.searchDataAll.append(contentsOf: self.searchData)
                
            case .failure(let error):
                
                print(error)
            }
            
            
        }
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
        if !text.isEmpty {
            allReposData.removeAll()
            
            currentQuery = text
            
            DispatchQueue.main.async {
                //first code
                self.getDataSearch(query: text, page: self.currentPage)
                print("currentPage First THREAD: \(self.currentPage)")
            }
            
            DispatchQueue.main.async {
                //second code
                self.currentPage += 1
                self.getDataSearch(query: text, page: self.currentPage)
                print("currentPage Second THREAD: \(self.currentPage)")
            }
          
        

        }
    
        print("Text search: \(text)")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDataAll.removeAll()
        currentPage = 1
    }
}

//MARK: Table View

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if !allReposData.isEmpty {
            return allReposData.count
        }
        else {
            return searchDataAll.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
            fatalError()
        }
        
        if !allReposData.isEmpty {
            guard let id = allReposData[indexPath.row].idStr,
                  let name = allReposData[indexPath.row].nameSrt,
                  let owner = allReposData[indexPath.row].ownerStr,
                  let description = allReposData[indexPath.row].descriptionStr else {
                      return UITableViewCell()
                  }
            cell.config(withId: id, name: name, owner: owner, andDescription: description)
        }
        else {
            let id = searchDataAll[indexPath.row].id
            let name = searchDataAll[indexPath.row].name
            let owner = searchDataAll[indexPath.row].owner.login
            let description = searchDataAll[indexPath.row].description ?? ""
            cell.config(withId: String(id), name: name, owner: owner, andDescription: description)
            
            
            // Reached last row load content
            if indexPath.row == self.searchDataAll.count - 1 {
                
                print("Query :\(currentQuery)")
                print("currentPage Before PAGINATION :\(currentPage)")
                
                DispatchQueue.main.async {
                    //first code
                    self.currentPage += 1
                    self.getDataSearch(query: self.currentQuery, page: self.currentPage)
                    print("currentPage PAGINATION first THREAD: \(self.currentPage)")
                }
                
                DispatchQueue.main.async {
                    //second code
                    self.currentPage += 1
                    self.getDataSearch(query: self.currentQuery, page: self.currentPage)
                    print("currentPage  PAGINATION Second THREAD: \(self.currentPage)")
                }
                
              }
            
            

        }
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        if !allReposData.isEmpty {
            let repoData = allReposData[indexPath.row]
            guard let url = URL(string: repoData.link ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        else {
            let repoData = searchDataAll[indexPath.row]
            guard let url = URL(string: repoData.html_url ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
        
    }
    
    
    
}
