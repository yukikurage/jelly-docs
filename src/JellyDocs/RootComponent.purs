module JellyDocs.RootComponent where

import Prelude

import Data.Array (find)
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Jelly.Data.Component (Component, doctypeHtml, signalC, text, textSig)
import Jelly.Data.Hooks (Hooks, hooks)
import Jelly.Data.Prop (on, onMount, (:=))
import Jelly.Data.Signal (Signal, get, send, signal, signalEq)
import Jelly.Element (body, button, elDiv, elMain, head, html, link, meta, script, title)
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
import JellyDocs.Utils (scrollToTop)
import Web.HTML.Event.EventTypes (click)

rootComponent :: Component Context
rootComponent = do
  doctypeHtml
  html [ "lang" := "en", "class" := "font-Lato text-slate-800" ] do
    headComponent
    bodyComponent

useTitleSig :: Hooks Context (Signal String)
useTitleSig = do
  { currentUrlSig } <- useRouter
  apis <- useApis
  liftEffect $ launchAff_ $ void $ apis.docs.initialize
  pure do
    docs <- apis.docs.stateSig
    currentUrl <- currentUrlSig
    case urlToPage currentUrl of
      PageTop -> pure "Jelly : Reactive-based UI framework for PureScript"
      PageDoc docId
        | Just (Right ds) <- docs, Just { title } <- find (\{ id } -> docId == id) ds -> pure $ title <> " - Jelly"
      _ -> pure "Not Found - Jelly"

headComponent :: Component Context
headComponent = head [] do
  title [] $ hooks do
    titleSig <- useTitleSig
    pure $ textSig titleSig

  link [ "rel" := "stylesheet", "href" := "/index.css" ]

  meta [ "name" := "viewport", "content" := "width=device-width,initial-scale=1.0" ]

  link
    [ "rel" := "preconnect"
    , "href" := "https://fonts.gstatic.com"
    , "crossorigin" := true
    ]
  link
    [ "rel" := "preload"
    , "as" := "style"
    , "href" :=
        "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
    ]
  link
    [ "rel" := "stylesheet"
    , "href" :=
        "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
    , "media" := "print"
    , "onload" := "this.media='all'"
    ]

  link
    [ "rel" := "stylesheet"
    , "href" := "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/atom-one-light.min.css"
    ]

  meta
    [ "name" := "description"
    , "content" := "Documentation for PureScript Jelly, a framework for building reactive web applications."
    ]
  script
    [ "src" := "/index.js", "defer" := true ]
    mempty

bodyComponent :: Component Context
bodyComponent = hooks do
  isSidebarOpenSig /\ isSidebarOpenAtom <- signalEq false
  { temporaryUrlSig, currentUrlSig } <- useRouter
  scrollElSig /\ scrollElAtom <- signal Nothing

  -- | Hide sidebar when temporary url is changed
  useSignal do
    _ <- temporaryUrlSig
    pure do
      send isSidebarOpenAtom false
      scrollEl <- get scrollElSig
      traverse_ scrollToTop scrollEl
      mempty

  apis <- useApis
  liftEffect $ launchAff_ $ void $ apis.sections.initialize

  pure $ body [ "class" := "fixed left-0 top-0 flex flex-row items-start h-screen w-screen" ] do
    let
      sidebar = sidebarComponent do
        sectionsSig <- apis.sections.stateSig
        pure case sectionsSig of
          Just (Right sections) -> sections
          _ -> []
    elDiv
      [ "class" := "block lg:hidden absolute left-0 top-0 w-full backdrop-blur bg-white bg-opacity-60" ]
      do
        button
          [ "class" :=
              "p-1 m-3 text-lg rounded border-slate-300 border-opacity-50 border hover:bg-slate-300 hover:bg-opacity-30 hover:active:bg-opacity-20 transition-all"
          , emojiProp
          , on click \_ -> send isSidebarOpenAtom true
          ]
          do
            text "📒"
        elDiv [ "class" := "w-full h-[1px] bg-slate-300 bg-opacity-50" ] mempty
        elDiv [ "class" := "absolute left-1/2 -translate-x-1/2 top-1/2 -translate-y-1/2" ] logoComponent
        drawerComponent { onClose: send isSidebarOpenAtom false, openSig: isSidebarOpenSig } sidebar
    elDiv [ "class" := "h-full w-fit hidden lg:block overflow-auto" ] do
      sidebar
    elDiv [ "class" := "h-full w-[1px] bg-slate-300 bg-opacity-50 hidden lg:block" ] mempty
    elDiv [ "class" := "flex-1 overflow-auto h-full flex justify-center", onMount (Just >>> send scrollElAtom) ] do
      elMain [ "class" := "w-full xl:w-[60rem] pt-14 lg:pt-0" ] $ signalC do
        currentUrl <- currentUrlSig
        pure case urlToPage currentUrl of
          PageTop -> topPage
          PageDoc docId -> docPage $ pure docId
          PageNotFound -> notFoundPage
