module JellyDocs.Components.Sidebar where

import Prelude

import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Jelly.Core.Data.Component (Component, el, el_, signalC, text)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=), (:=@))
import Jelly.Core.Data.Signal (Signal)
import Jelly.Generator.Components (genLink, genLink_)
import Jelly.Generator.Data.StaticData (useStaticData)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Context (Context)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Data.Section (Section)
import Simple.JSON (readJSON_)

renderSidebarSection :: Signal Section -> Component Context
renderSidebarSection sectionSig = hooks do
  pure do
    el "li" [ "class" := "my-1 py-2 px-4 font-bold text-sm" ] do
      text $ (_.title) <$> sectionSig
    el_ "li" do
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
    pure $ genLink (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          pure $ "py-2 px-8 rounded-sm transition-colors block" <> if isActive then " bg-slate-500 text-white font-bold" else " hover:bg-slate-200"
      ]
      do
        text $ pure title

sidebarComponent :: Component Context
sidebarComponent = hooks do
  { globalData } <- useStaticData

  let
    sectionsMaybe = readJSON_ globalData :: Maybe (Array Section)

  pure $ el "div" [ "class" := "p-10 w-80 h-full bg-slate-50" ] do
    genLink_ (pageToUrl $ PageTop) do
      el "div" [ "class" := "w-full h-16" ] do
        el "h1" [ "class" := "text-2xl font-bold flex justify-center items-center h-full font-Montserrat" ] do
          text $ pure "Jelly"
    el "div" [ "class" := "h-[1px] bg-slate-500 w-full my-3" ] mempty
    el "ul" [ "class" := "w-full py-2" ] $ case sectionsMaybe of
      Just sections -> do
        for_ sections \section -> renderSidebarSection $ pure section
      Nothing -> mempty
