// AUTO-GENERATED, Please don't change it manually
import Factory
import MyLib_Wiring
import CoreLibrary_Wiring
extension Container {
    func registerDependencies() {
        MyLib.register(factory: MyLib_Wiring.build)
        CoreLibrary.register(factory: CoreLibrary_Wiring.build)
    }
}
