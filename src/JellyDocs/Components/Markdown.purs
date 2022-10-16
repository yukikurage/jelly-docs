module JellyDocs.Components.Markdown where

import Prelude

import Example (preview)
import Jelly.Data.Component (Component, rawEl, signalC)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (onMount, (:=))
import Jelly.Data.Signal (Signal)
import JellyDocs.Context (Context)
import JellyDocs.Twemoji (emojiProp)

foreign import parseMarkdown :: String -> String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  let
    renderedSig = parseMarkdown <$> markdownSig

  pure $ signalC do
    rendered <- renderedSig
    pure $ rawEl "div" [ "class" := "w-full h-full markdown", emojiProp, onMount preview ] rendered
