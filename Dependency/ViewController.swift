//
//  ViewController.swift
//  Dependency
//
//  Created by Pouya Yarandi on 3/11/24.
//

import UIKit
import Factory
import MyLibrary

class ViewController: UIViewController {

    @Injected(\.MyLib) var myLib

    override func viewDidLoad() {
        super.viewDidLoad()
        myLib.print()
    }

}
