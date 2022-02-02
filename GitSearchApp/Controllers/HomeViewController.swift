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
    
    
    var allReposData = [ViewModelDataPack]()
    //    var searchData = [ViewModelDataPack]()
    
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
        
//        getData()
    
                getDataSearch()
        //        print("viewDidLoad allReposData element: \(allReposData)")
        print("viewDidLoad allReposData elements \(allReposData.count)")
        print("viewDidLoad allReposData isEmpty \(allReposData.isEmpty)")
        
    }
    
    struct Constants{
        static let gitHubLinkURL = URL(string: "https://api.github.com/")
        static let allPublicRepoLinkURL = URL(string: "https://api.github.com/repositories")
//        static let urlString = "https://api.github.com/repositories"
        
                static let urlString = "https://api.github.com/search/repositories?q=Blogapp&per_page=15"
        
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
    
            func getDataSearch() -> [Response]{
    
                var responses = [Response]()
                AF.request(Constants.urlString, method: .get).responseDecodable(of: SearchResponse.self, completionHandler: { response in
    
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
                        print(responses)
                        print(responses.count)
    
                        for item in responses {
    
                            viewModelsPack.idStr = item.idStr
                            viewModelsPack.nameSrt = item.nameSrt
                            viewModelsPack.ownerStr = item.ownerStr
                            viewModelsPack.descriptionStr = item.descriptionStr
                            viewModelsPack.link = item.link
    
                            pageData.append(viewModelsPack)
    
                        }
                        self.allReposData = pageData
                        self.tableView.reloadData()
    
                    case .failure(let error):
                        print(error)
                    }
                })
                return responses
            }
    
    
//    func getData() -> [Response]{
//
//        var responses = [Response]()
//        AF.request(Constants.urlString, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//
//                let json = JSON(value)
//
//                var pageData = [ViewModelDataPack]()
//                var viewModelsPack = ViewModelDataPack()
//
//                for index in 0...json.count {
//                    var currentResponse = Response()
//
//                    if let id = json[index]["id"].int {
//                        currentResponse.idStr = "\(id)"
//                    }
//
//                    if let name = json[index]["name"].string {
//                        currentResponse.nameSrt = "\(name)"
//                    }
//
//                    if let owner = json[index]["owner"]["login"].string {
//                        currentResponse.ownerStr = "\(owner)"
//                    }
//
//                    if let description = json[index]["description"].string {
//                        currentResponse.descriptionStr = "\(description)"
//                    }
//
//                    if let link = json[index]["html_url"].string  {
//                        currentResponse.link = "\(link)"
//                    }
//
//                    responses.append(currentResponse)
//
//                }
//
//                print(responses.count)
//
//                for item in responses {
//                    viewModelsPack.idStr = item.idStr
//                    viewModelsPack.nameSrt = item.nameSrt
//                    viewModelsPack.ownerStr = item.ownerStr
//                    viewModelsPack.descriptionStr = item.descriptionStr
//                    viewModelsPack.link = item.link
//                    pageData.append(viewModelsPack)
//
//                }
//                self.allReposData = pageData
//                self.tableView.reloadData()
//                print(self.allReposData)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        return responses
//    }
    
    
    
    
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
        
        //Add func with (query: text)
        
        
    }
}

//MARK: Table View

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allReposData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.identifier, for: indexPath) as? RepositoryCell else {
            fatalError()
        }
        
        guard let id = allReposData[indexPath.row].idStr,
              let name = allReposData[indexPath.row].nameSrt,
              let owner = allReposData[indexPath.row].ownerStr,
              let description = allReposData[indexPath.row].descriptionStr else {
                  return UITableViewCell()
              }
        
        
        cell.config(withId: id, name: name, owner: owner, andDescription: description )
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repoData = allReposData[indexPath.row]
        
        guard let url = URL(string: repoData.link ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    

    
}
