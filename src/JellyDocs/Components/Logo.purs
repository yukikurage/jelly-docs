module JellyDocs.Components.Logo where

import Prelude

import Jelly.Data.Component (Component, text)
import Jelly.Data.Prop ((:=))
import Jelly.Element (h1)
import Jelly.Router.Components (routerLink')
import Jelly.Router.Data.Router (RouterContext)
import JellyDocs.Data.Page (Page(..), pageToUrl)
import JellyDocs.Twemoji (emojiProp)

logoComponent :: forall c. Component (RouterContext c)
logoComponent = routerLink' (pageToUrl $ PageTop) do
  h1
    [ "class" := "text-2xl font-black flex justify-start items-center h-full font-Montserrat transition-colors"
    , emojiProp
    ]
    do
      text "🍮 Jelly"
