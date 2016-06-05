{-# LANGUAGE RecursiveDo, TemplateHaskell#-}
import Data.Map (fromList)

import Reflex.Dom (el, elAttr', dynText, mainWidget, wrapDomEvent, onEventName, EventName(Mousemove),performEvent_, holdDyn, text, _el_element)

import GHCJS.DOM.EventM (mouseOffsetXY) 

import Data.FileEmbed (embedStringFile)


main = mainWidget $ do 
    rec (x,_) <- (elAttr' "div" (fromList [("class","area")]) $ dynText t)
        e <- wrapDomEvent (_el_element x) (onEventName Mousemove) mouseOffsetXY
        performEvent_ $ return () <$ e
        t <- holdDyn "" (show <$> e)

    el "style" $ text $(embedStringFile "Events.css")
