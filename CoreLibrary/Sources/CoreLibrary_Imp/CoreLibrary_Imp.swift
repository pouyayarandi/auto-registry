//
//  File.swift
//  
//
//  Created by Pouya Yarandi on 3/11/24.
//

import Foundation
import CoreLibrary
import ServiceMacro

@Implementation(CoreLibrary.self)
private struct CoreLibrary_Imp: CoreLibrary {
    public func text() -> String {
        "Hello World!"
    }
}
