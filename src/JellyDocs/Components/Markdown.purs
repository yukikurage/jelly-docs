module JellyDocs.Components.Markdown where

import Prelude

import Jelly.Data.Component (Component, rawElSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Data.Signal (Signal)
import JellyDocs.Context (Context)
import JellyDocs.Twemoji (emojiProp)

foreign import parseMarkdown :: String -> String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  let
    renderedSig = parseMarkdown <$> markdownSig

  pure $ rawElSig "div" [ "class" := "w-full h-full markdown", emojiProp ] renderedSig
