import { requireNativeView } from 'expo';
import * as React from 'react';

import { RnUrlResolverViewProps } from './RnUrlResolver.types';

const NativeView: React.ComponentType<RnUrlResolverViewProps> =
  requireNativeView('RnUrlResolver');

export default function RnUrlResolverView(props: RnUrlResolverViewProps) {
  return <NativeView {...props} />;
}
