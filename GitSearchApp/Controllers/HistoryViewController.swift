//
//  HistoryViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit

class HistoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = barAppearance
        
        view.backgroundColor = .systemBlue
        title = "History"
    }
    
    
    
    
}
