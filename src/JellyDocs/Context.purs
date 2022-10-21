module JellyDocs.Context where

import Jelly (type (+))
import Jelly.Router (RouterContext)
import JellyDocs.Contexts.Apis (ApisContext)

type Context = RouterContext + ApisContext + ()