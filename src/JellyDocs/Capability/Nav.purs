module JellyDocs.Capability.Nav where

import Prelude

import Jelly.Component (class Component)
import Jelly.Prop (Prop)
import JellyDocs.Data.Page (Page)
import Signal (Signal)

class Monad m <= Nav m where
  usePushPage :: Page -> m Unit
  useReplacePage :: Page -> m Unit
  useCurrentPage :: m (Signal Page)
  pageLink :: Component m => Page -> Array (Prop m) -> m Unit -> m Unit
  pageLink' :: Component m => Page -> m Unit -> m Unit
