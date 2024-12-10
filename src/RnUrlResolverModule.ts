import { NativeModule, requireNativeModule } from 'expo';

import { RnUrlResolverModuleEvents } from './RnUrlResolver.types';

declare class RnUrlResolverModule extends NativeModule<RnUrlResolverModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<RnUrlResolverModule>('RnUrlResolver');
