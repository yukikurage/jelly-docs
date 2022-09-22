module JellyDocs.GeneratorConfig where

import Prelude

import Jelly.SSG.Data.GeneratorConfig (GeneratorConfig)
import JellyDocs.Context (Context)
import JellyDocs.Documents (documentIds)
import JellyDocs.Page (Page(..), pageToUrl, urlToPage)
import JellyDocs.Pages.Document (documentPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.RootComponent (rootComponent)
import JellyDocs.StaticData.Document (documentStaticData)

generatorConfig :: GeneratorConfig Context Page
generatorConfig =
  { basePath: []
  , rootComponent
  , pageToUrl
  , urlToPage
  , pageComponent: case _ of
      PageDocument _ -> documentPage
      PageNotFound -> notFoundPage
  , pageStaticData: case _ of
      PageDocument documentId -> documentStaticData documentId
      PageNotFound -> pure ""
  , getPages: pure $ map PageDocument documentIds <> [ PageNotFound ]
  , clientMain: "JellyDocs.ClientMain"
  , output: [ "public" ]
  }
