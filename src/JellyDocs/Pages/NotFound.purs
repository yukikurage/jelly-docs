module JellyDocs.Pages.NotFound where

import Prelude

import Jelly.Core.Data.Component (Component)
import JellyDocs.Context (Context)

notFoundPage :: String -> Component Context
notFoundPage _ = mempty
