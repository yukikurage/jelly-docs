module JellyDocs.Pages.NotFound where

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

notFoundPage :: Component Context
notFoundPage = hooks do
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.notFound.initialize

  pure $ elDiv [ "class" := "px-4 py-10 lg:px-10" ] $ signalC do
    notFound <- apis.notFound.stateSig
    pure case notFound of
      Just (Right md) -> markdownComponent $ pure md
      _ -> mempty
