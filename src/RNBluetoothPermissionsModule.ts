import { requireNativeModule } from "expo-modules-core";

// It loads the native module object from the JSI or falls back to
// the bridge module (from NativeModulesProxy) if the remote debugger is on.
const RNBluetoothPermissions = requireNativeModule("RNBluetoothPermissions");

export enum PermissionStatus {
  /**
   * User has granted the permission.
   */
  GRANTED = "granted",
  /**
   * User hasn't granted or denied the permission yet.
   */
  UNDETERMINED = "undetermined",
  /**
   * User has denied the permission.
   */
  DENIED = "denied",
}

interface ResponseType {
  status: PermissionStatus;
  granted: boolean;
  canAskAgain: boolean;
  expires: "never" | number;
}

export async function getBluetoothPermissionsAsync(): Promise<ResponseType> {
  return await RNBluetoothPermissions.getBluetoothPermissionsAsync();
}

export async function requestBluetoothPermissionsAsync(): Promise<ResponseType> {
  return await RNBluetoothPermissions.requestBluetoothPermissionsAsync();
}
