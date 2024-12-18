type NoLocationMatch = {
  redirectUntil?: "none";
  locationHeaderMatch?: never;
};
type EndLocationMatch = {
  redirectUntil: "end";
  locationHeaderMatch?: never;
};
type LocationMatch = {
  redirectUntil: "locationMatch";
  locationHeaderMatch: string;
};
export type RedirectUntilType =
  | NoLocationMatch
  | EndLocationMatch
  | LocationMatch;

export type ResolveUrlParams = {
  url: string;
  token?: string;
  allowReturnFromFailedUrl?: boolean;
  directlyReturnResponseUrl?: boolean;
  disableCache?: boolean;
} & RedirectUntilType;

export type RnUrlResolver = {
  resolveUrl(
    url: string,
    token?: string,
    allowReturnFromFailedUrl?: boolean,
    directlyReturnResponseUrl?: boolean,
    disableCache?: boolean,
    redirectUntil?: "none" | "end" | "locationMatch",
    locationHeaderMatch?: string
  ): Promise<string>;
};
