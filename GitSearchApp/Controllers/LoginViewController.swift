//
//  LoginViewController.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import UIKit


class LoginViewController: UIViewController {
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    private let loginButton: UIButton =  {
        let button = UIButton()
        button.setTitle("Sign in with GitHub", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(loginButton)
        view.addSubview(imageView)
        
        
        loginButton.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = view.width/3
        
        loginButton.frame = CGRect(
            x: 30 ,
            y: view.bottom - 120,
            width: view.width - 60,
            height: 50
        )
        imageView.frame = CGRect(
            x: (view.width - size)/2,
            y: loginButton.top - 450,
            width: size,
            height: size
        )
        
    }
    
    
    @objc private func didTapLogIn() {
        UserDefaults.standard.setValue(true, forKey: "LogIn")
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
