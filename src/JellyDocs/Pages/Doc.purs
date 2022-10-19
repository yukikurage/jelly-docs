module JellyDocs.Pages.Doc where

import Prelude

import Data.Either (Either(..))
import Data.HashMap (lookup)
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Jelly.Data.Component (Component, signalC, text)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Data.Signal (Signal)
import Jelly.Element as JE
import Jelly.Hooks.UseEffect (useEffect)
import Jelly.Router.Data.Path (makeRelativeFilePath)
import Jelly.Router.Data.Router (class RouterContext, useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Contexts.Apis (class ApisContext, useApis)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Twemoji (emojiProp)

docPage :: forall c. ApisContext c => RouterContext c => Signal String -> Component c
docPage docIdSig = hooks do
  apis <- useApis

  let
    docSig = do
      statesSig <- apis.doc.statesSig
      docId <- docIdSig
      pure $ lookup docId statesSig

  -- fetch when doc data is not available
  useEffect $ docIdSig <#> \docId -> do
    launchAff_ $ void $ apis.doc.initialize docId
    mempty

  -- redirect to 404
  { replaceUrl } <- useRouter
  useEffect do
    doc <- docSig
    pure do
      case doc of
        Just (Left _) -> do
          replaceUrl $ pageToUrl PageNotFound
        _ -> pure unit
      mempty

  pure $ JE.div [ "class" := "px-4 py-10 lg:px-10" ] $ signalC $ docSig <#> case _ of
    Just (Right doc) -> do
      JE.div [ "class" := "w-full flex justify-start" ] do
        JE.a
          [ "class" :=
              "block bg-slate-300 bg-opacity-0 text-pink-500 hover:text-pink-700 transition-colors rounded font-bold text-sm"
          , "href" := "https://github.com/yukikurage/jelly-docs/blob/master/docs/v0.6/en/" <> makeRelativeFilePath
              [ doc.section
              , doc.id <> ".md"
              ]
          , "target" := "_blank"
          , "rel" := "noopener noreferrer"
          , emojiProp
          ]
          do
            text "Edit this page ✏️"
      markdownComponent $ pure doc.content
    _ -> mempty
