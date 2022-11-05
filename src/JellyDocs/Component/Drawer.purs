module JellyDocs.Component.Drawer where

import Prelude

import Jelly.Component (class Component)
import Jelly.Element as JE
import Jelly.Prop (on, (:=), (:=@))
import Partial.Unsafe (unsafePartial)
import Signal (Signal)
import Web.Event.Event (eventPhase)
import Web.Event.EventPhase (EventPhase(..))
import Web.HTML.Event.EventTypes (click)

drawerComponent
  :: forall m. Component m => { openSig :: Signal Boolean, onClose :: m Unit } -> m Unit -> m Unit
drawerComponent { openSig, onClose } component = JE.div
  [ "class" :=@ do
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
