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
import RealmSwift

class HomeViewController: UIViewController {
    static let shared = HomeViewController()
    
    private var currentPage = 1
    private var total = 0
    private var isFetchInProgress = false
    private var currentQuery: String = ""
    private let chooseFilterAction = ["From high rate stars to low", "From low  rate stars to high"]
    private var selectedRow = 0
    private let screenWidth = UIScreen.main.bounds.width - 10
    private let screenHeight = UIScreen.main.bounds.height / 2
    private var viewedData = [RepositoryInfo]()
    private var saveId: [Int] = []
    
    //MARK: REALM
    var currentItem: RepositoryRealm?
    
    
    
    
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
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.isHidden = true
        return button
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
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        
        searchBar.delegate = self
        setUpTableView()
        addSubviews()
        getData()
        
        
        //MARK: REALM
        let path = DatabaseManager.shared.database.configuration.fileURL?.path
        print("Realm Path: \(String(describing: path))")
        
        print("PRINT REALM OBJ: --- \(DatabaseManager.shared.getDataFromDB())")
        
        print("PRINT REALM ID1 : \(DatabaseManager.shared.getIdFromDB())")
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(filterButton)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(
            x: 20,
            y: view.top + 150,
            width: view.width - 40,
            height: 35
        )
        tableView.frame = CGRect(
            x: 0,
            y: searchBar.bottom + 10,
            width: view.width,
            height: view.height
        )
        filterButton.frame = CGRect(
            x: view.frame.width - 88,
            y: view.frame.height - 88 - view.safeAreaInsets.bottom,
            width: 60,
            height: 60
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
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
                self.searchDataAll.sort {
                    $0.stargazers_count > $1.stargazers_count
                }
                self.tableView.scrollToTop()
                
                print("selected From high rate stars to low" )
            }
            if selected.contains("From low  rate stars to high"){
                self.searchDataAll.sort {
                    $0.stargazers_count < $1.stargazers_count
                }
                self.tableView.scrollToTop()
                print("selected From low  rate stars to high" )
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
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
            filterButton.isHidden = false
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
            
            cell.accessoryView = CheckMarkView.init()
            // Check repo id viewed or not
            if DatabaseManager.shared.getIdFromDB().contains(obj: Int(id)) {
                cell.accessoryView?.isHidden = false
            }else {
                cell.accessoryView?.isHidden = true
            }
            
            cell.config(withId: id, name: name, owner: owner, andDescription: description)
        }
        else {
            let id = searchDataAll[indexPath.row].id
            let name = searchDataAll[indexPath.row].name
            let owner = searchDataAll[indexPath.row].owner.login
            let description = searchDataAll[indexPath.row].description ?? ""
            let stargazersCount = searchDataAll[indexPath.row].stargazers_count
            print("stargazersCount:\(stargazersCount)")
            
            cell.accessoryView = CheckMarkView.init()
            
            
            // Check repo id viewed or not
            if DatabaseManager.shared.getIdFromDB().contains(obj: id) {
                cell.accessoryView?.isHidden = false
            }else {
                cell.accessoryView?.isHidden = true
            }
            
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
        
        //Delete all checkmark
        //        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
        //            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
        //                cell.accessoryType = row == indexPath.row ? .checkmark : .none
        //            }
        //        }
        
        
        // add Dispatch ?
        if !allReposData.isEmpty {
            
            let repoData = allReposData[indexPath.row]
            
            tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
            
            guard let url = URL(string: repoData.link ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
            
            let item = RepositoryRealm()
            item.id = Int(repoData.idStr) ?? -1
            item.name = repoData.nameSrt
            item.owner = repoData.ownerStr
            item.descriptionRepo = repoData.descriptionStr
            item.html_url = repoData.link
//            item.stargazers_count = repoData.star
            //  Check if exist ID repo
            if !DatabaseManager.shared.getIdFromDB().contains(obj: item.id) {
                
                DatabaseManager.shared.addData(object: item)
                print("Update DATE: \(item.updated)")
                
            }
        }
        else {
            let repoData = searchDataAll[indexPath.row]
            
            tableView.cellForRow(at: indexPath)?.accessoryView?.isHidden = false
            guard let url = URL(string: repoData.html_url ?? "") else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            viewedData.insert(repoData, at: 0)
            saveId.append(repoData.id)
            
           
        
            //Realm
            let item = RepositoryRealm()
            item.id = repoData.id
            item.name = repoData.name
            item.owner = repoData.owner.login
            item.descriptionRepo = repoData.description
            item.html_url = repoData.html_url
            item.stargazers_count = repoData.stargazers_count
            //  Check if exist ID repo
            if !DatabaseManager.shared.getIdFromDB().contains(obj: item.id) {
                
                DatabaseManager.shared.addData(object: item)
                print("Update DATE: \(item.updated)")
                
            }
            
            
            print("PRINT REALM OBJ2: --- \(DatabaseManager.shared.getDataFromDB())")
            print("PRINT REALM ID2 : \(DatabaseManager.shared.getIdFromDB())")
        }
        
    }
    
    
    
}

//MARK: Picker
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
