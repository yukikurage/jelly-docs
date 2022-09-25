module JellyDocs.Pages.Doc where

import Prelude

import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Foreign.Object (lookup)
import Jelly.Core.Data.Component (Component, el)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Core.Data.Signal (Signal, signal, writeAtom)
import Jelly.Core.Hooks.UseContext (useContext)
import Jelly.Core.Hooks.UseSignal (useSignal)
import Jelly.Generator.Data.StaticData (loadStaticData)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Context (Context)
import JellyDocs.Data.Page (Page(..), pageToUrl)

docPage :: Signal String -> Component Context
docPage docIdSig = hooks do
  { docs } <- useContext
  { replaceUrl } <- useRouter

  docSig /\ docAtom <- signal Nothing

  useSignal docIdSig \docId -> do
    let
      docMaybeFiber = lookup docId docs
    case docMaybeFiber of
      Just fiber -> launchAff_ do
        docMaybe <- loadStaticData fiber
        case docMaybe of
          Just doc -> writeAtom docAtom $ Just doc
          Nothing -> liftEffect $ replaceUrl $ pageToUrl PageNotFound
      Nothing -> do
        replaceUrl $ pageToUrl PageNotFound
    mempty

  pure $ el "div" [ "class" := "p-10" ] $ markdownComponent do
    docMaybe <- docSig
    pure $ fromMaybe "" $ (_.content) <$> docMaybe
