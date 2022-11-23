module JellyDocs.Page.Top where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Jelly.Component (Component, hooks, switch)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks, useAff)
import Jelly.Prop ((:=))
import JellyDocs.Capability.Api (class Api, useTopApi)
import JellyDocs.Component.Loading (loadingComponent)
import JellyDocs.Component.Markdown (markdownComponent)

topPage :: forall m. Api m => MonadHooks m => Component m
topPage = hooks do
  topApi <- useTopApi

  topSig <- useAff $ pure topApi

  pure $ switch do
    top <- topSig
    pure case top of
      Just (Right md) -> JE.div [ "class" := "px-4 py-10 lg:px-10 animate-fadeIn transition-colors" ] $ markdownComponent $ pure md
      _ -> JE.div [ "class" := "h-full w-full" ] do
        loadingComponent
