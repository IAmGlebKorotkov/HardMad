//
//  File.swift
//  HARDMAD 2
//
//  Created by Gleb Korotkov on 21.02.2025.
//
import UIKit

class JournalController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientView = CircularGradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gradientView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gradientView.widthAnchor.constraint(equalToConstant: 364),
            gradientView.heightAnchor.constraint(equalToConstant: 364)
        ])
    }
}
