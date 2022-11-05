module JellyDocs.Page.NotFound where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Jelly.Component (class Component)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import JellyDocs.Capability.Api (class Api, useNotFoundApi)
import JellyDocs.Component.Loading (loadingComponent)
import JellyDocs.Component.Markdown (markdownComponent)
import Signal.Hooks (useAff, useHooks_)

notFoundPage :: forall m. Api m => Component m => m Unit
notFoundPage = do
  notFoundApi <- useNotFoundApi

  notFoundSig <- useAff $ pure notFoundApi

  useHooks_ do
    notFound <- notFoundSig
    pure case notFound of
      Just (Right md) -> JE.div [ "class" := "px-4 py-10 lg:px-10 animate-fadeIn transition-colors" ] $ markdownComponent $ pure md
      _ -> JE.div [ "class" := "h-full w-full" ] do
        loadingComponent
