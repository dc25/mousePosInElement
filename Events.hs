{-# LANGUAGE RecursiveDo #-}
import Data.Map (fromList)

import Reflex.Dom (elAttr', elDynAttrNS', constDyn, dynText, mainWidget, wrapDomEvent, onEventName, EventName(Mousemove),performEvent_, holdDyn, _el_element, (=:))

import GHCJS.DOM.EventM (mouseOffsetXY) 
import Data.Monoid ((<>))

-- | Namespace needed for svg elements.
svgNamespace = Just "http://www.w3.org/2000/svg"

main = mainWidget $ do 
    let style = "border:3px solid black; margin:1em; margin-top:2em; margin-bottom:2em; padding:4em; display:inline-block"
    rec 
        (el, ev) <- elDynAttrNS' svgNamespace "svg" 
                        (constDyn $  "viewBox" =: ("0 0 1 1 ")
                                  <> "width" =: "300"
                                  <> "height" =: "250"
                                  <> "style" =: style)

                        $ return ()
        (x,_) <- (elAttr' "div" (fromList [("style",style)]) $ dynText t)
        e <- wrapDomEvent (_el_element el) (onEventName Mousemove) mouseOffsetXY
        performEvent_ $ return () <$ e
        t <- holdDyn "" (show <$> e)
    return ()

