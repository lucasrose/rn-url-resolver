export type ResolveUrlParams = {
  url: string;
  token?: string;
  allowReturnFromFailedUrl?: boolean;
};
export type RnUrlResolver = {
  resolveUrl(
    url: string,
    token?: string,
    allowReturnFromFailedUrl?: boolean
  ): Promise<string>;
};
