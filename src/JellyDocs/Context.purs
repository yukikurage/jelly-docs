module JellyDocs.Context where

import Jelly.Router.Data.Router (RouterContext)
import JellyDocs.Contexts.Apis (ApisContext)

type Context = RouterContext (ApisContext ())
