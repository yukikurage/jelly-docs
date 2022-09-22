module JellyDocs.Components.Sidebar where

import Prelude

import Data.Array (foldMap, null, snoc)
import Jelly.Core.Components (el, text)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Prop ((:=))
import Jelly.SSG.Components (link_)
import JellyDocs.Context (Context)
import JellyDocs.Documents (Documents(..), documents)
import JellyDocs.Page (Page(..))

renderSidebarSection :: Array String -> Array Documents -> Component Context
renderSidebarSection rootId documents = foldMap (renderSidebarSectionItem rootId) documents

renderSidebarSectionItem :: Array String -> Documents -> Component Context
renderSidebarSectionItem rootId (Documents title children) = do
  link_ (PageDocument (rootId <> [ title ])) do
    el "li" [ "class" := "p-2" ] do
      text $ pure title
  if null children then
    pure unit
  else
    el "ul" [ "class" := "ml-3" ] do
      renderSidebarSection (rootId `snoc` title) children

sidebarComponent :: Component Context
sidebarComponent = el "div" [ "class" := "py-10 px-14 w-80 h-full bg-slate-50" ] do
  el "div" [ "class" := "w-full h-16" ] do
    el "h1" [ "class" := "text-2xl font-bold p-2" ] do
      text $ pure "Jelly Docs"
  el "ul" [ "class" := "w-full" ] do renderSidebarSection [] documents
