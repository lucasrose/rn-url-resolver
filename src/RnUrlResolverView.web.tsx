import * as React from 'react';

import { RnUrlResolverViewProps } from './RnUrlResolver.types';

export default function RnUrlResolverView(props: RnUrlResolverViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
