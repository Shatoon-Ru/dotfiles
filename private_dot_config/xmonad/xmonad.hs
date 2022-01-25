 -- Конфигурация xmonad для рабочего стола X Window
 -- Дата основания: 03.12.2021
 -- Содержание
 --
 --    I. Секция импорта библиотек
 --   II. Секция задания переменных
 --  III. Секция автозагрузки внешних программ
 --   IV. Секция имен рабочих виртуальных столов (пространств)
 --    V. Сетка выбора активных приложений.
 --   VI. Секция настройка Scratchpad (фоновые окна)
 --  VII. Секция расположений окон, в том числе на различных столах (Layout)
 --   IV. Секция заглушек поведения специфических приложений
 --    V. Секция офрмления xmobar (цвета, шрифты)
 --   VI. Секция привязки мыши
 -- VIII. Секция конфигураций
 --   IX. Секция привязки клавиш
 --    X. Секция главной функции main - точка входа
 --     . Дополнительная инфомация
 --     . Ресурсы

 ----------------------------------------------------------------------------------------
 --    I. Секция импорта библиотек (подключение пространств иимен)
 ----------------------------------------------------------------------------------------
  -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W


  -- Actions
import XMonad.Actions.GridSelect --Выбор сетки отображает элементы(например, открытые окна) в 2D-сетке и позволяет пользователю выбирать из нее с помощью клавиш курсора/hjkl или мыши.
import XMonad.Actions.MouseResize --Обычно этот модуль используется для создания макетов, но вы также можете использовать его для изменения размера окон в любом макете вместе с  XMonad.Layout.WindowArranger. 
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops        -- Заставляет xmonad использовать подсказки EWMH, чтобы сообщать панельным приложениям о своих рабочих пространствах и окнах в них. Он также позволяет пользователю взаимодействовать с xmonad, нажимая на панели и списки окон.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..)) -- Управляет выделением места на экране
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat) -- Вспомогательные функции размещения
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory
import XMonad.ManageHook
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP


    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile        -- изменение размеров
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns            -- Расположение окон в три колонки 

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier               -- Позволяет увеличивать размер окна
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders   -- Окна без рамок
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing              -- Визуальные разрывы между окнами
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

 --import XMonad.Layout.PerWorkspace          -- Разные расположения для столов
 --import XMonad.Layout.IM              -- Расположение для мессенджеров
 --import XMonad.Layout.Grid            -- Расположение - сетка окон 
 --import XMonad.Layout.SimpleDecoration        -- Простой декор вокруг окна
 --import XMonad.Layout.BorderResize


   -- Utilities
import XMonad.Util.SpawnOnce                    -- автостарт прогармм
import XMonad.Util.NamedScratchpad
import XMonad.Util.EZConfig (additionalKeysP)   -- Привязка клавиш
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.Dmenu
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)



   -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.OceanicNext


 --
 ----------------------------------------------------------------------------------------
 --   II. Секция задания переменных
 ----------------------------------------------------------------------------------------
myModAlt   = mod1Mask            -- Клавиша модификатор  
freeSpaces = 3                   -- Расстояние между окнами                    

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask             -- Устанавливает modkey на кнопку windows

myTerminal :: String
myTerminal = "alacritty"         -- Устанавливает терминал по умолчанию

myBrowser :: String
myBrowser = "qutebrowser "       -- Sets qutebrowser as browser

myEmacs :: String
myEmacs = "emacsclient -c -a 'emacs' "  -- Упрощает ввод сочетаний клавиш emacs 

myEditor :: String
--myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
myEditor = myTerminal ++ " -e nvim "    -- Sets neovim as editor

myBorderWidth :: Dimension
myBorderWidth = 2                -- Sets border width for windows

myNormColor :: String            -- Border color of normal windows
myNormColor   =  colorBack       -- This variable is imported from Colors.THEME

myFocusColor :: String           -- Border color of focused windows
myFocusColor  = color15          -- This variable is imported from Colors.THEME

