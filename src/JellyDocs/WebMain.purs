module JellyDocs.WebMain where

import Prelude

import Affjax.Web (driver)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly (awaitDocument, hydrate_)
import Jelly.Router (newRouter, provideRouter)
import JellyDocs.Contexts.Apis (newApis, provideApis)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.RootComponent (rootComponent)

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument

  -- Make Apis Store
  apis <- liftEffect $ newApis driver

  let
    beforeEach url = do
      -- Load Page Data
      case urlToPage url of
        PageDoc docId -> void $ apis.doc.initialize docId
        PageTop -> void $ apis.top.initialize
        PageNotFound -> void $ apis.notFound.initialize
      pure url

  -- Make Router
  router <- newRouter [] beforeEach

  -- Make Context
  let
    context = provideApis apis $ provideRouter router {}

  -- Run App
  liftEffect $ hydrate_ context rootComponent d
