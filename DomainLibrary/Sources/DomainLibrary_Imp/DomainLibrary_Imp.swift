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
import ServiceMacro

@Implementation(DomainLibrary.self)
public struct DomainLibrary_Imp: DomainLibrary {

    @Injected(\CoreLibrary_Container.coreLibrary) var core

    public func doSomething() {
        print(core.text())
    }
}