--windowCount :: X (Maybe String)
--windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset



 ----------------------------------------------------------------------------------------
 --  III. Секция автозагрузки внешних программ
 ----------------------------------------------------------------------------------------
myStartupHook :: X ()
myStartupHook = do
    --spawn "killall conky"   -- kill current conky on each restart
    spawn "killall trayer"  -- kill current trayer on each restart

    spawnOnce "setxkbmap -model pc105 -layout us,ru, -option grp:alt_shift_toggle"
    spawnOnce "lxsession"
    spawnOnce "redshift-gtk"
    spawnOnce "touchpad-indicator"
    spawnOnce "picom -b --config ~/.config/picom.conf"
    spawnOnce "nm-applet"
    spawnOnce "volumeicon"
    spawnOnce "/usr/bin/emacs --daemon" -- emacs daemon for the emacsclient
    --spawnOnce "/usr/lib/polkit-kde-authentication-agent-1" --polkin kde

    --spawn ("sleep 2 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")

    spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --width 10 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 18")

    -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"
    -- spawnOnce "~/.fehbg &"  -- set last saved feh wallpaper
    -- spawnOnce "feh --randomize --bg-fill ~/wallpapers/*"  -- feh set random wallpaper
    spawnOnce "nitrogen --restore &"   -- if you prefer nitrogen to feh
    setWMName "LG3D"
 ----------------------------------------------------------------------------------------
 --   IV. Секция имен рабочих виртуальных столов (пространств)
 ----------------------------------------------------------------------------------------
-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

 ----------------------------------------------------------------------------------------
 --  V. Сетка выбора активных приложений.
 ----------------------------------------------------------------------------------------


myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myAppGrid = [ ("Audacity", "audacity")
                 , ("Deadbeef", "deadbeef")
                 , ("Emacs", "emacsclient -c -a emacs")
                 , ("Firefox", "firefox")
                 , ("Geany", "geany")
                 , ("Geary", "geary")
                 , ("Gimp", "gimp")
                 , ("Kdenlive", "kdenlive")
                 , ("LibreOffice Impress", "loimpress")
                 , ("LibreOffice Writer", "lowriter")
                 , ("OBS", "obs")
                 , ("PCManFM", "pcmanfm")
                 ]
 ----------------------------------------------------------------------------------------
 --  VI. Секция настройка Scratchpad (фоновые окна)
 ----------------------------------------------------------------------------------------
 
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnMocp  = myTerminal ++ " -t mocp -e mocp"
    findMocp   = title =? "mocp"
    manageMocp = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnCalc  = "qalculate-gtk"
    findCalc   = className =? "Qalculate-gtk"
    manageCalc = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.75 -h
                 l = 0.70 -w


 ----------------------------------------------------------------------------------------
 --  VII. Секция расположений окон, в том числе на различных столах
 ----------------------------------------------------------------------------------------
 -- Стандартные расположения
