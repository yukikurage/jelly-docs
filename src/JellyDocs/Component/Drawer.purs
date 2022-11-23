module JellyDocs.Component.Drawer where

import Prelude

import Jelly.Component (Component)
import Jelly.Element as JE
import Jelly.Prop (on, (:=), (@=))
import Jelly.Signal (Signal)
import Partial.Unsafe (unsafePartial)
import Web.Event.Event (eventPhase)
import Web.Event.EventPhase (EventPhase(..))
import Web.HTML.Event.EventTypes (click)

drawerComponent :: forall m. Monad m => { openSig :: Signal Boolean, onClose :: m Unit } -> Component m -> Component m
drawerComponent { openSig, onClose } component = JE.div
  [ "class" @= do
      open <- openSig
      pure $ [ "fixed left-0 top-0 w-screen h-screen transition-opacity bg-slate-600 bg-opacity-20 overflow-hidden will-change-contents z-50" ] <> if open then [ "opacity-100" ] else [ "opacity-0 pointer-events-none" ]
  , on click \e -> when (unsafePartial $ eventPhase e == AtTarget) onClose
  ]
  do
    JE.div
      [ "class" := [ "absolute left-0 top-0 w-fit h-full shadow bg-white overflow-auto" ]
      ]
      do
        component
