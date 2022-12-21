import { Alert, Button, StyleSheet, View } from "react-native";
import {
  getBluetoothPermissionsAsync,
  requestBluetoothPermissionsAsync,
} from "expo-bluetooth-permissions";
import { useEffect } from "react";

export default function App() {
  useEffect(() => {
    getBluetoothPermissionsAsync().then((r) => {
      Alert.alert(
        r.status === "granted" && r.granted
          ? "Permission Granted!"
          : "Permission Denied"
      );
    });
  }, []);

  return (
    <View style={styles.container}>
      <Button
        title="Request Permission"
        onPress={() => {
          requestBluetoothPermissionsAsync().then((r) => {
            Alert.alert(
              r.status === "granted" && r.granted
                ? "Permission Granted!"
                : "Permission Denied"
            );
          });
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#aaa",
    alignItems: "center",
    justifyContent: "center",
  },
});
