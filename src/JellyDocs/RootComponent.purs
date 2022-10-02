module JellyDocs.RootComponent where

import Prelude

import Data.Array (concatMap, find)
import Data.Maybe (Maybe(..))
import Jelly.Core.Data.Component (Component, doctypeHtml, el, el_, signalC, text, voidEl)
import Jelly.Core.Data.Hooks (hooks)
import Jelly.Core.Data.Prop ((:=))
import Jelly.Generator.Data.StaticData (useStaticData)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Context (Context)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.Data.Section (Section)
import JellyDocs.Pages.Doc (docPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.Pages.Top (topPage)
import Simple.JSON (readJSON_)

rootComponent :: Component Context
rootComponent = hooks do
  { currentUrlSig } <- useRouter
  { globalData } <- useStaticData

  let
    sectionsMaybe = readJSON_ globalData :: Maybe (Array Section)
    docItms = concatMap (_.docs) <$> sectionsMaybe
    titleSig = do
      currentUrl <- currentUrlSig
      case urlToPage currentUrl of
        PageTop -> pure "Jelly"
        PageDoc docId
          | Just { title } <- find (\{ id } -> docId == id) =<< docItms -> pure $ title <> " - Jelly"
        _ -> pure "Not Found - Jelly"

  pure do
    doctypeHtml
    el "html" [ "lang" := "en" ] do
      el_ "head" do
        el_ "title" do
          text titleSig
        voidEl "link" [ "rel" := "stylesheet", "href" := "/index.css" ]

        voidEl "meta" [ "name" := "viewport", "content" := "width=device-width,initial-scale=1.0" ]
        voidEl "link"
          [ "rel" := "preconnect"
          , "href" := "https://fonts.gstatic.com"
          , "crossorigin" := true
          ]
        voidEl "link"
          [ "rel" := "preload"
          , "as" := "style"
          , "href" := "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@700&family=Source+Code+Pro&display=swap"
          ]
        voidEl "link"
          [ "rel" := "stylesheet"
          , "href" := "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@700&family=Source+Code+Pro&display=swap"
          , "media" := "print"
          , "onload" := "this.media='all'"
          ]

        voidEl "link"
          [ "rel" := "stylesheet"
          , "href" := "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/atom-one-light.min.css"
          ]

        voidEl "meta" [ "name" := "description", "content" := "Documentation for PureScript Jelly, a framework for building reactive web applications." ]
        el "script"
          [ "src" := "/index.js", "defer" := true ]
          mempty

      el "body" [ "class" := "text-slate-800" ] do
        el "div" [ "class" := "fixed left-0 top-0 flex flex-row h-screen w-screen font-Lato" ] do
          el "div" [ "class" := "flex-shrink-0" ] do
            sidebarComponent
          el "div" [ "class" := "flex-1 overflow-auto" ] do
            el "main" [ "class" := "min-w-fit" ] $ signalC do
              currentUrl <- currentUrlSig
              pure case urlToPage currentUrl of
                PageTop -> topPage
                PageDoc docId -> docPage $ pure docId
                PageNotFound -> notFoundPage
