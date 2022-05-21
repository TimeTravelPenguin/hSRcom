{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Control.Lens ((&), (.~))
import Data.ByteString.Lazy (ByteString)
import Data.Text (Text)
import Network.Wreq (Response, asJSON, defaults, get, getWith, header, params)

api :: String
api = "https://www.speedrun.com/api/v1"

type ParamKey = Text

type ParamValue = Text

type ParamKvp = (ParamKey, ParamValue)

newQuery :: String -> [ParamKvp] -> IO (Response ByteString)
newQuery uri paramKvps =
  let opts =
        defaults
          & header "Accept" .~ ["application/json"]
          & header "User-Agent" .~ ["hSRcom_pre-alpha"]
          & params .~ paramKvps
   in getWith opts uri

class Uri a where
  uriToString :: a -> String

data GamesDerivative
  = Categories
  | Levels
  | Variables
  | DerivedGames
  | Records

instance Uri GamesDerivative where
  uriToString Categories = "/categories"
  uriToString Levels = "/levels"
  uriToString Variables = "/variables"
  uriToString DerivedGames = "/derived-games"
  uriToString Records = "/records"

type GameId = String

type LevelId = String

type CategoryId = String

data GamesUri
  = AllGames
  | GamesId GameId
  | GamesBy GameId GamesDerivative

instance Uri GamesUri where
  uriToString AllGames = "/games"
  uriToString (GamesId id) = mconcat ["/games/", id]
  uriToString (GamesBy id derivative) = mconcat ["/games/", id, uriToString derivative]

data LeaderboardParam
  = Category CategoryId
  | LevelCategory LevelId CategoryId

instance Uri LeaderboardParam where
  uriToString (Category catId) = mconcat ["/category/", catId]
  uriToString (LevelCategory levelId catId) = mconcat ["/level/", levelId, "/", catId]

data Leaderboards
  = Leaderboard GameId LeaderboardParam

instance Uri Leaderboards where
  uriToString (Leaderboard gameId lbParam) = mconcat ["/leaderboards/", gameId, uriToString lbParam]

getResource :: Uri a => a -> [ParamKvp] -> IO (Response ByteString)
getResource uri = newQuery $ api <> uriToString uri