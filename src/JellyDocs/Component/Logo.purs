module JellyDocs.Component.Logo where

import Prelude

import Jelly.Component (class Component, text)
import Jelly.Element (h1)
import Jelly.Prop ((:=))
import JellyDocs.Capability.Nav (class Nav, pageLink')
import JellyDocs.Data.Page (Page(..))
import JellyDocs.Twemoji (emojiProp)

logoComponent :: forall m. Nav m => Component m => m Unit
logoComponent = pageLink' PageTop do
  h1 [ "class" := "text-2xl font-black flex justify-start items-center h-full font-Montserrat transition-colors", emojiProp ] do
    text "🍮 Jelly"
