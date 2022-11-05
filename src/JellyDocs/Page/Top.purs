module JellyDocs.Page.Top where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Jelly.Component (class Component)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import JellyDocs.Capability.Api (class Api, useTopApi)
import JellyDocs.Component.Loading (loadingComponent)
import JellyDocs.Component.Markdown (markdownComponent)
import Signal.Hooks (useAff, useHooks_)

topPage :: forall m. Api m => Component m => m Unit
topPage = do
  topApi <- useTopApi

  topSig <- useAff $ pure topApi

  useHooks_ do
    top <- topSig
    pure case top of
      Just (Right md) -> JE.div [ "class" := "px-4 py-10 lg:px-10 animate-fadeIn" ] $ markdownComponent $ pure md
      _ -> JE.div [ "class" := "h-full w-full" ] do
        loadingComponent
