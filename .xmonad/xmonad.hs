import XMonad
import XMonad.Layout
import XMonad.Config (defaultConfig)
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
-- import XMonad.Hooks.SetWMName

--import XMonad.Actions.RotView
import XMonad.Actions.Submap


import XMonad.Prompt             ( XPConfig(..), XPPosition(..) )
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
myFocusedBorderColor = "black"
myBGColor = "#2c2c32"
myFGColor = "grey70"
myActiveFGColor = "#a6c292"
myActiveBGColor = "#3d4736"
myFont = "-*-profont-*-*-*-*-11-*-*-*-*-*-iso8859-*"

main :: IO ()
main = do 
  xmobar <- spawnPipe "xmobar"
  xmonad $ withUrgencyHook NoUrgencyHook
       $ defaultConfig
       { modMask            = mod4Mask
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , terminal           = "x-terminal-emulator"
       , workspaces         = ["1:web", "2:dev", "3:plan", "4:srv", "5:comm", "6:adm", "7:remote"]
       , logHook            = tombXmobarLogHook xmobar
       , layoutHook         = tombLayoutHook
       , keys               = \c -> tombKeys c `M.union` keys defaultConfig c
--       , startupHook        = setWMName "LG3D"
       }
    where

      tombLayoutHook = avoidStruts $ noBorders Full ||| tabbed shrinkText defaultTheme ||| Mirror tiled ||| tiled
          where
            tiled = Tall nmaster delta ratio
            nmaster = 1                                -- The default number of windows in the master pane
            ratio = toRational (2/(1+sqrt(5)::Double)) -- golden
            delta = 0.03                               -- Percent of screen to increment by when resizing


      tombSPConfig  = XPC {
                        font              = myFont
                      , bgColor           = myBGColor
                      , fgColor           = myFGColor
                      , bgHLight          = "#aecf96"
                      , fgHLight          = "black"
                      , borderColor       = "black"
                      , promptBorderWidth = 0
                      , position          = Bottom
                      , height            = 15
                      , historySize       = 256
                      , defaultText       = []
                      }

      tombKeys (XConfig {modMask = modm}) = M.fromList $
                                             [ ((modm,                 xK_p), shellPrompt tombSPConfig) 
                                             , ((controlMask .|. modm, xK_s), sshPrompt tombSPConfig)
                                             , ((modm,                 xK_F1), manPrompt tombSPConfig)
                                             , ((shiftMask .|. modm, xK_l),    spawn "xlock -mode blank")
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
                                             ]

      tombXmobarLogHook xmobar = dynamicLogWithPP defaultPP {
                                    ppUrgent   = xmobarColor "white" "red" . wrap "!!!!!!!!!!!!" "!!!!!!!!!!!!"
                                  , ppCurrent  = xmobarColor "white" "" -- . wrap "[" "]"
                                  , ppTitle    = xmobarColor myActiveFGColor "" . shorten 160
                                  , ppVisible  = xmobarColor myActiveFGColor "" -- wrap "(" ")"
                                  , ppOutput   = hPutStrLn xmobar
                                  }
