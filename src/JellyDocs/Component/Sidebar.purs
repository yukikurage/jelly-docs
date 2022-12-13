module JellyDocs.Component.Sidebar where

import Prelude

import Data.Array (singleton)
import Data.Foldable (for_)
import Jelly.Component (Component, hooks, switch, text, textSig)
import Jelly.Element as JE
import Jelly.Hooks (class MonadHooks)
import Jelly.Prop ((:=), (@=))
import Jelly.Signal (Signal)
import JellyDocs.Capability.Nav (class Nav, pageLink, useCurrentPage)
import JellyDocs.Component.Logo (logoComponent)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..))
import JellyDocs.Data.Section (Section)
import JellyDocs.Twemoji (emojiProp)

renderSidebarSection :: forall m. MonadHooks m => Nav m => Signal Section -> Component m
renderSidebarSection sectionSig = do
  JE.li [ "class" := "mb-1 mt-3 pb-3 pt-6 px-2 font-bold text-sm font-Montserrat" ] do
    textSig $ (_.title) <$> sectionSig
  JE.li [ "class" := "pl-5" ] do
    JE.ul [ "class" := "border-l-2" ] $ switch $ sectionSig <#> \{ docs } -> do
      for_ docs \doc -> renderSidebarSectionItem $ pure doc

renderSidebarSectionItem :: forall m. MonadHooks m => Nav m => Signal DocListItem -> Component m
renderSidebarSectionItem docSig = hooks do
  currentPage <- useCurrentPage

  let
    isActiveSig = do
      cp <- currentPage
      { id } <- docSig
      pure $ cp == PageDoc id

  pure do
    JE.li' do
      switch $ docSig <#> \{ id, title } ->
        pageLink (PageDoc id)
          [ "class" @= do
              isActive <- isActiveSig
              pure $
                [ "relative py-2 px-6 rounded transition-colors block before:absolute before:left-0 before:top-1/2 before:-translate-y-1/2 before:-translate-x-2/3 before:transition-all before:rounded bg-slate-300 bg-opacity-0 "
                ]
                  <> singleton
                    if isActive then
                      "before:h-3/4 before:w-1 text-pink-600 font-bold before:bg-pink-600"
                    else "before:h-1/2 before:w-0 text-slate-500 before:bg-pink-600 hover:text-slate-800"
          ]
          do
            text title

sidebarComponent :: forall m. MonadHooks m => Nav m => Signal (Array Section) -> Component m
sidebarComponent sectionsSig =
  JE.nav [ "class" := "w-[20rem]", emojiProp ] do
    JE.div [ "class" := "w-full h-16 pt-16 px-12 hidden lg:block" ] logoComponent
    switch $ sectionsSig <#> \sections -> do
      JE.ul [ "class" := "w-full px-12 py-8" ] $
        for_ sections \section -> renderSidebarSection $ pure section
