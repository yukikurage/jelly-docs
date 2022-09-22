module JellyDocs.Context where

import Jelly.SSG.Data.Context (SsgContext)
import JellyDocs.Page (Page)

type Context = SsgContext Page ()
