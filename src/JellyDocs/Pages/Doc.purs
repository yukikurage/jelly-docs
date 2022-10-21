module JellyDocs.Pages.Doc where

import Prelude

import Data.Either (Either(..))
import Data.HashMap (lookup)
import Data.Maybe (Maybe(..))
import Jelly (type (+), Component, hooks, signalC, text, (:=))
import Jelly.Data.Signal (Signal)
import Jelly.Element as JE
import Jelly.Hooks (useAff_, useEffect_)
import Jelly.Router (RouterContext, makeRelativeFilePath, useRouter)
import JellyDocs.Components.Markdown (markdownComponent)
import JellyDocs.Contexts.Apis (ApisContext, useApis)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Twemoji (emojiProp)

docPage :: forall c. Signal String -> Component (RouterContext + ApisContext + c)
docPage docIdSig = hooks do
  apis <- useApis

  let
    docSig = do
      statesSig <- apis.doc.statesSig
      docId <- docIdSig
      pure $ lookup docId statesSig

  -- fetch when doc data is not available
  useAff_ $ docIdSig <#> (void <<< apis.doc.initialize)

  -- redirect to 404
  { replaceUrl } <- useRouter
  useEffect_ $ docSig <#> case _ of
    Just (Left _) -> do
      replaceUrl $ pageToUrl PageNotFound
    _ -> pure unit

  pure $ JE.div [ "class" := "px-4 py-10 lg:px-10" ] $ signalC $ docSig <#> case _ of
    Just (Right doc) -> do
      JE.div [ "class" := "w-full flex justify-start" ] do
        JE.a
          [ "class" :=
              "block bg-slate-300 bg-opacity-0 text-pink-500 hover:text-pink-700 transition-colors rounded font-bold text-sm"
          , "href" := "https://github.com/yukikurage/jelly-docs/blob/master/docs/0.7/en/" <> makeRelativeFilePath
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
