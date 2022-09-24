module JellyDocs.Components.Sidebar where

import Prelude

import Control.Apply (lift2)
import Data.Foldable (for_)
import Data.Maybe (fromMaybe)
import Foreign.Object (keys, lookup, values)
import Jelly.Core.Data.Component (Component, el, el_, text)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=), (:=@))
import Jelly.Core.Hooks.UseContext (useContext)
import Jelly.Router.Components (link, link_)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Context (Context)
import JellyDocs.Data.Doc (Doc)
import JellyDocs.Data.Page (Page(..), pageToUrl)

renderSidebarSection :: String -> Component Context
renderSidebarSection section = hooks do
  { docs } <- useContext
  let
    sectionDocs = values $ fromMaybe mempty $ lookup section docs

  pure do
    el "li" [ "class" := "my-1 py-2 px-4 font-bold text-sm" ] do
      text $ pure section
    el_ "li" do
      el "ul" [ "class" := "" ] do
        for_ sectionDocs renderSidebarSectionItem

renderSidebarSectionItem :: Doc -> Component Context
renderSidebarSectionItem { title, id } = hooks do
  { currentUrlSig } <- useRouter

  let
    isActiveSig = lift2 eq currentUrlSig (pure $ pageToUrl $ PageDoc id)

  pure $ el "li" [ "class" := "my-1" ] do
    link (pageToUrl (PageDoc id))
      [ "class" :=@ do
          isActive <- isActiveSig
          pure $ "py-2 px-8 rounded-sm transition-colors block" <> if isActive then " bg-slate-500 text-white font-bold" else " hover:bg-slate-200"
      ]
      do
        text $ pure title

sidebarComponent :: Component Context
sidebarComponent = hooks do
  { docs } <- useContext

  let
    sections = keys docs
  pure $ el "div" [ "class" := "p-10 w-80 h-full bg-slate-50" ] do
    link_ (pageToUrl $ PageTop) do
      el "div" [ "class" := "w-full h-16" ] do
        el "h1" [ "class" := "text-2xl font-bold flex justify-center items-center h-full font-Montserrat" ] do
          text $ pure "Jelly"
    el "div" [ "class" := "h-[1px] bg-slate-500 w-full my-3" ] mempty
    el "ul" [ "class" := "w-full py-2" ] do
      for_ sections renderSidebarSection
