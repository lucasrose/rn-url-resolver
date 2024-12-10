export type RnUrlResolver = {
  resolveUrl(url: string, token?: string): Promise<string>;
};
