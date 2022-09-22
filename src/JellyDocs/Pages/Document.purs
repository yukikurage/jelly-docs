module JellyDocs.Pages.Document where

import Prelude

import Jelly.Core.Components (el)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Prop ((:=))
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)

documentPage :: String -> Component Context
documentPage doc = el "div" [ "class" := "p-10" ] $ markdownComponent (pure doc)
