module JellyDocs.Components.Sidebar where

import Prelude

import Data.Array (foldMap, null)
import Jelly.Core.Components (el, el_, text)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=), (:=@))
import Jelly.Router.Data.Router (useRouter)
import Jelly.SSG.Components (link, link_)
import JellyDocs.Context (Context)
import JellyDocs.Documents (Documents(..), rootDocuments)
import JellyDocs.Page (Page(..))

renderSidebarSection :: Array Documents -> Component Context
renderSidebarSection documents = foldMap renderSidebarSectionItem documents

renderSidebarSectionItem :: Documents -> Component Context
renderSidebarSectionItem doc@(Documents _ title _ children) = hooks do
  { pageSig } <- useRouter

  let
    isActiveSig = do
      page <- pageSig
      pure $ case page of
        PageDocument pageDocument -> doc == pageDocument
        _ -> false
  pure do
    el "li" [ "class" := "my-1" ]
      do
        link
          (PageDocument doc)
          [ "class" :=@ do
              isActive <- isActiveSig
              pure $ "py-2 px-4 rounded-sm transition-colors block" <> if isActive then " bg-slate-500 text-white font-bold" else " hover:bg-slate-200"
          ]
          do
            text $ pure title
    if null children then
      pure unit
    else
      el_ "li" do
        el "ul" [ "class" := "ml-3" ] do
          renderSidebarSection children

sidebarComponent :: Component Context
sidebarComponent = el "div" [ "class" := "p-10 w-80 h-full bg-slate-50" ] do
  link_ PageTop do
    el "div" [ "class" := "w-full h-16" ] do
      el "h1" [ "class" := "text-2xl font-bold flex justify-center items-center h-full font-Montserrat" ] do
        text $ pure "Jelly"
  el "div" [ "class" := "h-[1px] bg-slate-500 w-full my-3" ] mempty
  el "ul" [ "class" := "w-full py-2" ] do renderSidebarSection rootDocuments
