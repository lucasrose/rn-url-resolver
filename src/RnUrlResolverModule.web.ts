import { registerWebModule, NativeModule } from 'expo';

import { RnUrlResolverModuleEvents } from './RnUrlResolver.types';

class RnUrlResolverModule extends NativeModule<RnUrlResolverModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(RnUrlResolverModule);
