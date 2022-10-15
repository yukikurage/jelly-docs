module JellyDocs.Twemoji where

import Prelude

import Jelly.Data.Component (Component, rawElSig)
import Jelly.Data.Prop (Prop)
import Jelly.Data.Signal (Signal)

foreign import parseEmoji :: String -> String

emoTextSig :: forall context. Array Prop -> Signal String -> Component context
emoTextSig props emoji = rawElSig "p" props $ parseEmoji <$> emoji

emoText :: forall context. Array Prop -> String -> Component context
emoText props emoji = rawElSig "p" props $ pure $ parseEmoji emoji

emoTextSig' :: forall context. Signal String -> Component context
emoTextSig' emoji = emoTextSig [] emoji

emoText' :: forall context. String -> Component context
emoText' emoji = emoText [] emoji
