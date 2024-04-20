// Generated using Sourcery 2.1.8 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import CoreLibrary_Imp
import DomainLibrary_Imp

public struct Registry {
  public static func registerServices() {
    CoreLibrary_Imp_Registry.register()
    DomainLibrary_Imp_Registry.register()
  }
}
