//
//  HomeViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    private let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search GitHub..."
        bar.layer.cornerRadius = 8
        bar.clipsToBounds = true
        bar.backgroundColor = .systemBackground
        return bar
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
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(searchBar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchBar.frame = CGRect(x: 20, y: view.top + 150, width: view.width - 40, height: 35)
    }
    
    
    
    ///Log out
    @objc private func didTapLogOut() {
        let sheet = UIAlertController(title: "Log out", message: "Are you sure you'd like to log out?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        let firebaseAuth = Auth.auth()
                        do {
                            try firebaseAuth.signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: %@", signOutError)
                        }
                        
                        let signInVc = LoginViewController()
                        let navVc = UINavigationController(rootViewController: signInVc)
                        navVc.modalPresentationStyle = .fullScreen
                        self?.present(navVc, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true, completion: nil)
    }
    
}

