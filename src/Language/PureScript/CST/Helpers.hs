module Language.PureScript.CST.Helpers where

import Language.PureScript.CST as CST
import qualified Data.ByteString.Lazy as LazyByteString
import qualified Data.Text.Encoding as Encoding
import System.IO (FilePath)
import qualified Data.Aeson as A



parseFileContentAndGetJSON :: FilePath -> IO ()
parseFileContentAndGetJSON filePath = do
  content <- LazyByteString.readFile filePath
  let body = Encoding.decodeUtf8 $ LazyByteString.toStrict content
      (_warnings, eitherParsed) = parse body

  print ("Decode File Content - " <> unpack body)
  case eitherParsed of
    Right mod -> do
      let jsonOutput = map A.toJSON [mod]
      LazyByteString.writeFile "output.json" (A.encode jsonOutput)
    Left e -> do
      print "Parse Error"
      print (show e)