{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Lib where

import Control.Lens ((&), (.~), (<>=), (<>~))
import Data.ByteString.Lazy (ByteString)
import Data.Text (Text)
import Network.URI (URI)
import Network.URI.Lens (uriPathLens)
import Network.URI.Static (uri)
import Network.Wreq (Response, defaults, getWith, header, params)

api :: URI
api = [uri|https://www.speedrun.com/api/v1|]

type QueryKeyValue = (Text, Text)

getSrc :: URI -> [QueryKeyValue] -> IO (Response ByteString)
getSrc uri queries =
  let opts =
        defaults
          & header "Accept" .~ ["application/json"]
          & header "User-Agent" .~ ["hSRcom_pre-alpha (https://bit.ly/hSRComGitHub)"]
          & params .~ queries
   in getWith opts $ show uri

type Id = String

newSrcUri :: (URI -> URI) -> URI
newSrcUri builder = builder api

uriBuilderAddPath :: URI -> String -> URI
uriBuilderAddPath base path = base & uriPathLens <>~ path

srcGames :: URI -> URI
srcGames base = uriBuilderAddPath base "/games"

withId :: String -> URI -> URI
withId id base = uriBuilderAddPath base $ mconcat ["/", id]

srcLeaderboards :: URI -> URI
srcLeaderboards base = uriBuilderAddPath base "/leaderboards"
