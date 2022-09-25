module JellyDocs.Components.Sidebar where

import Prelude

import Control.Parallel (parTraverse)
import Data.Array (catMaybes)
import Data.Foldable (for_)
import Data.Tuple.Nested ((/\))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Foreign.Object (values)
import Jelly.Core.Data.Component (Component, el, el_, signalC, text)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=), (:=@))
import Jelly.Core.Data.Signal (Signal, signal, writeAtom)
import Jelly.Core.Hooks.UseContext (useContext)
import Jelly.Generator.Data.StaticData (loadStaticData)
import Jelly.Router.Components (link, link_)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Context (Context)
import JellyDocs.Data.Doc (DocListItem)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Data.Section (Section)

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
  { currentUrlSig } <- useRouter

  let
    isActiveSig = do
      currentUrl <- currentUrlSig
      { id } <- docSig
      pure $ currentUrl == (pageToUrl $ PageDoc id)

  pure $ el "li" [ "class" := "my-1" ] $ signalC do
    { id, title } <- docSig
    pure $ link (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          pure $ "py-2 px-8 rounded-sm transition-colors block" <> if isActive then " bg-slate-500 text-white font-bold" else " hover:bg-slate-200"
      ]
      do
        text $ pure title

sidebarComponent :: Component Context
sidebarComponent = hooks do
  { sections } <- useContext

  scsSig /\ scsAtom <- signal []

  let
    sectionFibers = values sections

  liftEffect $ launchAff_ do
    scsMaybe <- flip parTraverse sectionFibers \sectionFiber -> do
      loadStaticData sectionFiber
    writeAtom scsAtom $ catMaybes scsMaybe

  pure $ el "div" [ "class" := "p-10 w-80 h-full bg-slate-50" ] do
    link_ (pageToUrl $ PageTop) do
      el "div" [ "class" := "w-full h-16" ] do
        el "h1" [ "class" := "text-2xl font-bold flex justify-center items-center h-full font-Montserrat" ] do
          text $ pure "Jelly"
    el "div" [ "class" := "h-[1px] bg-slate-500 w-full my-3" ] mempty
    el "ul" [ "class" := "w-full py-2" ] $ signalC do
      scs <- scsSig
      pure $ for_ scs $ \sct -> renderSidebarSection $ pure sct
