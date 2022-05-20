{-# LANGUAGE OverloadedStrings #-}

module Main where

import Control.Lens
import Data.Aeson (decode, decodeStrict, eitherDecodeStrict, encode)
import Data.Models
import Lib
import Network.Wreq (responseBody, responseStatus)
import System.IO (IOMode (WriteMode), hClose, hFlush, hPutStr, openFile)
import Testing (getTestJson)

-- http://www.serpentine.com/wreq/tutorial.html#interactive-usage

getTestGameQuery = do
  getTestJson

testOutJson :: String -> IO ()
testOutJson json = do
  h <- openFile "D:\\Haskell\\hSRCom\\jsonExport.json" WriteMode
  hPutStr h json
  hFlush h
  hClose h

main :: IO ()
main = do
  r <- newQuery [("game", "sm64")]
  let json = r ^. responseBody
  print json
  --let dec = eitherDecodeStrict json :: Either String Game
  --let enc = encode dec
  --testOutJson $ enc
  putStrLn "Done"
