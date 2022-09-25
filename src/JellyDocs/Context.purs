module JellyDocs.Context where

import Foreign.Object (Object)
import Jelly.Generator.Data.StaticData (StaticData)
import Jelly.Router.Data.Router (RouterContext)
import JellyDocs.Data.Doc (Doc)
import JellyDocs.Data.Section (Section)

type C r =
  ( docs :: Object (StaticData Doc)
  , sections :: Object (StaticData Section)
  , notFoundMD :: StaticData String
  , topMD :: StaticData String
  | r
  )

type Context = RouterContext (C ())
