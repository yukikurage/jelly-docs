module JellyDocs.Pages.Top where

import Prelude

import Data.Maybe (Maybe(..))
import Jelly.Core.Data.Component (Component, el, signalC)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Hooks.UseAffSignal (useAffSignal)
import Jelly.Generator.Data.StaticData (useStaticData)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Data.Page (Page(..), pageToUrl)

topPage :: Component Context
topPage = hooks do
  { loadData } <- useStaticData

  let
    url = pageToUrl PageTop

  mdMaybeMaybeSig <- useAffSignal do
    pure do
      maybeDocRaw <- loadData url.path
      pure maybeDocRaw

  pure $ el "div" [ "class" := "p-10" ] $ signalC do
    mdMaybeMaybe <- mdMaybeMaybeSig
    pure case mdMaybeMaybe of
      Just (Just md) -> markdownComponent $ pure md
      _ -> mempty
