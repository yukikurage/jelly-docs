module JellyDocs.Pages.NotFound where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Component (Component, signalC)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Element as JE
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Contexts.Apis (class ApisContext, useApis)

notFoundPage :: forall c. ApisContext c => Component c
notFoundPage = hooks do
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.notFound.initialize

  pure $ JE.div [ "class" := "px-4 py-10 lg:px-10" ] $ signalC do
    notFound <- apis.notFound.stateSig
    pure case notFound of
      Just (Right md) -> markdownComponent $ pure md
      _ -> mempty
