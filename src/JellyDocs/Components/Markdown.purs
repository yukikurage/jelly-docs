module JellyDocs.Components.Markdown where

import Prelude

import Effect (Effect)
import Jelly.Data.Component (Component, rawElSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Data.Signal (Signal)
import Jelly.Hooks.UseEffectSignal (useEffectSignal)
import JellyDocs.Context (Context)

foreign import parseMarkdown :: String -> Effect String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  renderedSig <- useEffectSignal $ parseMarkdown <$> markdownSig

  pure $ rawElSig "div" [ "class" := "w-full h-full markdown" ] renderedSig
