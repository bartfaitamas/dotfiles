{-# LANGUAGE OverloadedStrings #-}
import XMonad
import XMonad.Util.EZConfig
import XMonad.Actions.Warp
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Grid

import XMonad.Util.WindowProperties

import qualified DBus.Client.Simple as D
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.StackSet as W

import Data.Ratio ((%))
import Control.Monad

-- workaround a bug in xmonad not showing Java/Swing applications
-- http://mth.io/posts/xmonad-java-focus/
atom_WM_TAKE_FOCUS ::
  X Atom
atom_WM_TAKE_FOCUS =
  getAtom "WM_TAKE_FOCUS"

takeFocusX ::
  Window
  -> X ()
takeFocusX w =
  withWindowSet . const $ do
    dpy       <- asks display
    wmtakef   <- atom_WM_TAKE_FOCUS
    wmprot    <- atom_WM_PROTOCOLS
    protocols <- io $ getWMProtocols dpy w
    when (wmtakef `elem` protocols) $
      io . allocaXEvent $ \ev -> do
        setEventType ev clientMessage
        setClientMessageEvent ev w wmprot 32 wmtakef currentTime
        sendEvent dpy w False noEventMask ev

takeTopFocus ::
  X ()
takeTopFocus =
  withWindowSet $ maybe (setFocusX =<< asks theRoot) takeFocusX . W.peek


myBaseConfig = gnomeConfig

myManageHook = composeAll userDefinedHooks <+> manageHook myBaseConfig
  where
    userDefinedHooks =
      [ imClientHook
      , allowFullscreenHook
      ]

    isIM = isApplicationGroup ["Pidgin", "Skype", "Empathy"]

    isApplicationGroup :: [String] -> Query Bool
    isApplicationGroup = foldr1 (<||>) . map (className =?)

    imClientHook = isIM --> doShift "8"

    allowFullscreenHook = isFullscreen --> doFullFloat

myLayoutHook = smartBorders $ avoidStruts $ onWorkspace "8" imLayout $ standardLayouts
  where
    --                    numMasters, resizeIncr, splitRatio
    tall            = Tall 1          0.02        0.5
    standardLayouts = tall ||| Mirror tall ||| Full

    rosters         = Or skypeRoster pidginRoster
    pidginRoster    = And (ClassName "Pidgin") (Role "buddy_list")
    skypeRoster     = ClassName "Skype" `And`
                      Not (Title "Options") `And`
                      Not (Role "Chats") `And`
                      Not (Role "CallWindowForm")
    imLayout        = withIM (1%7) rosters Grid
--    imLayout        = withIM (1%7) (Role "buddy_list") Grid

main :: IO ()
main = do
  dbus <- D.connectSession
  getWellKnownName dbus
  xmonad $ withUrgencyHook NoUrgencyHook $ myBaseConfig
    { terminal   = "urxvtcd -e byobu"
    , modMask    = mod4Mask
    , manageHook = myManageHook
    , layoutHook = myLayoutHook -- smartBorders (layoutHook myBaseConfig)
    , logHook    = takeTopFocus >> setWMName "LG3D" >> dynamicLogWithPP (prettyPrinter dbus)
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