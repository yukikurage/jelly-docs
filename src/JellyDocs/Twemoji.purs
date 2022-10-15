module JellyDocs.Twemoji where

import Prelude

import Effect (Effect)
import Jelly.Data.Prop (Prop, onMount)
import Web.DOM (Element)

foreign import parseEmoji :: Element -> Effect Unit

emojiProp :: Prop
emojiProp = onMount \el -> parseEmoji el
