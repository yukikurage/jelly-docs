module JellyDocs.Pages.Doc where

import Prelude

import Data.Array (fold)
import Data.Maybe (Maybe(..))
import Data.Tuple (snd)
import Data.Tuple.Nested ((/\))
import Foreign.Object (lookup, toUnfoldable)
import Jelly.Core.Data.Component (Component, el)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal, signal, writeAtom)
import Jelly.Core.Hooks.UseContext (useContext)
import Jelly.Core.Hooks.UseSignal (useSignal)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Data.Page (Page(..), pageToUrl)

docPage :: Signal String -> Component Context
docPage docIdSig = hooks do
  { docs } <- useContext
  { replaceUrl } <- useRouter

  docSig /\ docAtom <- signal ""

  let
    docsFlatten = fold $ map snd $ toUnfoldable docs

  useSignal docIdSig \docId -> do
    let
      docMaybe = lookup docId docsFlatten
    case docMaybe of
      Just { content } -> do
        writeAtom docAtom content
      Nothing -> do
        replaceUrl $ pageToUrl PageNotFound
    mempty

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent $ docSig