-- Tall разделение по вертикали на главную и вспомогательную части
 -- Mirror Tall - раделение по горизонтали на главную и вспомогательную части
 -- Full -полноэкранное расположение, переключение между окнами mod+tab
 -- ThreeColMid - расположение в три колонки с мастером в середине
 -- spacing - добаляет промежутки между окнами
 -- magnifiercz - увеличивает окно на заданную величину, только для окон стека
{- myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = spacing freeSpaces $ Tall nmaster delta ratio
    nmaster  = 1      -- Количество окон по умолчанию в главной панели
    ratio    = 1/2    -- Пропорция экрана по умолчанию, занятая главной панелью
    delta    = 1/100  -- Процент экрана для увеличения при изменении размера панелей
    -}
 -- myLayout = tiled ||| Mirror tiled ||| Full ||| ThreeColMid 1 (3/100) (1/2) как вариант можно вместо where указать необходимые пропорции пространства прямо в имени раскладки
 -- 
 -- Для каждого монитора, в мултимониторной конфигурации (Xinerama) может быть
 -- несколько рабочих столов
 -- Для каждого стола может быть несколько расположений (one-to-many,1-N)
 -- перечисление (выбор) задается оператором |||, а расположения помещаются в скобки

 -- Сейчас один монитор

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
mymagnify  = renamed [Replace "magnify"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ windowNavigation
           $ magnifiercz' 1.3
           -- $ ThreeColMid
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (1/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"]
           $ Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| mymagnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tallAccordion
                                 ||| wideAccordion

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ className =? "confirm"         --> doFloat
     , className =? "file_progress"   --> doFloat
     , className =? "dialog"          --> doFloat
     , className =? "download"        --> doFloat
     , className =? "error"           --> doFloat
     , className =? "Gimp"            --> doFloat
     , className =? "notification"    --> doFloat
     , className =? "pinentry-gtk-2"  --> doFloat
     , className =? "splash"          --> doFloat
     , className =? "toolbar"         --> doFloat
     , className =? "Yad"             --> doCenterFloat
     , title =? "Oracle VM VirtualBox Manager"  --> doFloat
     , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
     , className =? "Brave-browser"   --> doShift ( myWorkspaces !! 1 )
     , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
     , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
     , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
     , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
     , isFullscreen -->  doFullFloat
     ] <+> namedScratchpadManageHook myScratchPads



 ---------------------------------------------------------------------------------------
 --   IV. Секция заглушек для специфической обработки программ, всплывающих окон и пр.
 ----------------------------------------------------------------------------------------

 -- Это то место, где можно настроить  поведение при запуске сложных многооконных программ
 -- Для определения класса окна, надо запустить специальную программу xprop
 --
 -- className =? "Firefox"
 -- title =? "Firefox"
 -- appName =? "Firefox"
 -- (getStringProperty "WM_ROLE") =? "Roster window"

 -- Сложные программы для размещения, это мессенджеры, gimp и т.п.

-- Для диалоговых окон - размещение по центру, плавающими
 -- Графический редактор GIMP
 -- 2 режима отображения поддерживается: отдельные окна и однооконный
 -- Однооконный режим позволяет использовать Gimp в компоновке полного экрана
 -- Многооконный режим надо настраивать поведение отдельных оконных ролей
 -- главное окно изображения WM_WINDOW_ROLE(STRING) = "gimp-image-window"
 -- панель вкладок WM_WINDOW_ROLE(STRING) = "gimp-dock"
 -- панель инструментов WM_WINDOW_ROLE(STRING) = "gimp-toolbox"

 ----------------------------------------------------------------------------------------
 --    V. Секция оформления xmobar (цвета, шрифты и т.п.)
 ----------------------------------------------------------------------------------------
 -- Определения цветов задаются в 24-битном пространстве RGB

-- https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Hooks-DynamicLog.html#t:PP
-- ppTitle формирует заголовок текущего фокусного окна
-- ppCurent формирует текущее рабочее пространство
-- ppHidden для скрытых рабочих пространств, на которых есть окна и т.д.
-- Остальные простов выбирают красивые цвета и форматируют элементы бара
-- ppOrder По умолчанию эта функция получает список с тремя отформатированными строки, представляющие рабочие области, макет и текущую заголовок окна соответственно. Если вы указали дополнительные регистраторы в ppExtras их вывод также будет добавлен в список. 

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

-- цветовое_оформление = defaultTheme

    -- { activeColor         = "orange"    -- цвет активного окна
    -- , inactiveColor       = "#222222"    -- цвет неактивного окна
    -- , urgentColor         = "yellow"    -- не знаю
    -- , activeBorderColor   = "orange"    -- цвет рамки активного окна
    -- , inactiveBorderColor = "#222222"    -- цвет рамки неактивного окна
    -- , urgentBorderColor   = "yellow"    -- цвет рамки какого-то окна
    -- , activeTextColor     = "black"    -- цвет текста активного окна
    -- , inactiveTextColor   = "#222222"    -- цвет текста неактивного окна
    -- , urgentTextColor     = "yellow"    -- цвет текста какого-то окна
    -- , fontName           = "-*-terminus-bold-*-*-*-16-*-*-*-*-*-*-u" -- шрифт
    -- , decoWidth      = 100
    -- , decoHeight          = 20
    -- , windowTitleAddons = [("<<<", AlignRight)] -- Заголовок окна и его размещение
    -- , windowTitleIcons    = []
    -- }

 -- Сформировать строку шрифта можно с помощью программы xfontsel

----------------------------------------------------------------------------------------
 --  VI. Секция привязки кнопок мыши
 ----------------------------------------------------------------------------------------
 -- клавиши_мыши = [ ((mod4Mask, button4),\_-> spawn "amixer set Master 3%+") 
 --     ,((mod4Mask, button5),\_-> spawn "amixer set Master 3%-") 
 --     ,((mod4Mask, button3),\_-> return()) 
 --     ,((mod4Mask, button1),\_-> return()) 
 --     ]

 ----------------------------------------------------------------------------------------
 --   VIII. Секция  мой конфиг
 ----------------------------------------------------------------------------------------
myConfig = def
    { modMask            = myModMask    
    , terminal           = myTerminal 
    , startupHook        = myStartupHook
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
  --  , layoutHook         = myLayout 
    , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces         = myWorkspaces
    , manageHook = myManageHook
    } `additionalKeysP` myKeys
----------------------------------------------------------------------------------------
--   IX. Секция привязки клавиш
----------------------------------------------------------------------------------------

-- Доступные операции можно найти в XMonad.Operations
-- http://www.haskell.org/haskellwiki/Xmonad/Key_codes
-- Константы клавиш можно посмотреть в Graphics/X11/ExtraTypes/XF86.hsc
-- Используемые клавиши модификаторы (Ctrl,Shift,Alt,Win и т.п.)
-- shiftMask
-- сontrolMask
-- mod1Mask
-- mod4Mask
-- Клавиши управления менеджером окон XMonad
-- Т.к. много мониторов, на каждом много столов, у которых много расположений
-- то предусмотрим клавиши для циклического переключения
 
  -- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    [ ("M-S-z", spawn "xscreensaver-command -lock"     )
    , ("M-S-=", unGrab *> spawn "scrot -s"             )
    , ("M-]"  , spawn "firefox"                        )
    , ("M-p"  , spawn  "rofi -modi drun,run,ssh,combi -show drun -theme solarized -icon-theme Papirus     -show-icons"                                      )
    , ("M-["  , spawn "$HOME/.joplin/Joplin.AppImage"  )
        -- KB_GROUP Grid Select (CTR-g followed by a key)
    , ("C-g g", spawnSelected' myAppGrid)                 -- grid select favorite apps
    , ("C-g t", goToSelected $ mygridConfig myColorizer)  -- goto selected window
    , ("C-g b", bringSelected $ mygridConfig myColorizer) -- bring selected window
    -- KB_GROUP Scratchpads
    -- Toggle show/hide these programs.  They run on a hidden workspace.
    -- When you toggle them to show, it brings them to your current workspace.
    -- Toggle them to hide and it sends them back to hidden workspace (NSP).
        , ("M-s t", namedScratchpadAction myScratchPads "terminal")
        , ("M-s m", namedScratchpadAction myScratchPads "mocp")
        , ("M-s c", namedScratchpadAction myScratchPads "calculator")
    -- KB_GROUP Multimedia Keys
        --, ("<XF86AudioPlay>", spawn "mocp --play")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 3")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 3")
  
 
 

    ]


 -- Экспериментальная конфигурация, для проверки разных возможностей

 ----------------------------------------------------------------------------------------
 --    X. Секция главной функции main - точки входа в программу
 ----------------------------------------------------------------------------------------
main :: IO ()
main = xmonad
      . ewmhFullscreen
      . ewmh
      . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig 
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)
----------------------------------------------------------------------------------------
-- Дополнительная информация
----------------------------------------------------------------------------------------
-- Если при запуске xmonad не работает переключение клавиатуры
-- то временно исправить можно выполнив:
-- setxkbmap -layout "us,ru" -option grp:ctrl_shift_toggle -option grp_led:scroll


-- Ресурсы
-- http://www.haskell.org/haskellwiki/Xmonad/General_xmonad.hs_config_tips
--р
