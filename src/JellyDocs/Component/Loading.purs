module JellyDocs.Component.Loading where

import Prelude

import Jelly.Component (class Component)
import Jelly.Element as JE
import Jelly.Prop ((:=))

loadingComponent :: forall m. Component m => m Unit
loadingComponent = do
  JE.div [ "class" := "flex justify-center items-center h-full w-full" ] do
    JE.div [ "class" := "overflow-hidden h-1 w-28 rounded" ] do
      JE.div [ "class" := "animate-sweep h-full w-full bg-pink-300 rounded" ] do pure unit
