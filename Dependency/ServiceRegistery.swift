import Factory
import MyLib_Wiring
import CoreLibrary_Wiring

extension Container {
    func registerDependencies() {
        myLib.register(factory: MyLib_Wiring.build)
        coreLibrary.register(factory: CoreLibrary_Wiring.build)
    }
}
