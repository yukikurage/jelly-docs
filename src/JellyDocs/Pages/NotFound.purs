module JellyDocs.Pages.NotFound where

import Prelude
import Jelly.Core.Data.Component (Component, el)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Hooks.UseContext (useContext)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)

notFoundPage :: Component Context
notFoundPage = hooks do
  { notFoundMD } <- useContext

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent $ pure notFoundMD
