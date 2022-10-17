module JellyDocs.Utils where

import Prelude

import Effect (Effect)
import Web.DOM (Element)
import Web.DOM.Element (setScrollTop)

scrollToTop :: Element -> Effect Unit
scrollToTop = setScrollTop 0.0 >>> void
