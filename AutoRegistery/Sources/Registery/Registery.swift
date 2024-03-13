// hash_778ffbb97c665a6a0a9298e22f09c4881495db79b99255be22c5bb690598e502
//
// AUTO-GENERATED, Please don't change this file manually
// If you want to regenerate this file, run AutoRegistery
// command plugin.

import Factory
import MyLib_Wiring
import CoreLibrary_Wiring

extension Container {
  public func registerDependencies() {
    MyLib.register(factory: MyLib_Wiring.build)
    CoreLibrary.register(factory: CoreLibrary_Wiring.build)
  }
}
