module JellyDocs.Context where

import Jelly.Router.Data.Router (class RouterContext, Router)
import JellyDocs.Contexts.Apis (class ApisContext, Apis)

newtype Context = Context
  { router :: Router
  , apis :: Apis
  }

instance RouterContext Context where
  getRouter (Context { router }) = router

instance ApisContext Context where
  getApis (Context { apis }) = apis
