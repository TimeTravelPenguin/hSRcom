{-# LANGUAGE DeriveGeneric #-}

module Data.Models where

import Data.Aeson
import Data.Aeson.Types
import Data.Char (toLower)
import qualified Data.Text as T
import GHC.Generics (Generic)

data Game = Game
  { gameId :: !T.Text,
    gameNames :: !GameNames,
    gameAbbreviation :: !T.Text,
    gameWebLink :: !T.Text,
    gameReleaseDate :: !T.Text,
    gameRuleSet :: !RuleSet,
    gameRomHack :: !Bool,
    -- TODO: gameGameTypes (can be Nil)
    gamePlatformIds :: ![T.Text],
    gameRegionIds :: ![T.Text],
    -- TODO: gameGenreIds (can be Nil)
    -- TODO: gameEngineIds (can be Nil)
    -- TODO: gameDeveloperIds (can be Nil)
    -- TODO: gamePublisherIds (can be Nil)
    gameModerators :: ![ModeratorMap],
    gameCreatedDateTime :: !T.Text,
    gameLinks :: ![Link]
  }
  deriving (Show, Eq, Generic)

-- Todo: Confirm this is a structured type. Else use Map for game names.
data GameNames = GameNames
  { gameNameInternational :: Maybe T.Text,
    gameNameJapanese :: Maybe T.Text,
    gameNameTwitch :: Maybe T.Text
  }
  deriving (Show, Eq, Generic)

data RuleSet = RuleSet
  { ruleShowMilliseconds :: !Bool,
    ruleRequireVerification :: !Bool,
    ruleRequireVideo :: !Bool,
    ruleRunTimes :: ![RunTimeType],
    ruleDefaultTime :: !RunTimeType,
    ruleEmulatorsAllowed :: !Bool
  }
  deriving (Show, Eq, Generic)

data RunTimeType
  = RealTime
  | RealTimeNoLoads
  | InGame
  deriving (Show, Eq, Generic)

data Platform = Platform
  { platformId :: !T.Text,
    platformName :: !T.Text,
    platformReleased :: !T.Text,
    platformLinks :: ![Link]
  }
  deriving (Show, Eq, Generic)

data Link = Link
  { linkRel :: !T.Text,
    linkUri :: !T.Text
  }
  deriving (Show, Eq, Generic)

data ModeratorRole
  = Moderator
  | SuperModerator
  deriving (Show, Eq, Generic)

data ModeratorMap = ModeratorMap
  { moderatorUserId :: !T.Text,
    moderatorRole :: !ModeratorRole
  }
  deriving (Show, Eq, Generic)

instance FromJSON Game where
  parseJSON = genericParseJSON $ buildJsonOptions "game"

instance ToJSON Game where
  toJSON = genericToJSON $ buildJsonOptions "game"

instance FromJSON GameNames where
  parseJSON = genericParseJSON $ buildJsonOptions "gameName"

instance ToJSON GameNames where
  toJSON = genericToJSON $ buildJsonOptions "gameName"

instance FromJSON RuleSet where
  parseJSON = genericParseJSON $ buildJsonOptions "rule"

instance ToJSON RuleSet where
  toJSON = genericToJSON $ buildJsonOptions "rule"

instance FromJSON RunTimeType

instance ToJSON RunTimeType

instance FromJSON Platform where
  parseJSON = genericParseJSON $ buildJsonOptions "platform"

instance ToJSON Platform where
  toJSON = genericToJSON $ buildJsonOptions "platform"

instance FromJSON Link where
  parseJSON = genericParseJSON $ buildJsonOptions "link"

instance ToJSON Link where
  toJSON = genericToJSON $ buildJsonOptions "link"

instance FromJSON ModeratorRole

instance ToJSON ModeratorRole

instance FromJSON ModeratorMap where
  parseJSON = genericParseJSON $ buildJsonOptions "moderator"

instance ToJSON ModeratorMap where
  toJSON = genericToJSON $ buildJsonOptions "moderator"

buildJsonOptions :: T.Text -> Options
buildJsonOptions prefix =
  let prefixLength = T.length prefix
      lowerCaseFst [] = []
      lowerCaseFst (x : xs) = toLower x : xs
   in defaultOptions {fieldLabelModifier = drop prefixLength . lowerCaseFst}

{-
instance ToJSON Game where
  toEncoding (Game gId gNames gAbbr) =
    pairs
      ( "id" .= gId
          <> "names" .= gNames
          <> "abbreviation" .= gAbbr
      )
-}
{-
instance FromJSON GameNames where
  parseJSON = withObject "GameName" $ \v ->
    GameNames <$> v .: "international"
      <*> v .: "japanese"
      <*> v .: "twitch"

instance ToJSON GameNames where
  toEncoding (GameNames int jap twitch) =
    pairs
      ( "international" .= int
          <> "japanese" .= jap
          <> "twitch" .= twitch
      )

instance FromJSON RuleSet

instance ToJSON RuleSet
-}
