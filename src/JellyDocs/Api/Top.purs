module JellyDocs.Api.Top where

import Prelude

import Affjax (AffjaxDriver, Error, get)
import Affjax.ResponseFormat (string)
import Data.Either (Either)
import Effect.Aff (Aff)
import JellyDocs.Api.BasePath (apiBasePath)

getTopMD :: AffjaxDriver -> Aff (Either Error String)
getTopMD driver = map (map (_.body))
  $ get driver string
  $ apiBasePath <> "overview.md"
