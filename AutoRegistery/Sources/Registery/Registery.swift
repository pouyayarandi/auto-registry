// hash_957ff496c47cb596a74ac652ef58ef86add129d7e2e97ed0631b846667f917e1
//
// AUTO-GENERATED, Please don't change this file manually
// If you want to regenerate this file, run AutoRegistery
// command plugin.

import Factory
import DomainLibrary_Wiring
import CoreLibrary_Wiring

extension Container {
  public func registerDependencies() {
    domainLibrary.register(factory: DomainLibrary_Wiring.build)
    coreLibrary.register(factory: CoreLibrary_Wiring.build)
  }
}
