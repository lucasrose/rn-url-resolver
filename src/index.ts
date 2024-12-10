// Reexport the native module. On web, it will be resolved to RnUrlResolverModule.web.ts
// and on native platforms to RnUrlResolverModule.ts
export { default } from './RnUrlResolverModule';
export { default as RnUrlResolverView } from './RnUrlResolverView';
export * from  './RnUrlResolver.types';
