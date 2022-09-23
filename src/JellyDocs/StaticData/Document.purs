module JellyDocs.StaticData.Document where

import Prelude

import Effect.Aff (Aff)
import Jelly.Router.Data.Url (makeRelativeFilePath)
import JellyDocs.Documents (Documents, documentToDocsPath)
import Node.Encoding (Encoding(..))
import Node.FS.Aff (readTextFile)

documentStaticData :: Documents -> Aff String
documentStaticData doc = do
  readTextFile UTF8 $ (makeRelativeFilePath $ documentToDocsPath doc)
