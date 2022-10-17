module JellyDocs.Pages.Top where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Component (Component, signalC)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Element (elDiv)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Contexts.Apis (useApis)

topPage :: Component Context
topPage = hooks do
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.top.initialize

  pure $ elDiv [ "class" := "px-4 py-10 lg:px-10" ] $ signalC do
    top <- apis.top.stateSig
    pure case top of
      Just (Right md) -> markdownComponent $ pure md
      _ -> mempty
