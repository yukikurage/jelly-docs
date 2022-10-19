module JellyDocs.Components.Drawer where

import Prelude

import Data.Monoid (guard)
import Effect (Effect)
import Jelly.Data.Component (Component)
import Jelly.Data.Prop (on, (:=@))
import Jelly.Data.Signal (Signal)
import Jelly.Element as JE
import Partial.Unsafe (unsafePartial)
import Web.Event.Event (eventPhase)
import Web.Event.EventPhase (EventPhase(..))
import Web.HTML.Event.EventTypes (click)

drawerComponent
  :: forall c. { openSig :: Signal Boolean, onClose :: Effect Unit } -> Component c -> Component c
drawerComponent { openSig, onClose } component = do
  JE.div
    [ "class" :=@ do
        open <- openSig
        pure $ [ "fixed left-0 top-0 w-screen h-screen transition-all duration-300 bg-opacity-0" ] <> guard (not open)
          [ "pointer-events-none" ]
    , on click \e -> when (unsafePartial $ eventPhase e == AtTarget) onClose

    ]
    do
      JE.div
        [ "class" :=@ do
            open <- openSig
            pure $
              [ "absolute left-0 top-0 w-fit h-full transition-all duration-300 shadow bg-white bg-opacity-80 overflow-auto"
              ]
                <>
                  if open then [ "opacity-100 backdrop-blur" ] else [ "opacity-0 -translate-x-[10%]" ]
        ]
        component
