module JellyDocs.Page.Doc where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Jelly.Component (class Component, text)
import Jelly.Element as JE
import Jelly.Prop ((:=))
import JellyDocs.Capability.Api (class Api, useDocApi)
import JellyDocs.Capability.Nav (class Nav, useReplacePage)
import JellyDocs.Component.Loading (loadingComponent)
import JellyDocs.Component.Markdown (markdownComponent)
import JellyDocs.Data.Page (Page(..))
import JellyDocs.Twemoji (emojiProp)
import Signal (Signal)
import Signal.Hooks (useAff, useHooks_)

docPage :: forall m. Component m => Nav m => Api m => Signal String -> m Unit
docPage docIdSig = do
  docApi <- useDocApi

  docSig <- useAff do
    docId <- docIdSig
    pure $ docApi docId

  -- redirect to 404
  useHooks_ $ docSig <#> case _ of
    Just (Left _) -> do
      useReplacePage PageNotFound
    _ -> pure unit

  useHooks_ $ docSig <#> case _ of
    Just (Right doc) -> JE.div [ "class" := "px-4 py-10 lg:px-10 animate-fadeIn" ] do
      JE.div [ "class" := "w-full flex justify-start" ] do
        JE.a
          [ "class" :=
              "block bg-slate-300 bg-opacity-0 text-pink-600 hover:text-pink-800 transition-colors rounded font-bold text-sm"
          , "href" := "https://github.com/yukikurage/jelly-docs/blob/master/docs/v0.8/en/" <> joinWith "/"
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
    _ -> JE.div [ "class" := "h-full w-full" ] do
      loadingComponent
