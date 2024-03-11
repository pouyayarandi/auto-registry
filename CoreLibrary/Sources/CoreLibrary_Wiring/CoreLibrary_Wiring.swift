//
//  File.swift
//  
//
//  Created by Pouya Yarandi on 3/11/24.
//

import CoreLibrary
import CoreLibrary_Imp

public struct CoreLibrary_Wiring {
    public static func build() -> CoreLibrary {
        CoreLibraryImp()
    }
}
