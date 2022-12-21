import ExpoModulesCore
import CoreBluetooth

enum BluetoothConnectionType {
  case central, peripheral
}

func isBluetoothAuthorized(forType type: BluetoothConnectionType) -> Bool {
  switch type {
  case .central:
    if #available(iOS 13.1, *) {
      return CBCentralManager.authorization == .allowedAlways
    }
    if #available(iOS 13.0, *) {
      return CBCentralManager().authorization == .allowedAlways
    }

    return true
  case .peripheral:
    if #available(iOS 13.1, *) {
      return CBPeripheralManager.authorization == .allowedAlways
    }
    if #available(iOS 13.0, *) {
      return CBPeripheralManager.authorizationStatus() == .authorized
    }
    return true
  }
}

public class DummyBluetooth: NSObject, CBCentralManagerDelegate {
  public func centralManagerDidUpdateState(_ central: CBCentralManager) {
  }
}

public class RNBluetoothPermissionsModule: Module {
	static let GRANTED = "granted";
	static let UNDETERMINED = "undetermined";
	static let DENIED = "denied";


	// Each module class must implement the definition function. The definition consists of components
	// that describes the module's functionality and behavior.
	// See https://docs.expo.dev/modules/module-api for more details about available components.
	public func definition() -> ModuleDefinition {
		// Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
		// Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
		// The module will be accessible from `requireNativeModule('RNBluetoothPermissions')` in JavaScript.
		Name("RNBluetoothPermissions")


		AsyncFunction("getBluetoothPermissionsAsync") { (promise: Promise) in
			DispatchQueue.main.asyncAfter(deadline: .now()) {
        let granted = isBluetoothAuthorized(forType: .central) && isBluetoothAuthorized(forType: .peripheral)

				promise.resolve([
          "status": granted ? RNBluetoothPermissionsModule.GRANTED : RNBluetoothPermissionsModule.DENIED,
					"granted": granted,
					"expires": "never",
					"canAskAgain": false
				])
			}
		}
		
		AsyncFunction("requestBluetoothPermissionsAsync") { (promise: Promise) in
			DispatchQueue.main.asyncAfter(deadline: .now()) {
        let dummy = DummyBluetooth()
        let manager = CBCentralManager(delegate: dummy, queue: nil)
        manager.scanForPeripherals(withServices: [CBUUID.init(string: "DFB0")], options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          manager.stopScan()

          let granted = isBluetoothAuthorized(forType: .central) && isBluetoothAuthorized(forType: .peripheral)

          promise.resolve([
            "status": granted ? RNBluetoothPermissionsModule.GRANTED : RNBluetoothPermissionsModule.DENIED,
            "granted": granted,
            "expires": "never",
            "canAskAgain": true
          ])
        }

			}
		}
	}
}
