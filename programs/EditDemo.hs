{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Lens
import Data.Monoid
import Graphics.Vty hiding (translate)

import Brick.Main
import Brick.Types
import Brick.Widgets.Core
import Brick.Widgets.Center
import Brick.Widgets.Edit
import Brick.AttrMap
import Brick.Util

drawUI :: Editor -> [Widget]
drawUI e = [ui]
    where
        ui = center $ "Input: " <+> (hLimit 30 $ renderEditor e)

appEvent :: Editor -> Event -> EventM (Next Editor)
appEvent e ev =
    case ev of
        EvKey KEsc [] -> halt e
        EvKey KEnter [] -> halt e
        _ -> continue $ handleEvent ev e

initialState :: Editor
initialState = editor (Name "edit") str ""

theMap :: AttrMap
theMap = attrMap defAttr
    [ (editAttr, white `on` blue)
    ]

theApp :: App Editor Event
theApp =
    App { appDraw = drawUI
        , appChooseCursor = showFirstCursor
        , appHandleEvent = appEvent
        , appStartEvent = return
        , appAttrMap = const theMap
        , appMakeVtyEvent = id
        }

main :: IO ()
main = do
    e <- defaultMain theApp initialState
    putStrLn $ "You entered: " <> (e^.editContentsL)
