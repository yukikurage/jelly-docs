module JellyDocs.Component.Drawer where

import Prelude

import Data.Monoid (guard)
import Jelly.Component (class Component)
import Jelly.Element as JE
import Jelly.Prop (on, (:=@))
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
      pure $ [ "fixed left-0 top-0 w-screen h-screen transition-all duration-300 bg-opacity-0" ] <> guard (not open) [ "pointer-events-none" ]
  , on click \e -> when (unsafePartial $ eventPhase e == AtTarget) onClose
  ]
  do
    JE.div
      [ "class" :=@ do
          open <- openSig
          pure $ [ "absolute left-0 top-0 w-fit h-full transition-all duration-300 shadow bg-white bg-opacity-80 overflow-auto" ]
            <> if open then [ "opacity-100 backdrop-blur" ] else [ "opacity-0 -translate-x-[10%]" ]
      ]
      do
        component
