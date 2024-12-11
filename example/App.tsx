import RnUrlResolver from "rn-url-resolver";
import { Alert, Button, SafeAreaView, ScrollView, Text } from "react-native";

const encodedURL = "";
const token = "";
export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView style={styles.container}>
        <Text style={styles.header}>Resolve URL</Text>
        <Text>Encoded URL: {encodedURL}</Text>
        <Button
          title="Get Url"
          onPress={async () => {
            try {
              const newUrl = await RnUrlResolver.resolveUrl({
                url: encodedURL,
                token,
              });
              Alert.alert("Resolved URL", newUrl);
            } catch (e) {
              Alert.alert("Error", e.message);
            }
          }}
        />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = {
  header: {
    fontSize: 30,
    margin: 20,
  },
  container: {
    flex: 1,
    backgroundColor: "#eee",
  },
};
