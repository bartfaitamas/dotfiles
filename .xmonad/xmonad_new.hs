import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig

import XMonad.Actions.Warp
import Graphics.X11.ExtraTypes.XF86

import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.PerWorkspace

import System.IO
import qualified XMonad.StackSet as W

import XMonad.Prompt
import XMonad.Prompt.Shell

myLayout = avoidStruts $ smartBorders $ onWorkspace "8" imLayout $ standardLayouts
  where
    --          numMaster, resizeIncr, splitRatio
    tall = Tall 1          0.02        0.5
    standardLayouts = tall ||| Mirror tall ||| Full

    -- notice that withIM, which normally acts on one workspace, can
    -- also work on a list of workspaces (yay recursive data types!)
    skypeMainWindow = And (ClassName "Skype") (Not (Role "ConversationWindow"))
    imLayout = withIM (1/10) skypeMainWindow Grid

-- myManageHook = manageDocks <+> manageHook defaultConfig
myManageHook = composeAll [ className =? "Skype" --> doShift "8"
                          , manageDocks
                          , manageHook defaultConfig
                          ]


main = do
  xmproc <- spawnPipe "/home/tomb/.cabal/bin/xmobar /home/tomb/.xmobarrc"
  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    , terminal = "urxvtcd -e byobu"
    , focusFollowsMouse = False
    , manageHook = myManageHook
    , layoutHook = myLayout
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip
                }
    , startupHook = ewmhDesktopsStartup >> setWMName "LG3D"
    , modMask = mod4Mask
    } `additionalKeys`
    [ ((mod4Mask, xK_z), banishScreen LowerLeft)
    , ((mod4Mask, xK_KP_Begin), spawn "mpc toggle")
    , ((mod4Mask, xK_KP_Left), spawn "mpc prev")
    , ((mod4Mask, xK_KP_Right), spawn "mpc next")
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((mod4Mask .|. controlMask, xK_x), shellPrompt defaultXPConfig)

--    , ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle") -- doesn't work with pulseaudio + alsa :(
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
    ]
