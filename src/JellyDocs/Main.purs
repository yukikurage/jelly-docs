module JellyDocs.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Jelly.SSG.Data.GeneratorConfig (GeneratorConfig)
import Jelly.SSG.Generator (generate)
import JellyDocs.ClientMain (clientConfig)
import JellyDocs.Context (Context)
import JellyDocs.Documents (allDocuments)
import JellyDocs.Page (Page(..))
import JellyDocs.StaticData.Document (documentStaticData)
import JellyDocs.StaticData.NotFound (notFoundStaticData)
import JellyDocs.StaticData.Top (topStaticData)
import Record (union)

main :: Effect Unit
main = launchAff_ $ generate generatorConfig

generatorConfig :: GeneratorConfig Context Page
generatorConfig = union clientConfig
  { pageStaticData: case _ of
      PageTop -> topStaticData
      PageDocument documentId -> documentStaticData documentId
      PageNotFound -> notFoundStaticData
  , getPages: pure $ map PageDocument allDocuments <> [ PageNotFound ] <> [ PageTop ]
  , clientMain: "JellyDocs.ClientMain"
  , output: [ "public" ]
  }
