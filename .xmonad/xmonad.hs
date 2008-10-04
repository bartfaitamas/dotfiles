{-# OPTIONS_GHC -cpp #-}

{-
#include <X11/XF86keysym.h>
-}

import XMonad
import XMonad.Layout
import XMonad.Config (defaultConfig)
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

-- for managehook
import XMonad.ManageHook
import qualified XMonad.StackSet as W
import XMonad.Hooks.XPropManage
import Data.List

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks

-- import XMonad.Actions.RotSlaves
import XMonad.Actions.Submap


import XMonad.Prompt             ( defaultXPConfig, XPConfig(..), XPPosition(..) )
import XMonad.Prompt.Shell       ( shellPrompt )
import XMonad.Prompt.Ssh
import XMonad.Prompt.Man

import Data.Bits
import qualified Data.Map as M
import XMonad.Util.Run (spawnPipe)
import System.IO (hPutStrLn)
import Graphics.X11

myNormalBorderColor = "grey30"
-- myFocusedBorderColor = "#aecf96"
myFocusedBorderColor = "red"
myBGColor = "#2c2c32"
myFGColor = "grey70"
myActiveFGColor = "#a6c292"
myActiveBGColor = "#3d4736"
myFont = "-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859-*"


tombSPConfig :: XPConfig
tombSPConfig  = defaultXPConfig {
                  font              = myFont
                , bgColor           = myBGColor
                , fgColor           = myFGColor
                , bgHLight          = "#aecf96"
                , fgHLight          = "black"
                , borderColor       = "red"
                , promptBorderWidth = 0
                , position          = Bottom
                , height            = 15
                , historySize       = 256
                , defaultText       = []
                }


main :: IO ()
main = do 
  xmobar <- spawnPipe "xmobar"
  xmonad $ withUrgencyHook NoUrgencyHook
       $ defaultConfig
       { modMask            = mod4Mask
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , terminal           = "x-terminal-emulator"
       , workspaces         = ["1:web", "2:dev", "3:srv", "4:comm", "5:adm", "6:tmp", "7:remote"]
       , logHook            = tombXmobarLogHook xmobar
       , layoutHook         = tombLayoutHook
       , manageHook         = newManageHook
       , keys               = \c -> tombKeys c `M.union` keys defaultConfig c
       }
    where
      tombManageHook = composeAll [ className =? "firefox-bin"              --> doF (W.shift "web")
                                  , className =? "gtk-theme-switch2"        --> doFloat
                                  , className =? "netbeans"                 --> doF (W.shift "dev")
                                  ]
      xPropMatches :: [XPropMatch]
      xPropMatches = [ ([ (wM_CLASS, any ("firefox-bin"==))], pmP (W.shift "web"))
                     , ([ (wM_CLASS, any ("gtk-theme-switch2"==))], pmX (float))
                     , ([ (wM_CLASS, any ("skype"==))], pmX (float))
                     , ([ (wM_CLASS, any ("netbeans" `isInfixOf`))], pmP (W.shift "dev"))
                     ]
      -- newManageHook = tombManageHook <+> manageHook defaultConfig
      newManageHook = xPropManageHook xPropMatches <+> manageHook defaultConfig
-- ||| tabbed shrinkText defaultTheme
tombLayoutHook = avoidStruts $ noBorders Full ||| tabbed shrinkText defaultTheme ||| Mirror tiled ||| tiled
    where
      tiled = Tall nmaster delta ratio
      nmaster = 1                                -- The default number of windows in the master pane
      ratio = toRational (2/(1+sqrt(5)::Double)) -- golden
      delta = 0.03                               -- Percent of screen to increment by when resizing



tombKeys (XConfig {modMask = modm}) = M.fromList $
                                      [ 
                                       ((modm,                 xK_p), shellPrompt tombSPConfig) 
                                      , ((controlMask .|. modm, xK_s), sshPrompt tombSPConfig)
                                      , ((modm,                 xK_F1), manPrompt tombSPConfig)
                                      -- multimedia keys
                                      , ((modm,                 xK_KP_Add),       spawn "amixer -q set PCM 2dB+")
                                      , ((modm,                 xK_KP_Subtract),  spawn "amixer -q set PCM 2dB-")
                                      , ((modm,                 xK_KP_Enter),     spawn "amixer -q set PCM toggle")
                                      , ((modm,                 xK_KP_Begin),     spawn "mpc toggle")
                                      , ((modm,                 xK_KP_5),         spawn "mpc toggle")
                                      , ((modm,                 xK_KP_Right),     spawn "mpc next")
                                      , ((modm,                 xK_KP_6),         spawn "mpc next")
                                      , ((modm,                 xK_KP_Left),      spawn "mpc prev")
                                      , ((modm,                 xK_KP_4),         spawn "mpc prev")
                                      , ((0, XF86XK_AudioLowerVolume),            spawn "amixer -q set PCM 2dB-")
                                      , ((0, XF86XK_AudioRaiseVolume),            spawn "amixer -q set PCM 2dB+")
                                      , ((0, XF86XK_AudioPause),                  spawn "mpc toggle")
                                      , ((0, XF86XK_AudioStop),                   spawn "mpc stop")
                                      ]

tombXmobarLogHook xmobar = dynamicLogWithPP defaultPP {
                             ppUrgent   = xmobarColor "white" "red" . wrap "!!!!!!" "!!!!!!"
                           , ppCurrent  = xmobarColor "white" "" -- . wrap "[" "]"
                           , ppTitle    = xmobarColor myActiveFGColor "" . shorten 160
                           , ppVisible  = xmobarColor myActiveFGColor "" -- wrap "(" ")"
                           , ppOutput   = hPutStrLn xmobar
                           }
