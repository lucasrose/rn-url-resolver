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
export type RnUrlResolverType = {
  resolveUrl(url: string, token?: string): Promise<string>;
};
