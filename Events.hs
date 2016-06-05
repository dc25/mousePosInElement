{-# LANGUAGE RecursiveDo, TemplateHaskell#-}
import Data.Map (fromList, singleton)

import Reflex.Dom (elAttr', dynText, mainWidget, wrapDomEvent, onEventName, EventName(Mousemove),performEvent_, holdDyn, domEvent, el, text, never, elDynHtmlAttr', _el_element)

import Control.Monad (void)

import GHCJS.DOM.EventM (preventDefault) 

import Data.FileEmbed (embedStringFile)

import Language.Haskell.HsColour.Colourise (Highlight(Foreground), Colour(Rgb), defaultColourPrefs)

import Language.Haskell.HsColour (hscolour, Output(ICSS), varop, layout)

-- import Reflex.Dom.Contrib.Utils
-- import GHCJS.DOM.MouseEvent ()

element t = fst <$>  (elAttr' "div" (fromList [("class","area")]) $ dynText t)

main = mainWidget . void $ do 

            -- with prevent default
            rec     x <-  element t       
                    e <- wrapDomEvent (_el_element x) (onEventName Mousemove) preventDefault
                    performEvent_ $ return () <$ e
                    t <- holdDyn "" (show <$> e)

            -- without 
            rec     x <- element t 
                    t <- holdDyn "" (show <$> domEvent Mousemove x)

            static 

static = do
     el "style" $ text $(embedStringFile "Events.css")
     holdDyn (color $ $(embedStringFile "Events.hs")) never >>= 
            elDynHtmlAttr' "div" (singleton "class" "code")
    where
        gray = Foreground (Rgb 120 120 120)
        color = hscolour ICSS  defaultColourPrefs{varop=[gray],layout=[gray]} False True "Source" False
