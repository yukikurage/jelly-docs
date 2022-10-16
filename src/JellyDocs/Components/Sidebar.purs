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
  { currentUrlSig, temporaryUrlSig } <- useRouter

  let
    isActiveSig = do
      currentUrl <- currentUrlSig
      { id } <- docSig
      pure $ currentUrl == (pageToUrl $ PageDoc id)
    isTransitioningPageSig = do
      temporaryUrl <- temporaryUrlSig
      currentUrl <- currentUrlSig
      { id } <- docSig
      pure $ temporaryUrl == (pageToUrl $ PageDoc id) && currentUrl /= temporaryUrl

  pure $ el "li" [ "class" := "my-1" ] $ signalC do
    { id, title } <- docSig
    pure $ routerLink (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          isTransitioningPage <- isTransitioningPageSig
          pure $
            "relative py-2 px-8 rounded transition-colors block before:absolute before:left-0 before:top-1/2 before:-translate-y-1/2 before:transition-all before:rounded bg-slate-300 bg-opacity-0 hover:bg-opacity-30 hover:active:bg-opacity-10"
              <>
                if isActive then " before:h-3/4 before:w-1 text-pink-500 font-bold before:bg-pink-500"
                else if isTransitioningPage then " before:h-1/2 before:w-1 font-bold before:bg-gray-500"
                else " before:h-1/2 before:w-0 text-slate-700 before:bg-slate-500"
      ]
      do
        text title

sidebarComponent :: Signal (Array Section) -> Component Context
sidebarComponent sectionsSig = hooks do
  { currentUrlSig } <- useRouter

  let
    isActiveSig = do
      currentUrl <- currentUrlSig
      pure $ currentUrl == (pageToUrl PageTop)

  pure $ el "nav" [ "class" := "w-80 h-full", emojiProp ] do
    routerLink' (pageToUrl $ PageTop) do
      el "div" [ "class" := "w-full h-16 pb-10 pt-16 px-10" ] do
        el "h1"
          [ "class" :=@ do
              isActive <- isActiveSig
              pure $ "text-2xl font-black flex justify-start items-center h-full font-Montserrat transition-colors" <>
                guard isActive
                  " text-pink-500"
          ]
          do
            text "🍮 Jelly"
    signalC do
      sections <- sectionsSig
      pure $ el "ul" [ "class" := "w-full px-10" ] $
        for_ sections \section -> renderSidebarSection $ pure section
