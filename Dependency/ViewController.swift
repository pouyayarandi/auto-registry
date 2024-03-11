//
//  ViewController.swift
//  Dependency
//
//  Created by Pouya Yarandi on 3/11/24.
//

import UIKit
import Factory

class ViewController: UIViewController {

    @Injected(\.myLib) var myLib

    override func viewDidLoad() {
        super.viewDidLoad()
        myLib.print()
    }

}
