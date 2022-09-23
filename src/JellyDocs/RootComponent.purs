module JellyDocs.RootComponent where

import Prelude

import Data.Array (last)
import Data.Maybe (Maybe(..))
import Jelly.Core.Components (docTypeHTML, el, el_, text)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Router.Data.Router (useRouter)
import Jelly.SSG.Components (mainScript)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Context (Context)
import JellyDocs.Page (Page(..))

rootComponent :: Component Context -> Component Context
rootComponent pageComponent = hooks do
  { pageSig } <- useRouter

  let
    titleSig = do
      page <- pageSig
      case page of
        PageDocument arr | Just title <- last arr -> pure $ "Jelly Docs | " <> title
        _ -> pure "Jelly Docs"

  pure do
    docTypeHTML
    el "html" [ "lang" := "en" ] do
      el_ "head" do
        el_ "title" do
          text titleSig
        el "link" [ "rel" := "stylesheet", "href" := "/index.css" ] mempty

        el "meta" [ "name" := "viewport", "content" := "width=device-width,initial-scale=1.0" ] mempty

        el "link"
          [ "rel" := "preconnect"
          , "href" := "https://fonts.gstatic.com"
          , "crossorigin" := true
          ]
          mempty
        el "link"
          [ "rel" := "preload"
          , "as" := "style"
          , "href" := "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700;900&family=Source+Code+Pro&display=swap"
          ]
          mempty
        el "link"
          [ "rel" := "stylesheet"
          , "href" := "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700;900&family=Source+Code+Pro&display=swap"
          , "media" := "print"
          , "onload" := "this.media='all'"
          ]
          mempty

        mainScript

        el "meta" [ "name" := "description", "content" := "Documentation for PureScript Jelly, a framework for building reactive web applications." ] mempty
      el "body" [ "class" := "text-slate-800" ] do
        el "div" [ "class" := "fixed left-0 top-0 flex flex-row h-screen w-screen font-Montserrat" ] do
          sidebarComponent
          pageComponent
