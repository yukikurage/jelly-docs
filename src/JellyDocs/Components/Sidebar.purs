module JellyDocs.Components.Sidebar where

import Prelude

import Data.Array (singleton)
import Data.Foldable (for_)
import Jelly.Data.Component (Component, signalC, text, textSig)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=), (:=@))
import Jelly.Data.Signal (Signal)
import Jelly.Element as JE
import Jelly.Router.Components (routerLink)
import Jelly.Router.Data.Router (class RouterContext, useRouter)
import JellyDocs.Components.Logo (logoComponent)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Data.Section (Section)
import JellyDocs.Twemoji (emojiProp)

renderSidebarSection :: forall c. RouterContext c => Signal Section -> Component c
renderSidebarSection sectionSig = do
  JE.li [ "class" := "my-1 pb-3 pt-6 px-3 font-bold text-sm" ] do
    textSig $ (_.title) <$> sectionSig
  JE.li [] do
    JE.ul [] $ signalC do
      { docs } <- sectionSig
      pure $ for_ docs \doc -> renderSidebarSectionItem $ pure doc

renderSidebarSectionItem :: forall c. RouterContext c => Signal DocListItem -> Component c
renderSidebarSectionItem docSig = hooks do
  { currentUrlSig, isTransitioningSig } <- useRouter

  let
    isActiveSig = do
      currentUrl <- currentUrlSig
      { id } <- docSig
      pure $ currentUrl == (pageToUrl $ PageDoc id)

  pure $ JE.li [ "class" := "my-1" ] $ signalC do
    { id, title } <- docSig
    pure $ routerLink (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          isTransitioning <- isTransitioningSig
          pure $
            [ "relative py-2 px-8 rounded transition-colors block before:absolute before:left-0 before:top-1/2 before:-translate-y-1/2 before:transition-all before:rounded bg-slate-300 bg-opacity-0 hover:bg-opacity-30 hover:active:bg-opacity-20"
            ]
              <> singleton
                if isActive && not isTransitioning then
                  "before:h-3/4 before:w-1 text-pink-500 font-bold before:bg-pink-500"
                else if isActive && isTransitioning then "before:h-1/2 before:w-1 font-bold before:bg-gray-500"
                else "before:h-1/2 before:w-0 text-slate-700 before:bg-slate-500"
      ]
      do
        text title

sidebarComponent :: forall c. RouterContext c => Signal (Array Section) -> Component c
sidebarComponent sectionsSig = hooks do
  pure $ JE.nav [ "class" := "w-80", emojiProp ] do
    JE.div [ "class" := "w-full h-16 pt-16 px-10 hidden lg:block" ] logoComponent
    signalC do
      sections <- sectionsSig
      pure $ JE.ul [ "class" := "w-full p-10" ] $
        for_ sections \section -> renderSidebarSection $ pure section
