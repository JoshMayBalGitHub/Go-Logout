
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.GI.Base
import qualified GI.Gtk as Gtk
import System.Process

main :: IO ()
main = do 
    Gtk.init Nothing

    win_lginot <- Gtk.windowNew Gtk.WindowTypeToplevel
    Gtk.setContainerBorderWidth win_lginot 10
    Gtk.setWindowTitle win_lginot "Go-Logout"
    Gtk.setWindowResizable win_lginot False
    Gtk.setWindowDefaultWidth win_lginot 750
    Gtk.setWindowDefaultHeight win_lginot 225
    Gtk.setWindowWindowPosition win_lginot Gtk.WindowPositionCenter
    Gtk.windowSetDecorated win_lginot False

    goback_img <- Gtk.imageNewFromFile "./img/goback.png"
    goout_img <- Gtk.imageNewFromFile "./img/go_out.jpg"
    restart_img <- Gtk.imageNewFromFile "./img/restart.png"
    shutoff_img <- Gtk.imageNewFromFile "./img/shutoff.png"
    suseep_img <- Gtk.imageNewFromFile "./img/SUSeep.png"
    fastSUS_img <- Gtk.imageNewFromFile "./img/fastSUS.png"
    logock_img <- Gtk.imageNewFromFile "./img/logock.png"

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

    goback_button <- Gtk.buttonNew
    Gtk.buttonSetRelief goback_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage goback_button $ Just goback_img
    Gtk.widgetSetHexpand goback_button False
    on goback_button #clicked $ do
        Gtk.widgetDestroy win_lginot
    
    go_out_button <- Gtk.buttonNew
    Gtk.buttonSetRelief go_out_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage go_out_button $ Just goout_img
    Gtk.widgetSetHexpand go_out_button False
    on go_out_button #clicked $ do
        callCommand "qdbus org.kde.ksmserver /KSMServer logout 0 0 0"

    restart_button <- Gtk.buttonNew
    Gtk.buttonSetRelief restart_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage restart_button $ Just restart_img
    Gtk.widgetSetHexpand restart_button False
    on restart_button #clicked $ do
        callCommand "reboot"

    shutoff_button <- Gtk.buttonNew
    Gtk.buttonSetRelief shutoff_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage shutoff_button $ Just shutoff_img
    Gtk.widgetSetHexpand shutoff_button False
    on shutoff_button #clicked $ do
        callCommand "shutdown now"

    suseep_button <- Gtk.buttonNew
    Gtk.buttonSetRelief suseep_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage suseep_button $ Just suseep_img
    Gtk.widgetSetHexpand suseep_button False
    on suseep_button #clicked $ do
        callCommand "systemctl suspend"
    
    fastSUS_button <- Gtk.buttonNew
    Gtk.buttonSetRelief fastSUS_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage fastSUS_button $ Just fastSUS_img
    Gtk.widgetSetHexpand fastSUS_button False
    on fastSUS_button #clicked $ do
        callCommand "systemctl hibernate"

    logock_button <- Gtk.buttonNew
    Gtk.buttonSetRelief logock_button Gtk.ReliefStyleNone
    Gtk.buttonSetImage logock_button $ Just logock_img
    Gtk.widgetSetHexpand logock_button False
    on logock_button #clicked $ do
        callCommand "qdbus org.freedesktop.ScreenSaver /ScreenSaver Lock"

    only_grid <- Gtk.gridNew
    Gtk.gridSetColumnSpacing only_grid 10
    Gtk.gridSetRowSpacing only_grid 10
    Gtk.gridSetColumnHomogeneous only_grid True

    #attach only_grid goback_button 0 0 1 1
    #attach only_grid goback_text 0 1 1 1
    #attach only_grid go_out_button 1 0 1 1
    #attach only_grid go_out_text 1 1 1 1
    #attach only_grid restart_button 2 0 1 1
    #attach only_grid restart_text 2 1 1 1
    #attach only_grid shutoff_button 3 0 1 1
    #attach only_grid shutoff_text 3 1 1 1
    #attach only_grid suseep_button 4 0 1 1
    #attach only_grid suseep_text 4 1 1 1
    #attach only_grid fastSUS_button 5 0 1 1
    #attach only_grid fastSUS_text 5 1 1 1
    #attach only_grid logock_button 6 0 1 1
    #attach only_grid logock_text 6 1 1 1

    #add win_lginot only_grid

    Gtk.onWidgetDestroy win_lginot Gtk.mainQuit
    #showAll win_lginot
    Gtk.main
