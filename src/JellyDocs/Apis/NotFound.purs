module JellyDocs.Apis.NotFound where

import Prelude

import Affjax (AffjaxDriver, Error, get)
import Affjax.ResponseFormat (string)
import Data.Either (Either)
import Effect.Aff (Aff)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import JellyDocs.Apis.BasePath (apiBasePath)

getNotFoundMD :: AffjaxDriver -> Aff (Either Error String)
getNotFoundMD driver = map (map (_.body))
  $ get driver string
  $ apiBasePath <> makeRelativeFilePath [ "not-found.md" ]
