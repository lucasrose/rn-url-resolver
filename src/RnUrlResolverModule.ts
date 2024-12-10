import { requireNativeModule } from "expo-modules-core";
import { RnUrlResolver } from "./RnUrlResolver.types";

// This call loads the native module object from the JSI.
const NativeModule = requireNativeModule<RnUrlResolver>("RnUrlResolver");

export default NativeModule;
