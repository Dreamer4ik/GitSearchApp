//
//  Extension.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat{
        return frame.size.width
    }
    
    public var height: CGFloat{
        return frame.size.height
    }
    
    public var top: CGFloat{
        return frame.origin.y
    }
    
    public var bottom: CGFloat{
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat{
        return frame.origin.x
    }
    
    public var right: CGFloat{
        return frame.size.width + frame.origin.x
    }
}

extension UIViewController{
    // NavigationBar
    var navigationBarBottom: CGFloat {
        let height = self.navigationController?.navigationBar.frame.height ?? 0.0
        let originY = self.navigationController?.navigationBar.frame.origin.y ?? 0.0
        return  height + originY
        
    }
    
    // TabBar
    var tabBarTop: CGFloat  {
        let originY = tabBarController?.tabBar.frame.origin.y ?? 0.0
        return  originY
        
    }
}

/// Check have element in array
extension Array {
    func contains<T>(obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}

extension UITableView {
    
    func scrollToBottom(isAnimated:Bool = true){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }
    
    func scrollToTop(isAnimated:Bool = true) {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
            }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}

// Custom CheckMarkView
class CheckMarkView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let img = UIImage(systemName: "eye.fill")
        let imageView: UIImageView = UIImageView(image: img)
        imageView.tintColor = .gray

        imageView.frame = CGRect(x: 10, y: 70, width: 30, height: 20)
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
