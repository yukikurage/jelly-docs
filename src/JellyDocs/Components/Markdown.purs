module JellyDocs.Components.Markdown where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Jelly.Core.Data.Component (Component, rawEl)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal, signal, writeAtom)
import Jelly.Core.Hooks.UseSignal (useSignal)
import JellyDocs.Context (Context)

foreign import parseMarkdown :: String -> Effect String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  renderedSig /\ renderedAtom <- signal ""

  useSignal markdownSig \markdown -> do
    writeAtom renderedAtom =<< parseMarkdown markdown
    mempty

  pure $ rawEl "div" [ "class" := "w-full h-full markdown" ] renderedSig
