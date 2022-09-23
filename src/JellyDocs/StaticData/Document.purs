module JellyDocs.StaticData.Document where

import Prelude

import Effect.Aff (Aff)
import Jelly.Router.Data.Url (makeRelativeFilePath)
import JellyDocs.Documents (Documents, documentToPath)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

documentStaticData :: Documents -> Aff String
documentStaticData doc = do
  readTextFile UTF8 $ (makeRelativeFilePath $ [ "docs" ] <> documentToPath doc) <> ".md"
