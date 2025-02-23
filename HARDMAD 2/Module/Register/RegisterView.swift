//
//  RegisterView.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//

import Foundation


import UIKit

class RegisterController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        let gradientView = AnimatedGradientView(frame: view.bounds)
        view.addSubview(gradientView)
    }
}



//Family: Gwen-Trial Font names: ["Gwen-Trial-Bold"]
