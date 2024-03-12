// AUTO-GENERATED, Please don't change this file manually
import Factory
import MyLib_Wiring
import CoreLibrary_Wiring
extension Container {
    public func registerDependencies() {
        MyLib.register(factory: MyLib_Wiring.build)
        CoreLibrary.register(factory: CoreLibrary_Wiring.build)
    }
}
