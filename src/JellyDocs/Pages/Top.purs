module JellyDocs.Pages.Top where

import Prelude
import Jelly.Core.Data.Component (Component, el)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Hooks.UseContext (useContext)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)

topPage :: Component Context
topPage = hooks do
  { topMD } <- useContext

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent $ pure topMD
