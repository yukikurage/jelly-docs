module JellyDocs.Pages.Document where

import Prelude

import Effect.Class (liftEffect)
import Jelly.Core.Components (el)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Page (Page(..))

documentPage :: String -> Component Context
documentPage doc = hooks do
  { pushPage } <- useRouter

  liftEffect $ when (doc == "") $ pushPage PageNotFound

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent (pure doc)
