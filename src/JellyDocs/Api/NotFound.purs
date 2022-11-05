module JellyDocs.Api.NotFound where

import Prelude

import Affjax (AffjaxDriver, Error, get)
import Affjax.ResponseFormat (string)
import Data.Either (Either)
import Effect.Aff (Aff)
import JellyDocs.Api.BasePath (apiBasePath)

getNotFoundMD :: AffjaxDriver -> Aff (Either Error String)
getNotFoundMD driver = map (map (_.body))
  $ get driver string
  $ apiBasePath <> "not-found.md"
