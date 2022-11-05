module JellyDocs.Component.Sidebar where

import Prelude

import Data.Array (singleton)
import Data.Foldable (for_)
import Jelly.Component (class Component, text, textSig)
import Jelly.Element as JE
import Jelly.Prop ((:=), (:=@))
import JellyDocs.Capability.Nav (class Nav, pageLink, useCurrentPage)
import JellyDocs.Component.Logo (logoComponent)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..))
import JellyDocs.Data.Section (Section)
import JellyDocs.Twemoji (emojiProp)
import Signal (Signal)
import Signal.Hooks (useHooks_)

renderSidebarSection :: forall m. Component m => Nav m => Signal Section -> m Unit
renderSidebarSection sectionSig = do
  JE.li [ "class" := "my-1 pb-3 pt-6 px-3 font-bold text-sm" ] do
    textSig $ (_.title) <$> sectionSig
  JE.li' do
    JE.ul' $ useHooks_ do
      { docs } <- sectionSig
      pure $ for_ docs \doc -> renderSidebarSectionItem $ pure doc

renderSidebarSectionItem :: forall m. Component m => Nav m => Signal DocListItem -> m Unit
renderSidebarSectionItem docSig = do
  currentPage <- useCurrentPage

  let
    isActiveSig = do
      cp <- currentPage
      { id } <- docSig
      pure $ cp == PageDoc id

  JE.li [ "class" := "my-1" ] $ useHooks_ do
    { id, title } <- docSig
    pure $ pageLink (PageDoc id)
      [ "class" :=@ do
          isActive <- isActiveSig
          pure $
            [ "relative py-2 px-8 rounded transition-colors block before:absolute before:left-0 before:top-1/2 before:-translate-y-1/2 before:transition-all before:rounded bg-slate-300 bg-opacity-0 hover:bg-opacity-30 hover:active:bg-opacity-20"
            ]
              <> singleton
                if isActive then
                  "before:h-3/4 before:w-1 text-pink-600 font-bold before:bg-pink-600"
                else "before:h-1/2 before:w-0 text-slate-700 before:bg-slate-500"
      ]
      do
        text title

sidebarComponent :: forall m. Component m => Nav m => Signal (Array Section) -> m Unit
sidebarComponent sectionsSig =
  JE.nav [ "class" := "w-80", emojiProp ] do
    JE.div [ "class" := "w-full h-16 pt-16 px-10 hidden lg:block" ] logoComponent
    useHooks_ do
      sections <- sectionsSig
      pure $ JE.ul [ "class" := "w-full p-10" ] $
        for_ sections \section -> renderSidebarSection $ pure section
