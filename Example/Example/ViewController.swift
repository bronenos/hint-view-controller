//
//  ViewController.swift
//  Example
//
//  Created by Stan Potemkin on 09/01/2017.
//  Copyright © 2017 Boloid. All rights reserved.
//

import UIKit
import HBHintViewController

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [unowned self] in self.presentHint() }
    }
    
    private func presentHint() {
        let viewController = HBHintViewController()
        
        viewController.addHole(type: .ellipse) { size in
            return CGRect(x: 10, y: 200, width: 40, height: 40)
        }
        
        viewController.addHole(type: .ellipse) { size in
            return CGRect(x: 60, y: 100, width: 40, height: 40)
        }
        
        let helloText = NSAttributedString(string: "Hello", font: UIFont.boldSystemFont(ofSize: 20))
        viewController.addHint(text: helloText) { size in
            let width: CGFloat = 150
            return CGRect(x: (size.width - width) * 0.5, y: 150, width: width, height: 80)
        }
        
        self.present(viewController, animated: true, completion: nil)
    }
}

fileprivate extension NSAttributedString {
    convenience init(string: String, font: UIFont) {
        self.init(string: string, attributes: [NSFontAttributeName: font])
    }
}
