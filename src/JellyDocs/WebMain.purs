module JellyDocs.WebMain where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Aff (awaitDocument)
import Jelly.Hydrate (hydrate_)
import Jelly.Router.Data.Router (newRouter, provideRouterContext)
import JellyDocs.Contexts.Apis (provideApisContext)
import JellyDocs.Contexts.Apis.Web (newWebApis)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.RootComponent (rootComponent)

main :: Effect Unit
main = launchAff_ do
  -- Await Document
  d <- awaitDocument

  apis <- liftEffect newWebApis

  let
    beforeEach url = do
      case urlToPage url of
        PageDoc docId -> void $ apis.doc.refetch docId
        PageTop -> void $ apis.top.refetch
        PageNotFound -> void $ apis.notFound.refetch
      pure url

  -- Make Router
  router <- newRouter [] beforeEach

  let
    context = provideRouterContext router $ provideApisContext apis {}

  -- Run App
  liftEffect $ hydrate_ context rootComponent d
