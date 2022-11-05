module JellyDocs.Twemoji where

import Prelude

import Effect (Effect)
import Effect.Class (class MonadEffect, liftEffect)
import Jelly.Prop (Prop, onMount)
import Web.DOM (Element)

foreign import parseEmoji :: Element -> Effect Unit

emojiProp :: forall m. MonadEffect m => Prop m
emojiProp = onMount \el -> liftEffect $ parseEmoji el
