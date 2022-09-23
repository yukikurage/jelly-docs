module JellyDocs.Pages.Document where

import Prelude

import Effect.Class (liftEffect)
import Jelly.Core.Components (el)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (readSignal)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Page (Page(..), pageToUrl)

documentPage :: String -> Component Context
documentPage doc = hooks do
  { replacePage, pageSig } <- useRouter

  liftEffect $ when (doc == "") do
    page <- readSignal pageSig
    replacePage $ PageNotFound $ (_.path) $ pageToUrl page

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent (pure doc)
