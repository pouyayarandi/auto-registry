import Factory
import MyLib_Wiring
import CoreLibrary_Wiring

func registerDependencies() {
    Container.shared.myLib.register { MyLib_Wiring.build() }
    Container.shared.core.register { CoreLibrary_Wiring.build() }
}
