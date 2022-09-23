module JellyDocs.RootComponent where

import Prelude

import Jelly.Core.Components (docTypeHTML, el, el_, text)
import Jelly.Core.Data.Component (Component)
import Jelly.Core.Data.Prop ((:=))
import Jelly.SSG.Components (mainScript)
import JellyDocs.Components.Sidebar (sidebarComponent)
import JellyDocs.Context (Context)

{-
<!DOCTYPE html>
<html>
    <head>
        <title>PureScript Jelly Documentation</title>

        <meta name="viewport" content="width=device-width,initial-scale=1.0">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@1,900&display=swap" rel="stylesheet">

        <script async="" type="text/javascript" src="./index.js"></script>
        <link rel="stylesheet" href="./index.css">
    </head>
    <body>
    </body>
</html>
-}

rootComponent :: Component Context -> Component Context
rootComponent pageComponent = do
  docTypeHTML
  el_ "html" do
    el_ "head" do
      el_ "title" do
        text $ pure "Jelly Docs"
      el "link" [ "rel" := "stylesheet", "href" := "/index.css" ] mempty

      el "meta" [ "name" := "viewport", "content" := "width=device-width,initial-scale=1.0" ] mempty

      el "link"
        [ "rel" := "preconnect"
        , "href" := "https://fonts.gstatic.com"
        , "crossorigin" := true
        ]
        mempty
      el "link"
        [ "rel" := "preload"
        , "as" := "style"
        , "href" := "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700;900&family=Source+Code+Pro&display=swap"
        ]
        mempty
      el "link"
        [ "rel" := "stylesheet"
        , "href" := "https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700;900&family=Source+Code+Pro&display=swap"
        , "media" := "print"
        , "onload" := "this.media='all'"
        ]
        mempty

      mainScript
    el "body" [ "class" := "text-slate-800" ] do
      el "div" [ "class" := "fixed left-0 top-0 flex flex-row h-screen w-screen font-Montserrat" ] do
        sidebarComponent
        pageComponent
