{-# LANGUAGE OverloadedStrings #-}
import Reflex.Dom 
import Data.Map (fromList)
import Data.Text (pack)
import GHCJS.DOM.EventM (mouseOffsetXY) 

main = mainWidget $ do 
    let attrs =   constDyn $ 
                      fromList 
                          [ ("width" , "500")
                          , ("height" , "250")
                          , ("style" , "border:solid; margin:8em")
                          ]

    (elm, _) <-   elDynAttrNS' 
                      (Just "http://www.w3.org/2000/svg")
                      "svg" 
                      attrs 
                      (return ())

    mouseEvent <- wrapDomEvent 
                      -- (_el_element elm) -- deprecated
                      (_element_raw elm) -- makes no difference
                      (onEventName Mousemove) 
                      mouseOffsetXY

    let mouseXYToString (x,y) = "X = " ++ show x ++ ";Y = " ++ show y

    t <- holdDyn "" (pack.mouseXYToString <$> mouseEvent)

    el "div" $ dynText t

