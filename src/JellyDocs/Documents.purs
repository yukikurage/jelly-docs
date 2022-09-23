module JellyDocs.Documents where

import Prelude

import Data.Array (concatMap, find)
import Data.Maybe (Maybe)

data Documents = Documents (Array String) String String (Array Documents)

derive instance Eq Documents

rootDocuments :: Array Documents
rootDocuments =
  [ docInstallation
  , docMainUsages
  , docAdvancedUsages
  , docStaticSiteGenerator
  ]

allDocuments :: Array Documents
allDocuments = go rootDocuments
  where
  go :: Array Documents -> Array Documents
  go [] = []
  go docs = docs <> go (concatMap (\(Documents _ _ _ children) -> children) docs)

docInstallation :: Documents
docInstallation = Documents [] "Installation" "installation" []

docMainUsages :: Documents
docMainUsages = Documents [] "Main Usages" "main-usages" [ docHelloWorld, docStaticHtml ]

docAdvancedUsages :: Documents
docAdvancedUsages = Documents [] "Advanced Guides" "advanced-guides" [ docContext, docSpaRouting ]

docStaticSiteGenerator :: Documents
docStaticSiteGenerator = Documents [] "Static Site Generator" "static-site-generator" [ docGenerateStaticApp, docHydration ]

docHelloWorld :: Documents
docHelloWorld = Documents [ "main-usages" ] "Hello World" "hello-world" []

docStaticHtml :: Documents
docStaticHtml = Documents [ "main-usages" ] "Static HTML" "static-html" []

docContext :: Documents
docContext = Documents [ "advanced-guides" ] "Context" "context" []

docSpaRouting :: Documents
docSpaRouting = Documents [ "advanced-guides" ] "SPA Routing" "spa-routing" []

docGenerateStaticApp :: Documents
docGenerateStaticApp = Documents [ "static-site-generator" ] "Generate Static App" "generate-static-app" []

docHydration :: Documents
docHydration = Documents [ "static-site-generator" ] "Hydration" "hydration" []

documentToPath :: Documents -> Array String
documentToPath (Documents parent _ id _) = [ "docs" ] <> parent <> [ id ]

pathToDocument :: Array String -> Maybe Documents
pathToDocument path = find (\doc -> documentToPath doc == path) allDocuments

documentToDocsPath :: Documents -> Array String
documentToDocsPath (Documents parent _ id _) = [ "docs" ] <> parent <> [ id <> ".md" ]
