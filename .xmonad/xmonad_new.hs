{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses, TypeSynonymInstances, FlexibleContexts, NoMonomorphismRestriction #-}

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.WindowProperties

import XMonad.Actions.Warp

import XMonad.Layout.LayoutModifier
import XMonad.Layout.NoBorders
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.SimpleFloat

import XMonad.Prompt
import XMonad.Prompt.Shell

import qualified XMonad.StackSet as W

import System.IO
import System.Exit

import Data.Ratio
import Control.Monad
import Graphics.X11.ExtraTypes.XF86

promptExit = do
  response <- runProcessWithInput "dmenu" ["-p", "Really quit?"] "no\nyes\n"
  when (response == "yes") (io exitSuccess)

myLayout = avoidStruts $ smartBorders $ onWorkspace "8" imLayout $ onWorkspace "9" withFloat $ standardLayouts
  where
    rosters            = [skypeRoster, hangoutsRoster]
    skypeRoster        = (ClassName "Skype") `And` (Not (Role "ConversationsWindow")) `And` (Not (Title "Options")) `And` (Not (Role "CallWindow"))
    hangoutsRoster     = (ClassName "Chromium-browser") `And` (Title "Hangouts")
    imLayout           = withIMs (1%6) rosters Grid -- (Grid ||| simpleTabbed) <-- multiple layouts doesn't work here

    --                        numMaster, resizeIncr, splitRatio
    tall               = Tall 1          0.02        0.5
    standardLayouts    = Full ||| tall ||| Mirror tall
    withFloat          = Full ||| tall ||| simpleFloat

-- myManageHook = manageDocks <+> manageHook defaultConfig
myManageHook = composeAll [ className =? "Skype" --> doShift "8"
                          , title =? "Hangouts" --> doShift "8"
                          , isDialog --> doFloat
                          , manageDocks
                          , manageHook defaultConfig
                          ]


main = do
  xmproc <- spawnPipe "/home/tomb/.cabal/bin/xmobar /home/tomb/.xmobarrc"
  xmonad $ withUrgencyHook NoUrgencyHook defaultConfig
    { workspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    , terminal = "urxvtcd"
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
    , ((mod4Mask .|. shiftMask, xK_q), promptExit)
    , ((mod4Mask .|. controlMask, xK_x), shellPrompt defaultXPConfig)

--    , ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle") -- doesn't work with pulseaudio + alsa :(
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2-")
    ]



-- modified version of XMonad.Layout.IM --

-- | Data type for LayoutModifier which converts given layout to IM-layout
-- (with dedicated space for the roster and original layout for chat windows)
data AddRosters a = AddRosters Rational [Property] deriving (Read, Show)

instance LayoutModifier AddRosters Window where
  modifyLayout (AddRosters ratio props) = applyIMs ratio props
  modifierDescription _                = "IMs"

-- | Modifier which converts given layout to IMs-layout (with dedicated
-- space for rosters and original layout for chat windows)
withIMs :: LayoutClass l a => Rational -> [Property] -> l a -> ModifiedLayout AddRosters l a
withIMs ratio props = ModifiedLayout $ AddRosters ratio props

-- | IM layout modifier applied to the Grid layout
--gridIMs :: Rational -> [Property] -> ModifiedLayout AddRosters Grid a
--gridIMs ratio props = withIMs ratio props Grid

hasAnyProperty :: [Property] -> Window -> X Bool
hasAnyProperty [] _ = return False
hasAnyProperty (p:ps) w = do
    b <- hasProperty p w
    if b then return True else hasAnyProperty ps w

-- | Internal function for placing the rosters specified by
-- the properties and running original layout for all chat windows
applyIMs :: (LayoutClass l Window) =>
               Rational
            -> [Property]
            -> W.Workspace WorkspaceId (l Window) Window
            -> Rectangle
            -> X ([(Window, Rectangle)], Maybe (l Window))
applyIMs ratio props wksp rect = do
    let stack = W.stack wksp
    let ws = W.integrate' $ stack
    rosters <- filterM (hasAnyProperty props) ws
    let n = fromIntegral $ length rosters
    let (rostersRect, chatsRect) = splitHorizontallyBy ratio rect
--    let rosterRects = splitHorizontally n rostersRect
    let rosterRects = splitVertically n rostersRect
    let filteredStack = stack >>= W.filter (`notElem` rosters)
    (a,b) <- runLayout (wksp {W.stack = filteredStack}) chatsRect
    return (zip rosters rosterRects ++ a, b)
