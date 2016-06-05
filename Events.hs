{-# LANGUAGE RecursiveDo #-}
import Data.Map (fromList)

import Reflex.Dom (elAttr', dynText, mainWidget, wrapDomEvent, onEventName, EventName(Mousemove),performEvent_, holdDyn, _el_element)

import GHCJS.DOM.EventM (mouseOffsetXY) 



main = mainWidget $ do 
    let style = "border:3px solid black; margin:1em; margin-top:2em; margin-bottom:2em; padding:4em; display:inline-block"
    rec (x,_) <- (elAttr' "div" (fromList [("style",style)]) $ dynText t)
        e <- wrapDomEvent (_el_element x) (onEventName Mousemove) mouseOffsetXY
        performEvent_ $ return () <$ e
        t <- holdDyn "" (show <$> e)
    return ()

