//
//  DispatchViewController.swift
//  Legato
//
//  Created by Luis Burgos on 7/23/18.
//  Copyright © 2018 Yellowme. All rights reserved.
//

import UIKit

class DispatchViewController: UIViewController, DispatchView {    
    var presenter: DispatchViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        presenter = DispatchPresenter(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.decideUserMainScreen()
    }
    
    func reload() {
        presenter.decideUserMainScreen()
    }
    
    func setProgress(active: Bool) {
        debugPrint("Progress is active: \(active)")
    }
    
    func sendToMain() {
        Nemo.go(to: .main)
    }
    
    func sendToLogin() {
        Nemo.go(to: .login)
    }
    
    func sendToError() {
        Nemo.go(to: .error)
    }
}
