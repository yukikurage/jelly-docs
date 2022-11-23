module JellyDocs.Component.Logo where

import Jelly.Component (Component, text)
import Jelly.Element (h1)
import Jelly.Hooks (class MonadHooks)
import Jelly.Prop ((:=))
import JellyDocs.Capability.Nav (class Nav, pageLink')
import JellyDocs.Data.Page (Page(..))
import JellyDocs.Twemoji (emojiProp)

logoComponent :: forall m. Nav m => MonadHooks m => Component m
logoComponent = pageLink' PageTop do
  h1 [ "class" := "text-2xl font-black flex justify-start items-center h-full font-Montserrat transition-colors", emojiProp ] do
    text "🍮 Jelly"
