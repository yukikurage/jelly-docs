module JellyDocs.Data.Page where

import Prelude

import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex', parse, print, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax as GS
import Routing.Duplex.Parser (RouteError)

data Page = PageDoc String | PageTop | PageNotFound

derive instance Eq Page

derive instance Generic Page _

pageDuplex :: RouteDuplex' Page
pageDuplex = root $ sum
  { "PageDoc": "docs" GS./ segment
  , "PageTop": noArgs
  , "PageNotFound": "404" GS./ noArgs
  }

pageToRoute :: Page -> String
pageToRoute = print pageDuplex

routeToPage :: String -> Either RouteError Page
routeToPage = parse pageDuplex
