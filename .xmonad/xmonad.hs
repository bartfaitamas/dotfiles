{-# LANGUAGE OverloadedStrings #-}
import XMonad
import XMonad.Util.EZConfig
import XMonad.Actions.Warp
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders

import qualified DBus.Client.Simple as D
import qualified Codec.Binary.UTF8.String as UTF8

main :: IO ()
main = do
  dbus <- D.connectSession
  getWellKnownName dbus
  xmonad $ withUrgencyHook NoUrgencyHook
    $ gnomeConfig
    { terminal     = "urxvtcd -e byobu"
    , modMask    = mod4Mask
    , layoutHook = smartBorders (layoutHook gnomeConfig)
    , logHook    = dynamicLogWithPP (prettyPrinter dbus)
    }
    `additionalKeysP`
    [ ("M-z", banishScreen LowerLeft)
    , ("M-S-q", spawn "gnome-session-quit")
    , ("M-<KP_Begin>", spawn "mpc toggle")
    , ("M-<KP_Left>", spawn "mpc prev")
    , ("M-<KP_Right>", spawn "mpc next")
    ]

prettyPrinter :: D.Client -> PP
prettyPrinter dbus = defaultPP
  { ppOutput  = dbusOutput dbus
  , ppTitle   = pangoSanitize
  , ppCurrent = pangoColor "green" . wrap "[" "]" . pangoSanitize
  , ppVisible = pangoColor "yellow" . wrap "(" ")" . pangoSanitize
  , ppHidden  = pangoSanitize
  , ppUrgent  = pangoColor "red"
  , ppLayout  = pangoSanitize
  , ppSep     = " | "
  }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
    [D.AllowReplacement, D.ReplaceExisting, D.DoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = D.emit dbus
                      "/org/xmonad/Log"
                      "org.xmonad.Log"
                      "Update"
                      [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>' xs = "&gt;" ++ xs
    sanitize '<' xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&' xs = "&amp;" ++ xs
    sanitize x xs = x:xs

-- main = xmonad $ gnomeConfig
--   { terminal = "urxvtcd"
--   , modMask = mod4Mask
--   , layoutHook = smartBorders (layoutHook gnomeConfig)
--   }