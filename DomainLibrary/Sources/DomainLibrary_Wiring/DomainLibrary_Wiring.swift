//
//  File.swift
//  
//
//  Created by Pouya Yarandi on 3/13/24.
//

import DomainLibrary
import DomainLibrary_Imp

public struct DomainLibrary_Wiring {
    public static func build() -> DomainLibrary {
        DomainLibrary_Imp()
    }
}
