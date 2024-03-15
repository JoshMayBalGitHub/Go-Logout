{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Data.GI.Base
import Data.Char (toUpper, toLower)
import qualified Data.Text as Text (pack, unpack)
import qualified GI.Gtk as Gtk
import System.Process

capitalized :: [Char] -> [Char]
capitalized [] = []
capitalized (x:xs) = toUpper x : map toLower xs

main :: IO ()
main = do
  Gtk.init Nothing

  win_lginot <- Gtk.windowNew Gtk.WindowTypeToplevel
  set win_lginot
    [ #borderWidth          := 10
    , #title                := "Go-Logout"
    , #defaultWidth         := 750
    , #defaultHeight        := 225
    , #resizable            := False
    , #windowPosition       := Gtk.WindowPositionCenter
    , #decorated            := False
    ]

  Gtk.onWidgetDestroy win_lginot Gtk.mainQuit

  only_grid <- Gtk.gridNew
  set only_grid
    [ #columnSpacing        := 10
    , #rowSpacing           := 10
    , #columnHomogeneous    := True
    ]

  #add win_lginot only_grid

  let prefix  = "img/"
      suffix  = ".png"
      choices = [ ("goback",    Gtk.widgetDestroy win_lginot)
                , ("go_out",    callCommand "qdbus org.kde.Shutdown /Shutdown logout")
                , ("restart",    callCommand "qdbus org.kde.Shutdown /Shutdown logoutAndReboot")
                , ("shutoff",  callCommand "qdbus org.kde.Shutdown /Shutdown logoutAndShutdown")
                , ("SUSeep",   callCommand "systemctl suspend")
                , ("fastSUS", callCommand "systemctl hibernate")
                , ("logock",      callCommand "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock")
                ]

  let btnwbal :: [(String, IO ())] -> IO ()
      btnwbal [] = return ()
      btnwbal (x:xs) = do
        -- create Gtk image
        image <- Gtk.imageNewFromFile $ prefix ++ (fst x) ++ suffix
        -- create Gtk button
        button_all <- Gtk.buttonNew
        set button_all
          [ #relief  := Gtk.ReliefStyleNone
          , #image   := image
          , #hexpand := False
          ]
        -- What happens when 'button' is clicked
        on button_all #clicked $ do
          snd x
        -- Attach 'button' to grid depends on length of xs
        let a = (length choices) - 1
            b = length xs
            col = fromIntegral $ a - b
        -- Recursion happens by calling the function on 'xs'
        btnwbal xs
        #attach only_grid button_all col 0 1 1
        -- create Gtk label
  goback_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup goback_text "<b>Go Back</b>"

  go_out_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup go_out_text "<b>Go Out</b>"

  restart_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup restart_text "<b>Restart</b>"

  shutoff_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup shutoff_text "<b>Shutoff</b>"

  suseep_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup suseep_text "<b>SUSeep</b>"

  fastSUS_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup fastSUS_text "<b>FastSUS</b>"

  logock_text <- Gtk.labelNew Nothing
  Gtk.labelSetMarkup logock_text "<b>Logock</b>"
  
  #attach only_grid goback_text 0 1 1 1
  #attach only_grid go_out_text 1 1 1 1
  #attach only_grid restart_text 2 1 1 1
  #attach only_grid shutoff_text 3 1 1 1
  #attach only_grid suseep_text 4 1 1 1
  #attach only_grid fastSUS_text 5 1 1 1
  #attach only_grid logock_text 6 1 1 1
  btnwbal choices

  #showAll win_lginot
  Gtk.main
