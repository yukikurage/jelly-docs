module JellyDocs.Components.Markdown where

import Prelude

import Effect (Effect)
import Jelly.Core.Data.Component (Component, rawEl)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal)
import Jelly.Core.Hooks.UseEffectSignal (useEffectSignal)
import JellyDocs.Context (Context)

foreign import parseMarkdown :: String -> Effect String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  renderedSig <- useEffectSignal $ parseMarkdown <$> markdownSig

  pure $ rawEl "div" [ "class" := "w-full h-full markdown" ] renderedSig
