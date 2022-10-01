module JellyDocs.Pages.Doc where

import Prelude

import Data.Maybe (Maybe(..))
import Jelly.Core.Data.Component (Component, el, signalC)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal)
import Jelly.Core.Hooks.UseAffSignal (useAffSignal)
import Jelly.Core.Hooks.UseSignal (useSignal)
import Jelly.Generator.Data.StaticData (useStaticData)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Data.Doc (Doc)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import Simple.JSON (readJSON_)

docPage :: Signal String -> Component Context
docPage docIdSig = hooks do
  { loadData } <- useStaticData
  { replaceUrl } <- useRouter

  let
    urlSig = do
      docId <- docIdSig
      pure $ pageToUrl $ PageDoc docId

  docMaybeMaybeSig <- useAffSignal do
    url <- urlSig
    pure do
      maybeDocRaw <- loadData url.path
      pure $ (readJSON_ =<< maybeDocRaw :: Maybe Doc)

  -- redirect to 404
  useSignal do
    docMaybeMaybe <- docMaybeMaybeSig
    pure do
      case docMaybeMaybe of
        Just Nothing -> do
          replaceUrl $ pageToUrl PageNotFound
        _ -> pure unit
      mempty

  pure $ el "div" [ "class" := "p-10" ] $ signalC do
    docMaybeMaybe <- docMaybeMaybeSig
    pure case docMaybeMaybe of
      Just (Just { content }) -> markdownComponent $ pure content
      _ -> mempty
