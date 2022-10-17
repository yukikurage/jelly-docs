module JellyDocs.RootComponent where

import Prelude

import Data.Array (find)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Component (Component, doctypeHtml, el, el', signalC, text, textSig, voidEl)
import Jelly.Data.Hooks (hooks)
import Jelly.Data.Prop (on, (:=))
import Jelly.Data.Signal (send, signalEq)
import Jelly.Hooks.UseSignal (useSignal)
import Jelly.Router.Data.Router (useRouter)
import JellyDocs.Components.Drawer (drawerComponent)
import JellyDocs.Components.Logo (logoComponent)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Context (Context)
import JellyDocs.Contexts.Apis (useApis)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.Pages.Doc (docPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.Pages.Top (topPage)
import JellyDocs.Twemoji (emojiProp)
import Web.HTML.Event.EventTypes (click)

rootComponent :: Component Context
rootComponent = hooks do
  { currentUrlSig, temporaryUrlSig } <- useRouter
  apis <- useApis

  liftEffect $ launchAff_ $ void $ apis.docs.initialize
  liftEffect $ launchAff_ $ void $ apis.sections.initialize

  let
    titleSig = do
      docs <- apis.docs.stateSig
      currentUrl <- currentUrlSig
      case urlToPage currentUrl of
        PageTop -> pure "Jelly : Reactive-based UI framework for PureScript"
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
              "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
          ]
        voidEl "link"
          [ "rel" := "stylesheet"
          , "href" :=
              "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
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

      el "body" [ "class" := "fixed left-0 top-0 flex flex-row items-start h-screen w-screen font-Lato text-slate-800" ]
        do
          let
            sidebar = sidebarComponent
              do
                sectionsSig <- apis.sections.stateSig
                pure case sectionsSig of
                  Just (Right sections) -> sections
                  _ -> []
          hooks do
            isSidebarOpenSig /\ isSidebarOpenAtom <- signalEq false

            useSignal do
              _ <- temporaryUrlSig
              pure do
                send isSidebarOpenAtom false
                mempty

            pure do
              el "div" [ "class" := "block lg:hidden absolute left-0 top-0 w-full backdrop-blur bg-white bg-opacity-60" ] do
                el "button"
                  [ "class" :=
                      "p-1 m-3 text-lg rounded border-slate-300 border-opacity-50 border hover:bg-slate-300 hover:bg-opacity-30 hover:active:bg-opacity-20 transition-all"
                  , emojiProp
                  , on click \_ -> send isSidebarOpenAtom true
                  ]
                  do
                    text "📒"
                el "div" [ "class" := "w-full h-[1px] bg-slate-300 bg-opacity-50" ] mempty
                el "div" ["class" := "absolute left-1/2 -translate-x-1/2 top-1/2 -translate-y-1/2"] logoComponent
                drawerComponent { onClose: send isSidebarOpenAtom false, openSig: isSidebarOpenSig } sidebar
          el "div" [ "class" := "h-full w-fit hidden lg:block overflow-auto" ] do
            sidebar
          el "div" [ "class" := "h-full w-[1px] bg-slate-300 bg-opacity-50 hidden lg:block" ] mempty
          el "div" [ "class" := "flex-1 overflow-auto h-full flex justify-center" ] do
            el "main" [ "class" := "w-full xl:w-[60rem] pt-14 lg:pt-0" ] $ signalC do
              currentUrl <- currentUrlSig
              pure case urlToPage currentUrl of
                PageTop -> topPage
                PageDoc docId -> docPage $ pure docId
                PageNotFound -> notFoundPage
