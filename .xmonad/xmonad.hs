import XMonad

import Control.OldException(catchDyn,try)
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.CycleWS
import XMonad.Actions.Warp

import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Layout.NoBorders

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Actions.CycleWS


import DBus
import DBus.Connection
import DBus.Message

main = withConnection Session $ \ dbus -> do
  getWellKnownName dbus
  xmonad $ withUrgencyHook NoUrgencyHook $ gnomeConfig 
       { borderWidth         = 2
       , terminal            = "urxvt"
       , modMask             = mod4Mask
       , keys                = myKeys
       , logHook             = dynamicLogWithPP (myPrettyPrinter dbus)
       , normalBorderColor   = "#cccccc"
       , focusedBorderColor  = "#cd8b00" }
       
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modMask .|. shiftMask, xK_l     ), spawn $ "xlock -mode blank")
    -- launch dmenu
    , ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")

      -- banish mouse cursor out of the way
    , ((modMask,               xK_z     ), banishScreen LowerLeft)
    -- close focused window 
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- move focus between screens
    , ((modMask .|. controlMask, xK_Right ), prevScreen)
    , ((modMask .|. controlMask, xK_Left ), nextScreen)
    , ((modMask .|. controlMask, xK_o ), shiftNextScreen)

    , ((modMask                , xK_BackSpace), focusUrgent)
    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modMask              , xK_b     ),

    -- Quit xmonad
    --, ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modMask .|. shiftMask,   xK_q     ), spawn "gnome-session-save --gui --logout-dialog")

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    , ((modMask,                 xK_KP_Add),       spawn "amixer -c 0 -q set PCM 2dB+")
    , ((modMask,                 xK_KP_Subtract),  spawn "amixer -c 0 -q set PCM 2dB-")
    , ((modMask,                 xK_KP_Enter),     spawn "amixer -c 0 -q set PCM toggle")
    , ((modMask,                 xK_KP_Begin),     spawn "mpc toggle")
    , ((modMask,                 xK_KP_5),         spawn "mpc toggle")
    , ((modMask,                 xK_KP_Right),     spawn "mpc next")
    , ((modMask,                 xK_KP_6),         spawn "mpc next")
    , ((modMask,                 xK_KP_Left),      spawn "mpc prev")
    , ((modMask,                 xK_KP_4),         spawn "mpc prev")
    --, ((0, XF86XK_AudioLowerVolume),            spawn "amixer -c 0 -q set PCM 2dB-")
    --, ((0, XF86XK_AudioRaiseVolume),            spawn "amixer -c 0 -q set PCM 2dB+")
    --, ((0, XF86XK_AudioPause),                  spawn "mpc toggle")
    --, ((0, XF86XK_AudioStop),                   spawn "mpc stop")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


myPrettyPrinter :: Connection -> PP
myPrettyPrinter dbus = defaultPP {
  ppOutput  = outputThroughDBus dbus
  , ppTitle   = pangoColor "#003366" . shorten 50 . pangoSanitize
  , ppCurrent = pangoColor "#006666" . wrap "[" "]" . pangoSanitize
  , ppVisible = pangoColor "#663366" . wrap "(" ")" . pangoSanitize
  , ppHidden  = wrap " " " "
  , ppUrgent  = pangoColor "red"
  }
   
-- This retry is really awkward, but sometimes DBus won't let us get our
-- name unless we retry a couple times.
getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\ (DBus.Error _ _) ->
                                                getWellKnownName dbus)
  where
    tryGetName = do
      namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
      addArgs namereq [String "org.xmonad.Log", Word32 5]
      sendWithReplyAndBlock dbus namereq 0
      return ()

       
outputThroughDBus :: Connection -> String -> IO ()
outputThroughDBus dbus str = do
  let str' = "<span font=\"Terminus 9 Bold\">" ++ str ++ "</span>"
  msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
  addArgs msg [String str']
  send dbus msg 0 `catchDyn` (\ (DBus.Error _ _ ) -> return 0)
  return ()    
  
pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  acc = "&gt;" ++ acc
    sanitize '<'  acc = "&lt;" ++ acc
    sanitize '\"' acc = "&quot;" ++ acc
    sanitize '&'  acc = "&amp;" ++ acc
    sanitize x    acc = x:acc
   
