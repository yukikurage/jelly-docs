module JellyDocs.ClientMain where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Jelly.SSG.ClientMain (clientMain)
import Jelly.SSG.Data.ClientConfig (ClientConfig)
import JellyDocs.Context (Context)
import JellyDocs.Page (Page(..), pageToUrl, urlToPage)
import JellyDocs.Pages.Document (documentPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.Pages.Top (topPage)
import JellyDocs.RootComponent (rootComponent)

main :: Effect Unit
main = launchAff_ $ clientMain clientConfig

clientConfig :: ClientConfig Context Page
clientConfig =
  { basePath: []
  , rootComponent
  , pageToUrl
  , urlToPage
  , pageComponent: case _ of
      PageTop -> topPage
      PageDocument _ -> documentPage
      PageNotFound -> notFoundPage
  }
