module Lib where

import Control.Lens ((&), (.~))
import Data.ByteString.Lazy (ByteString)
import Data.Text (Text)
import Network.Wreq (Response, defaults, get, getWith, header, params)

api :: String
api = "https://www.speedrun.com/api"

type QueryKey = Text

type QueryValue = Text

newQuery :: [(QueryKey, QueryValue)] -> IO (Response ByteString)
newQuery queries =
  let opts =
        defaults
          & header "Accept" .~ ["application/json"]
          & header "User-Agent" .~ ["hSRcom_pre-alpha"]
          & params .~ queries
   in getWith opts api