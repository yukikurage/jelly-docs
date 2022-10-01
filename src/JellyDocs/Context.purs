module JellyDocs.Context where

import Jelly.Generator.Data.StaticData (StaticDataContext)
import Jelly.Router.Data.Router (RouterContext)

type Context = RouterContext (StaticDataContext ())
