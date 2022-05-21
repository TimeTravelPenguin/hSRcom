{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Arrow ((>>>))
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
import Network.Wreq (Response, asJSON, responseBody, responseStatus)
import System.Console.ANSI
import System.IO (IOMode (WriteMode), hClose, hFlush, hPutStr, openFile)

-- http://www.serpentine.com/wreq/tutorial.html#interactive-usage

outJson :: BSL.ByteString -> IO ()
outJson json = do
  h <- openFile "D:\\Haskell\\hSRCom\\jsonExport.json" WriteMode
  TIO.hPutStr h $ TLE.decodeUtf8 json
  hFlush h
  hClose h

printRed :: Show a => a -> IO ()
printRed msg = do
  setSGR [SetColor Foreground Dull Red]
  putStrLn ""
  print msg
  putStrLn ""
  setSGR [Reset]

showResponse :: Response BSL.ByteString -> IO ()
showResponse response = do
  let body = response ^. responseBody -- . key "data" . _String
  printRed body
  outJson body

getData :: IO (Response BSL.ByteString)
getData = do
  let uri = newSrcUri $ srcGames >>> withId "smo"
  let params = []
  printRed uri
  getSrc uri params

main :: IO ()
main = do
  r <- getData
  showResponse r
  {-let dec = eitherDecode json -- :: Either String Game
  let enc = encode dec
  testOutJson $ TLE.decodeUtf8 enc-}
  putStrLn "Done"
