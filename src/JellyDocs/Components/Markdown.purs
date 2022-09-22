module JellyDocs.Components.Markdown where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Jelly.Core.Components (rawEl)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal)
import JellyDocs.Context (Context)

foreign import parseMarkdown :: String -> Effect String

markdownComponent :: Signal String -> Component Context
markdownComponent markdownSig = hooks do
  let
    renderedSig = do
      markdown <- markdownSig
      liftEffect $ parseMarkdown markdown

  pure $ rawEl "div" [ "class" := "w-full h-full markdown" ] renderedSig
