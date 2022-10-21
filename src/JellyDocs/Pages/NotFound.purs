module JellyDocs.Pages.NotFound where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly (Component, hooks, signalC, (:=))
import Jelly.Element as JE
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Contexts.Apis (ApisContext, useApis)

notFoundPage :: forall c. Component (ApisContext c)
notFoundPage = hooks do
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.notFound.initialize

  pure $ JE.div [ "class" := "px-4 py-10 lg:px-10" ] $ signalC do
    notFound <- apis.notFound.stateSig
    pure case notFound of
      Just (Right md) -> markdownComponent $ pure md
      _ -> mempty
