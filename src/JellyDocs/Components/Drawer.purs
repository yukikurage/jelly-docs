module JellyDocs.Components.Drawer where

import Prelude

import Effect (Effect)
import Jelly.Data.Component (Component, el)
import Jelly.Data.Prop (on, (:=@))
import Jelly.Data.Signal (Signal)
import Partial.Unsafe (unsafePartial)
import Web.Event.Event (eventPhase)
import Web.Event.EventPhase (EventPhase(..))
import Web.HTML.Event.EventTypes (click)

drawerComponent
  :: forall context. { openSig :: Signal Boolean, onClose :: Effect Unit } -> Component context -> Component context
drawerComponent { openSig, onClose } component = do
  el "div"
    [ "class" :=@ do
        open <- openSig
        pure $ "fixed left-0 top-0 w-screen h-screen transition-all duration-300 bg-opacity-0 " <>
          if open then "" else "pointer-events-none"
    , on click \e -> do
        let
          ep = unsafePartial $ eventPhase e
        if ep == AtTarget then
          onClose
        else
          pure unit
    ]
    do
      el "div"
        [ "class" :=@ do
            open <- openSig
            pure $ "absolute left-0 top-0 w-fit h-full transition-all duration-300 shadow bg-white bg-opacity-80 "
              <>
                if open then "opacity-100 backdrop-blur " else "opacity-0 -translate-x-3/4"
        ]
        component
