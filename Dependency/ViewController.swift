//
//  ViewController.swift
//  Dependency
//
//  Created by Pouya Yarandi on 3/11/24.
//

import UIKit
import Factory
import DomainLibrary

class ViewController: UIViewController {

    @Injected(\DomainLibrary_Container.domainLibrary) var domain

    override func viewDidLoad() {
        super.viewDidLoad()
        domain.doSomething()
    }

}
