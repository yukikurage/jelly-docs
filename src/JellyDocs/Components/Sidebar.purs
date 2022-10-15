module JellyDocs.Components.Sidebar where

import Prelude

import Data.Foldable (for_)
import Data.Monoid (guard)
import Jelly.Data.Component (Component, el, el', signalC, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=), (:=@))
import Jelly.Data.Signal (Signal)
import Jelly.Router.Components (routerLink, routerLink')
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Context (Context)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Data.Section (Section)
import JellyDocs.Twemoji (emojiProp)

renderSidebarSection :: Signal Section -> Component Context
renderSidebarSection sectionSig = do
  el "li" [ "class" := "my-1 pb-3 pt-6 px-3 font-bold text-sm" ] do
    textSig $ (_.title) <$> sectionSig
  el' "li" do
    el "ul" [ "class" := "" ] $ signalC do
      { docs } <- sectionSig
      pure $ for_ docs \doc -> renderSidebarSectionItem $ pure doc

renderSidebarSectionItem :: Signal DocListItem -> Component Context
renderSidebarSectionItem docSig = hooks do
  { temporaryUrlSig } <- useRouter

  let
    isActiveSig = do
      temporaryUrl <- temporaryUrlSig
      { id } <- docSig
      pure $ temporaryUrl == (pageToUrl $ PageDoc id)

  pure $ el "li" [ "class" := "my-1" ] $ signalC do
    { id, title } <- docSig
    pure $ routerLink (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          pure $
            "relative py-2 px-8 rounded transition-colors block before:bg-teal-500 before:absolute before:left-0 before:top-1/2 before:-translate-y-1/2 before:transition-all before:rounded bg-slate-300 bg-opacity-0 hover:bg-opacity-30 hover:active:bg-opacity-10"
              <>
                if isActive then " before:h-3/4 before:w-1 text-teal-500 font-bold"
                else " before:h-1/4 before:w-0 text-slate-700"
      ]
      do
        text title

sidebarComponent :: Signal (Array Section) -> Component Context
sidebarComponent sectionsSig = hooks do
  { temporaryUrlSig } <- useRouter

  let
    isActiveSig = do
      temporaryUrl <- temporaryUrlSig
      pure $ temporaryUrl == (pageToUrl PageTop)

  pure $ el "nav" [ "class" := "w-80 h-full", emojiProp ] do
    routerLink' (pageToUrl $ PageTop) do
      el "div" [ "class" := "w-full h-16 pb-10 pt-16 px-10" ] do
        el "h1"
          [ "class" :=@ do
              isActive <- isActiveSig
              pure $ "text-2xl font-black flex justify-start items-center h-full font-Montserrat transition-colors" <>
                guard isActive
                  " text-teal-500"
          ]
          do
            text "🍮 Jelly"
    signalC do
      sections <- sectionsSig
      pure $ el "ul" [ "class" := "w-full px-10" ] $
        for_ sections \section -> renderSidebarSection $ pure section
