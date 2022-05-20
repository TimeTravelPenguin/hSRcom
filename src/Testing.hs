module Testing where

import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8 as C
import qualified Data.Text as T
import System.IO (IOMode (ReadMode), hClose, openFile)
import System.IO.Strict (hGetContents)

testJsonPath :: String
testJsonPath = "D:\\Haskell\\hSRCom\\test.json"

--getTestJson :: IO TL.ByteString
getTestJson = BS.readFile testJsonPath