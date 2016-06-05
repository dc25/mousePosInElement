{-# LANGUAGE RecursiveDo, TemplateHaskell#-}
import qualified Data.Map as M
import Reflex.Dom
-- import Reflex.Dom.Contrib.Utils
import Control.Monad (void)
import GHCJS.DOM.MouseEvent
import qualified GHCJS.DOM.EventM as J
import Data.FileEmbed
import Language.Haskell.HsColour.Colourise
import Language.Haskell.HsColour

element t = fst <$>  (elAttr' "div" (M.fromList [("class","area")]) $ dynText t)

main = mainWidget . void $ do 

            -- with prevent default
            rec     x <-  element t       
                    e <- wrapDomEvent (_el_element x) (onEventName Mousemove) J.preventDefault
                    performEvent_ $ return () <$ e
                    t <- holdDyn "" (show <$> e)

            -- without 
            rec     x <- element t 
                    t <- holdDyn "" (show <$> domEvent Mousemove x)

            static 

static = do
     el "style" $ text $(embedStringFile "Events.css")
     holdDyn (color $ $(embedStringFile "Events.hs")) never >>= 
            elDynHtmlAttr' "div" (M.singleton "class" "code")
    where
        gray = Foreground (Rgb 120 120 120)
        color = hscolour ICSS  defaultColourPrefs{varop=[gray],layout=[gray]} False True "Source" False
