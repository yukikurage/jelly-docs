module JellyDocs.Context where

import Foreign.Object (Object)
import Jelly.Router.Data.Router (RouterContext)
import JellyDocs.Data.Doc (Doc)

type C r =
  ( docs :: Object (Object Doc)
  , notFoundMD :: String
  , topMD :: String
  | r
  )

type Context = RouterContext (C ())
