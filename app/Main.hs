{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Aeson
import Data.Aeson.Lens (key, _String)
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BSL
import Data.Models
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TLE
import qualified Data.Text.Lazy.IO as TIO
import Lib
import Network.Wreq (asJSON, responseBody, responseStatus, Response)
import System.IO (IOMode (WriteMode), hClose, hFlush, hPutStr, openFile)
import System.Console.ANSI
import Lib (getResource, GamesUri (GamesId))

-- http://www.serpentine.com/wreq/tutorial.html#interactive-usage

testOutJson :: BSL.ByteString -> IO ()
testOutJson !json = do
  h <- openFile "D:\\Haskell\\hSRCom\\jsonExport.json" WriteMode
  TIO.hPutStr h $ TLE.decodeUtf8 json
  hFlush h
  hClose h

--showResponse :: Response a -> IO ()
showResponse :: Response BSL.ByteString -> IO ()
showResponse response = do
  setSGR [SetColor Foreground Dull Red]
  let body = response ^. responseBody -- . key "data" . _String
  print body
  setSGR [Reset]
  testOutJson body

main :: IO ()
main = do
  --r <- gameQuery [("name", "sm64")]
  r <- getResource (GamesId "sm64") []
  showResponse r
  {-let dec = eitherDecode json -- :: Either String Game
  let enc = encode dec
  testOutJson $ TLE.decodeUtf8 enc-}
  putStrLn "Done"
