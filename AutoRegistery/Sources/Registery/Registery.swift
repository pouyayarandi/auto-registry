// hash_957ff496c47cb596a74ac652ef58ef86add129d7e2e97ed0631b846667f917e1
//
// AUTO-GENERATED, Please don't change this file manually
// If you want to regenerate this file, run AutoRegistery
// command plugin.

import Factory
import DomainLibrary_Imp
import CoreLibrary_Imp

public struct Registry {
  public static func registerServices() {
    DomainLibrary_Imp_Registry.register()
    CoreLibrary_Imp_Registry.register()
  }
}
