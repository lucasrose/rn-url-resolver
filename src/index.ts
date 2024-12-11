// Reexport the native module. On web, it will be resolved to RnUrlResolverModule.web.ts
// and on native platforms to RnUrlResolverModule.ts
import RnUrlResolverModule from "./RnUrlResolverModule";
import { ResolveUrlParams } from "./RnUrlResolver.types";

export default {
  /**
   * Type definition for the RnUrlResolver module.
   * This module provides functionality to resolve a URL by following redirects.
   *
   * @typedef {Object} RnUrlResolverType
   *
   * @property {Function} resolveUrl - Resolves a URL by following its redirects.
   *
   * @param {string} url - The URL to resolve.
   * @param {string} [token] - Optional authorization token to be included in the request headers.
   * @param {boolean} [allowReturnFromFailedUrl] - Optionally allow returning the URL from failed redirects. Defaults to false. iOS only.
   *
   * @returns {Promise<string>} A promise that resolves with the final resolved URL as a string.
   *
   * @example
   * const url = "https://example.com/redirect";
   * const token = "your-auth-token";
   *
   * resolveUrl(url, token)
   *   .then(resolvedUrl => {
   *     console.log(resolvedUrl); // The final resolved URL after redirects
   *   })
   *   .catch(error => {
   *     console.error(error); // Handles any errors that occur during resolution
   *   });
   */
  resolveUrl: async ({
    url,
    token,
    allowReturnFromFailedUrl = false,
  }: ResolveUrlParams): Promise<string> => {
    return await RnUrlResolverModule.resolveUrl(
      url,
      token,
      allowReturnFromFailedUrl
    );
  },
};
