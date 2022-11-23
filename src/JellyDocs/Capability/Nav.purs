module JellyDocs.Capability.Nav where

import Prelude

import Jelly.Component (Component)
import Jelly.Prop (Prop)
import Jelly.Signal (Signal)
import JellyDocs.Data.Page (Page)

class Monad m <= Nav m where
  usePushPage :: Page -> m Unit
  useReplacePage :: Page -> m Unit
  useCurrentPage :: m (Signal Page)
  pageLink :: Page -> Array (Prop m) -> Component m -> Component m
  pageLink' :: Page -> Component m -> Component m
