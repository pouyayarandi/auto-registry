//
//  File.swift
//  
//
//  Created by Pouya Yarandi on 3/13/24.
//

import Foundation
import DomainLibrary
import Factory
import CoreLibrary

public struct DomainLibrary_Imp: DomainLibrary {

    public init() {}

    @Injected(\.CoreLibrary) var core

    public func doSomething() {
        print(core.text())
    }
}
