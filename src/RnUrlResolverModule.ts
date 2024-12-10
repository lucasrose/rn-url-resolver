import { NativeModule, requireNativeModule } from "expo";
import { RnUrlResolverType } from "./RnUrlResolver.types";

declare class RnUrlResolverModule extends NativeModule<RnUrlResolverType> {
  resolveUrl(url: string, token?: string): Promise<string>;
}
// This call loads the native module object from the JSI.
const RnResolver = requireNativeModule<RnUrlResolverModule>("RnUrlResolver");

export default {
  resolveUrl: async (url: string, token?: string): Promise<string> => {
    return await RnResolver.resolveUrl(url, token);
  },
} as RnUrlResolverType;
