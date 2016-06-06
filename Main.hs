import Reflex.Dom 
import Data.Map (fromList)
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
                      (_el_element elm) 
                      (onEventName Mousemove) 
                      mouseOffsetXY

    let mouseXYToString (x,y) = "X = " ++ show x ++ ";Y = " ++ show y

    t <- holdDyn "" (mouseXYToString <$> mouseEvent)

    el "div" $ dynText t

