module JellyDocs.Pages.Top where

import Prelude

import Jelly.Core.Components (el)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Prop ((:=))
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)

topPage :: String -> Component Context
topPage doc = el "div" [ "class" := "p-10" ] $ markdownComponent (pure doc)
