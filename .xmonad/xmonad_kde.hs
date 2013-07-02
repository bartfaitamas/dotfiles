{-# LANGUAGE OverloadedStrings, FlexibleInstances, MultiParamTypeClasses, TypeSynonymInstances, FlexibleContexts, NoMonomorphismRestriction #-}
import XMonad
import XMonad.Util.EZConfig
import XMonad.Actions.Warp
import XMonad.Config.Kde
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier

import XMonad.Util.Run(spawnPipe)
import XMonad.Util.WindowProperties

--import qualified DBus.Client.Simple as D
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.StackSet as W

import Data.Ratio ((%))
import Control.Monad

-- workaround a bug in xmonad not showing Java/Swing applications
-- http://mth.io/posts/xmonad-java-focus/
--atom_WM_TAKE_FOCUS :: X Atom
--atom_WM_TAKE_FOCUS = getAtom "WM_TAKE_FOCUS"

takeFocusX :: Window -> X ()
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

takeTopFocus :: X ()
takeTopFocus = withWindowSet $ maybe (setFocusX =<< asks theRoot) takeFocusX . W.peek


--myBaseConfig = kde4Config
myBaseConfig = defaultConfig

myManageHook = composeAll userDefinedHooks <+> (krunnerRule --> manageHook myBaseConfig)
  where
    krunnerRule = (className =? "krunner") >>= return . not
    userDefinedHooks =
      [ imClientHook
      , allowFullscreenHook
      , kdeOverride --> doFloat
      ]

    isIM = isApplicationGroup ["Pidgin", "Skype", "Empathy"]

    isApplicationGroup :: [String] -> Query Bool
    isApplicationGroup = foldr1 (<||>) . map (className =?)

    imClientHook = isIM --> doShift "8"

    allowFullscreenHook = isFullscreen --> doFullFloat

kdeOverride :: Query Bool
kdeOverride = ask >>= \w -> liftX $ do
  override <- getAtom "_KDE_NET_WM_WINDOW_TYPE_OVERRIDE"
  wt <- getProp32s "_NET_WM_WINDOW_TYPE" w
  return $ maybe False (elem $ fromIntegral override) wt

myLayoutHook = smartBorders $ avoidStruts $ imWorkspace $ emacsWorkspace $ standardLayouts
  where
    --                    numMasters, resizeIncr, splitRatio
    tall            = Tall 1          0.02        0.5
    standardLayouts = tall ||| Mirror tall ||| Full

    rosters         = [skypeRoster, pidginRoster]
    pidginRoster    = And (ClassName "Pidgin") (Role "buddy_list")
    skypeRoster     = (ClassName "Skype") `And`
                      (Not (Title "Options")) `And`
                      (Not (Role "Chats")) `And`
                      (Not (Role "CallWindow")) `And`
                      (Not (Role "ConversationsWindow")) `And`
                      (Not (Role "CallWindowForm"))
    imLayout        = withIMs (1%7) rosters Grid
--    imLayout        = withIM (1%7) (Role "buddy_list") Grid

    speedbar        = (Title "Speedbar 1.0")
    emacsLayout     = withIM (1%7) speedbar standardLayouts

    imWorkspace     = onWorkspace "8" imLayout
    emacsWorkspace  = onWorkspace "2" emacsLayout

main :: IO ()
main = do
  dbus <- D.connectSession
  getWellKnownName dbus
  xmproc <- spawnPipe "/home/tomb/.cabal/bin/xmobar"
  xmonad $ withUrgencyHook NoUrgencyHook $ myBaseConfig
    { --terminal   = "urxvtcd -e byobu"
      terminal     = "konsole -e byobu"
    , focusFollowsMouse = False
    , modMask    = mod4Mask
    , manageHook = myManageHook
    , layoutHook = myLayoutHook -- smartBorders (layoutHook myBaseConfig)
--    , logHook    = takeTopFocus >> setWMName "LG3D" >> dynamicLogWithPP (prettyPrinter dbus)
    , logHook    = dynamicLogWithPP (prettyPrinter dbus)
    }
    `additionalKeysP`
    [ ("M-z", banishScreen LowerLeft)
--    , ("M-S-q", spawn "gnome-session-quit")
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
    [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
  let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {
        D.signalBody = [D.toVariant (UTF8.decodeString str)]
        }
  D.emit dbus signal

-- dbusOutput :: DC -> String -> IO ()
-- dbusOutput dbus str = D.emit dbus
--                       "/org/xmonad/Log"
--                       "org.xmonad.Log"
--                       "Update"
--                       [D.toVariant ("<b>" ++ (UTF8.decodeString str) ++ "</b>")]

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
gridIMs :: Rational -> [Property] -> ModifiedLayout AddRosters Grid a
gridIMs ratio props = withIMs ratio props Grid

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
    let (rostersRect, chatsRect) = splitHorizontallyBy (n * ratio) rect
    let rosterRects = splitHorizontally n rostersRect
    let filteredStack = stack >>= W.filter (`notElem` rosters)
    (a,b) <- runLayout (wksp {W.stack = filteredStack}) chatsRect
    return (zip rosters rosterRects ++ a, b)

-- main = xmonad $ gnomeConfig
--   { terminal = "urxvtcd"
--   , modMask = mod4Mask
--   , layoutHook = smartBorders (layoutHook gnomeConfig)
--   }
