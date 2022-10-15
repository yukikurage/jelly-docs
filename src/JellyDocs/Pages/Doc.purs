module JellyDocs.Pages.Doc where

import Prelude

import Data.Either (Either(..))
import Data.HashMap (lookup)
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Jelly.Data.Component (Component, el, signalC)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Data.Signal (Signal)
import Jelly.Hooks.UseSignal (useSignal)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Contexts.Apis (useApis)
import JellyDocs.Data.Page (Page(..), pageToUrl)

docPage :: Signal String -> Component Context
docPage docIdSig = hooks do
  apis <- useApis

  let
    docSig = do
      statesSig <- apis.doc.statesSig
      docId <- docIdSig
      pure $ lookup docId statesSig

  -- fetch when doc data is not available
  useSignal $ docIdSig <#> \docId -> do
    launchAff_ $ void $ apis.doc.initialize docId
    mempty

  -- redirect to 404
  { replaceUrl } <- useRouter
  useSignal do
    doc <- docSig
    pure do
      case doc of
        Just (Left _) -> do
          replaceUrl $ pageToUrl PageNotFound
        _ -> pure unit
      mempty

  pure $ el "div" [ "class" := "py-12 px-20" ] $ signalC do
    doc <- docSig
    pure case doc of
      Just (Right { content }) -> markdownComponent $ pure content
      _ -> mempty
