//
//  HistoryViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit

class HistoryViewController: UIViewController {
    
    private let chooseFilterAction = ["From high rate stars to low", "From low  rate stars to high"]
    var selectedRow = 0
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    
    
    
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
        
        view.backgroundColor = .systemBlue
        title = "History"
        
        filterButton.addTarget(self, action: #selector(didTapFilter), for: .touchUpInside)
        addSubviews()
    }
    
    
    private func addSubviews() {
        view.addSubview(filterButton)
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
