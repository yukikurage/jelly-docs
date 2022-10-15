module JellyDocs.RootComponent where

import Prelude

import Data.Array (find)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Component (Component, doctypeHtml, el, el', signalC, textSig, voidEl)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop ((:=))
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Context (Context)
import JellyDocs.Contexts.Apis (useApis)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.Pages.Doc (docPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.Pages.Top (topPage)

rootComponent :: Component Context
rootComponent = hooks do
  { currentUrlSig } <- useRouter
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.docs.initialize
  liftEffect $ launchAff_ $ void $ apis.sections.initialize

  let
    titleSig = do
      docs <- apis.docs.stateSig
      currentUrl <- currentUrlSig
      case urlToPage currentUrl of
        PageTop -> pure "Jelly"
        PageDoc docId
          | Just (Right ds) <- docs, Just { title } <- find (\{ id } -> docId == id) ds -> pure $ title <> " - Jelly"
        _ -> pure "Not Found - Jelly"

  pure do
    doctypeHtml
    el "html" [ "lang" := "en" ] do
      el' "head" do
        el' "title" do
          textSig titleSig
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
          , "href" :=
              "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@700&family=Source+Code+Pro&family=Noto+Color+Emoji&display=swap"
          ]
        voidEl "link"
          [ "rel" := "stylesheet"
          , "href" :=
              "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@700&family=Source+Code+Pro&family=Noto+Color+Emoji&display=swap"
          , "media" := "print"
          , "onload" := "this.media='all'"
          ]

        voidEl "link"
          [ "rel" := "stylesheet"
          , "href" := "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/atom-one-light.min.css"
          ]

        voidEl "meta"
          [ "name" := "description"
          , "content" := "Documentation for PureScript Jelly, a framework for building reactive web applications."
          ]
        el "script"
          [ "src" := "/index.js", "defer" := true ]
          mempty

      el "body" [ "class" := "text-slate-800" ] do
        el "div" [ "class" := "fixed left-0 top-0 flex flex-row h-screen w-screen font-Lato" ] do
          el "div" [ "class" := "flex-shrink-0" ] $ signalC do
            sectionsSig <- apis.sections.stateSig
            pure case sectionsSig of
              Just (Right sections) -> sidebarComponent $ pure sections
              _ -> sidebarComponent $ pure []
          el "div" [ "class" := "h-full w-[1px] bg-slate-300 bg-opacity-40" ] mempty
          el "div" [ "class" := "flex-1 overflow-auto" ] do
            el "main" [ "class" := "min-w-fit" ] $ signalC do
              currentUrl <- currentUrlSig
              pure case urlToPage currentUrl of
                PageTop -> topPage
                PageDoc docId -> docPage $ pure docId
                PageNotFound -> notFoundPage
