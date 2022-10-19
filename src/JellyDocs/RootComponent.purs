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
import Jelly.Data.Signal (Signal, newState, newStateEq, readSignal, writeAtom)
import Jelly.Element as JE
import Jelly.Hooks.UseEffect (useEffect)
import Jelly.Router.Data.Router (class RouterContext, useRouter)
import JellyDocs.Components.Drawer (drawerComponent)
import JellyDocs.Components.Logo (logoComponent)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Contexts.Apis (class ApisContext, useApis)
import JellyDocs.Data.Page (Page(..), urlToPage)
import JellyDocs.Pages.Doc (docPage)
import JellyDocs.Pages.NotFound (notFoundPage)
import JellyDocs.Pages.Top (topPage)
import JellyDocs.Twemoji (emojiProp)
import JellyDocs.Utils (scrollToTop)
import Web.HTML.Event.EventTypes (click)

rootComponent :: forall c. RouterContext c => ApisContext c => Component c
rootComponent = do
  doctypeHtml
  JE.html [ "lang" := "en", "class" := "font-Lato text-slate-800" ] do
    headComponent
    bodyComponent

useTitleSig :: forall c. RouterContext c => ApisContext c => Hooks c (Signal String)
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

headComponent :: forall c. RouterContext c => ApisContext c => Component c
headComponent = JE.head [] do
  JE.title [] $ hooks do
    titleSig <- useTitleSig
    pure $ textSig titleSig

  JE.link [ "rel" := "stylesheet", "href" := "/index.css" ]

  JE.meta [ "name" := "viewport", "content" := "width=device-width,initial-scale=1.0" ]

  JE.link
    [ "rel" := "preconnect"
    , "href" := "https://fonts.gstatic.com"
    , "crossorigin" := true
    ]
  JE.link
    [ "rel" := "preload"
    , "as" := "style"
    , "href" :=
        "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
    ]
  JE.link
    [ "rel" := "stylesheet"
    , "href" :=
        "https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&family=Montserrat:wght@900&family=Source+Code+Pro&display=swap"
    , "media" := "print"
    , "onload" := "this.media='all'"
    ]

  JE.link
    [ "rel" := "stylesheet"
    , "href" := "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.15.10/styles/atom-one-light.min.css"
    ]

  JE.meta
    [ "name" := "description"
    , "content" := "Documentation for PureScript Jelly, a framework for building reactive web applications."
    ]
  JE.script
    [ "src" := "/index.js", "defer" := true ]
    mempty

bodyComponent :: forall c. RouterContext c => ApisContext c => Component c
bodyComponent = hooks do
  isSidebarOpenSig /\ isSidebarOpenAtom <- newStateEq false
  { currentUrlSig } <- useRouter
  scrollElSig /\ scrollElAtom <- newState Nothing

  -- | Hide sidebar when temporary url is changed
  useEffect do
    _ <- currentUrlSig
    pure do
      writeAtom isSidebarOpenAtom false
      scrollEl <- readSignal scrollElSig
      traverse_ scrollToTop scrollEl
      mempty

  apis <- useApis
  liftEffect $ launchAff_ $ void $ apis.sections.initialize

  pure $ JE.body [ "class" := "fixed left-0 top-0 flex flex-row items-start h-screen w-screen" ] do
    let
      sidebar = sidebarComponent do
        sectionsSig <- apis.sections.stateSig
        pure case sectionsSig of
          Just (Right sections) -> sections
          _ -> []
    JE.div
      [ "class" := "block lg:hidden absolute left-0 top-0 w-full backdrop-blur bg-white bg-opacity-60" ]
      do
        JE.button
          [ "class" :=
              "p-1 m-3 text-lg rounded border-slate-300 border-opacity-50 border hover:bg-slate-300 hover:bg-opacity-30 hover:active:bg-opacity-20 transition-all"
          , emojiProp
          , on click \_ -> writeAtom isSidebarOpenAtom true
          ]
          do
            text "📒"
        JE.div [ "class" := "w-full h-[1px] bg-slate-300 bg-opacity-50" ] mempty
        JE.div [ "class" := "absolute left-1/2 -translate-x-1/2 top-1/2 -translate-y-1/2" ] logoComponent
        drawerComponent { onClose: writeAtom isSidebarOpenAtom false, openSig: isSidebarOpenSig } sidebar
    JE.div [ "class" := "h-full w-fit hidden lg:block overflow-auto" ] do
      sidebar
    JE.div [ "class" := "h-full w-[1px] bg-slate-300 bg-opacity-50 hidden lg:block" ] mempty
    JE.div [ "class" := "flex-1 overflow-auto h-full flex justify-center", onMount (Just >>> writeAtom scrollElAtom) ]
      do
        JE.main [ "class" := "w-full xl:w-[60rem] pt-14 lg:pt-0" ] $ signalC do
          currentUrl <- currentUrlSig
          pure case urlToPage currentUrl of
            PageTop -> topPage
            PageDoc docId -> docPage $ pure docId
            PageNotFound -> notFoundPage
