module JellyDocs.Contexts.Apis.Web where

import Affjax.Web (driver)
import Effect (Effect)
import JellyDocs.Contexts.Apis (Apis, newApis)

newWebApis :: Effect Apis
newWebApis = newApis driver
