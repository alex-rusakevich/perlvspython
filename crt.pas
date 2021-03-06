{ CRT (Crt Replacement Tool)
       Portable BP compatible CRT unit for GPC with many extensions
     
       This unit is aware of terminal types. This means programs using
       this unit will work whether run locally or while being logged in
       remotely from a system with a completely different terminal type
       (as long as the appropriate terminfo entry is present on the
       system where the program is run).
     
       NOTES:
     
       - The CRT unit needs the ncurses and panel libraries which should
         be available for almost any system. For Dos systems, where
         ncurses is not available, it is configured to use the PDCurses
         and its panel library instead. On Unix systems with X11, it can
         also use PDCurses (xcurses) and xpanel to produce X11 programs.
         The advantage is that the program won't need an xterm with a
         valid terminfo entry, the output may look a little nicer and
         function keys work better than in an xterm, but the disadvantage
         is that it will only run under X. The ncurses and PDCurses
         libraries (including panel and xpanel, resp.) can be found in
         http://www.gnu-pascal.de/libs/
         (Note that ncurses is already installed on many Unix systems.)
         For ncurses, version 5.0 or newer is required.
     
         When an X11 version under Unix is wanted, give -DX11 when
         compiling crt.pas and crtc.c (or when compiling crt.pas or a
         program that uses CRT with --automake). On pre-X11R6 systems,
         give -DNOX11R6 additionally. You might also have to give the
         path to the X11 libraries with -L, e.g. -L /usr/X11/lib.
     
       - A few features cannot be implemented in a portable way and are
         only available on some systems:
     
           Sound, NoSound 1)                  -----------------------.
           GetShiftState                      ------------------.    |
           TextMode etc. 2)                   -------------.    |    |
           CRTSavePreviousScreen              --------.    |    |    |
           Interrupt signal (Ctrl-C) handling ---.    |    |    |    |
                                                 |    |    |    |    |
         Linux/IA32 3) (terminal)                X    X 4) X 5) X 6) X 6)
         Other Unix (terminal)                   X    X 7) X 5) -    -
         Unix (X11 version)                      X    X    -    X    -
         Dos (DJGPP)                             X    X    X    X    X
         MS-Windows (Cygwin, mingw, MSYS)        X    -    X 8) X    -
     
         Notes:
     
         1) If you define NO_CRT_DUMMY_SOUND while compiling CRT, you
            will get linking errors when your program tries to use
            Sound/NoSound on a platform where it's not supported (which
            is useful to detect at compile time if playing sound is a
            major task of your program). Otherwise, Sound/NoSound will
            simply do nothing (which is usually acceptable if the program
            uses these routines just for an occasional beep).
     
         2) Changing to monochrome modes works on all platforms. Changing
            the screen size only works on those indicated. However, even
            on the platforms not supported, the program will react to
            screen size changes by external means (e.g. changing the
            window size with the mouse if running in a GUI window or
            resizing a console or virtual terminal).
     
         3) Probably also on other processors, but I've had no chance to
            test this yet.
     
         4) Only on a local console with access permissions to the
            corresponding virtual console memory device or using the
            crtscreen utility (see crtscreen.c in the demos directory).
     
         5) Only if supported by an external command (e.g., in xterms and
            on local Linux consoles). The command to be called can be
            defined in the environment variable RESIZETERM (where the
            variables columns and lines in the command are set to the
            size wanted). If not set, the code will try resize -s in an
            xterm and otherwise SVGATextMode and setfont. For this to
            work, these utilities need to be present in the PATH or
            /usr/sbin or /usr/local/sbin. Furthermore, SVGATextMode
            and setfont require root permissions, either to the
            executable of the program compiled with CRT or to resizecons
            (called by setfont) or SVGATextMode. To allow the latter, do
            "chmod u+s `which resizecons`" and/or
            "chmod u+s `which SVGATextMode`", as root once, but only if
            you really want each user to be allowed to change the text
            mode.
     
         6) Only on local consoles.
     
         7) Some terminals only. Most xterms etc. support it as well as
            other terminals that support an "alternate screen" in the
            smcup/rmcup terminal capabilities.
     
         8) Only with PDCurses, not with ncurses. Changing the number of
            screen *columns* doesn't work in a full-screen session.
     
       - When CRT is initialized (automatically or explicitly; see the
         comments for CRTInit), the screen is cleared, and at the end of
         the program, the cursor is placed at the bottom of the screen
         (curses behaviour).
     
       - All the other things (including most details like color and
         function key constants) are compatible with BP's CRT unit, and
         there are many extensions that BP's unit does not have.
     
       - When the screen size is changed by an external event (e.g.,
         resizing an xterm or changing the screen size from another VC
         under Linux), the virtual "function key" kbScreenSizeChanged is
         returned. Applications can use the virtual key to resize their
         windows. kbScreenSizeChanged will not be returned if the screen
         size change was initiated by the program itself (by using
         TextMode or SetScreenSize). Note that TextMode sets the current
         panel to the full screen size, sets the text attribute to the
         default and clears the window (BP compatibility), while
         SetScreenSize does not.
     
       - After the screen size has been changed, whether by using
         TextMode, SetScreenSize or by an external event, ScreenSize will
         return the new screen size. The current window and all panels
         will have been adjusted to the new screen size. This means, if
         their right or lower ends are outside the new screen size, the
         windows are moved to the left and/or top as far as necessary. If
         this is not enough, i.e., if they are wider/higher than the new
         screen size, they are shrinked to the total screen width/height.
         When the screen size is enlarged, window sizes are not changed,
         with one exception: Windows that extend through the whole screen
         width/height are enlarged to the whole new screen width/height
         (in particular, full-screen windows remain full-screen). This
         behaviour might not be optimal for all purposes, but you can
         always resize your windows in your application after the screen
         size change.
     
       - (ncurses only) The environment variable ESCDELAY specifies the
         number of milliseconds allowed between an Esc character and
         the rest of an escape sequence (default 1000). Setting it to a
         value too small can cause problems with programs not recognizing
         escape sequences such as function keys, especially over slow
         network connections. Setting it to a value too large can delay
         the recognition of an ESC key press notably. On local Linux
         consoles, e.g., 10 seems to be a good value.
     
       - When trying to write portable programs, don't rely on exactly
         the same look of your output and the availability of all the key
         combinations. Some kinds of terminals support only some of the
         display attributes and special characters, and usually not all
         of the keys declared are really available. Therefore, it's safer
         to provide the same function on different key combinations and
         to not use the more exotic ones.
     
       - CRT supports an additional modifier key (if present), called
         Extra. On DJGPP, it's the <Scroll Lock> key, under X11 it's
         the modifier #4, and on a local Linux console, it's the CtrlL
         modifier (value 64) which is unused on many keytabs and can be
         mapped to any key(s), e.g. to those keys on new keyboards with
         these ugly symbols waiting to be replaced by penguins (keycodes
         125 and 127) by inserting the following two lines into your
         /etc/default.keytab and reloading the keytab with loadkeys
         (you usually have to do this as root):
     
         keycode 125 = CtrlL
         keycode 127 = CtrlL
     
       Copyright (C) 1998-2005 Free Software Foundation, Inc.
     
       Author: Frank Heckenbach <frank@pascal.gnu.de>
     
       This file is part of GNU Pascal.
     
       GNU Pascal is free software; you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published
       by the Free Software Foundation; either version 2, or (at your
       option) any later version.
     
       GNU Pascal is distributed in the hope that it will be useful, but
       WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
       General Public License for more details.
     
       You should have received a copy of the GNU General Public License
       along with GNU Pascal; see the file COPYING. If not, write to the
       Free Software Foundation, 59 Temple Place - Suite 330, Boston, MA
       02111-1307, USA.
     
       As a special exception, if you link this file with files compiled
       with a GNU compiler to produce an executable, this does not cause
       the resulting executable to be covered by the GNU General Public
       License. This exception does not however invalidate any other
       reasons why the executable file might be covered by the GNU
       General Public License.
     
       Please also note the license of the curses library used. }
     
     {$gnu-pascal,I-}
     {$if __GPC_RELEASE__ < 20030722}
     {$error This unit requires GPC release 20030722 or newer.}
     {$endif}
     
     unit {$ifdef THIS_IS_WINCRT} WinCRT {$else} CRT {$endif};
     
     interface
     
     uses GPC;
     
     const
       { CRT modes }
       BW40          = 0;            { 40x25 Black/White }
       CO40          = 1;            { 40x25 Color }
       BW80          = 2;            { 80x25 Black/White }
       CO80          = 3;            { 80x25 Color }
       Mono          = 7;            { 80x25 Black/White }
       Font8x8       = 256;          { Add-in for 80x43 or 80x50 mode }
     
       { Mode constants for Turbo Pascal 3.0 compatibility }
       C40           = CO40;
       C80           = CO80;
     
       { Foreground and background color constants }
       Black         = 0;
       Blue          = 1;
       Green         = 2;
       Cyan          = 3;
       Red           = 4;
       Magenta       = 5;
       Brown         = 6;
       LightGray     = 7;
     
       { Foreground color constants }
       DarkGray      = 8;
       LightBlue     = 9;
       LightGreen    = 10;
       LightCyan     = 11;
       LightRed      = 12;
       LightMagenta  = 13;
       Yellow        = 14;
       White         = 15;
     
       { Add-in for blinking }
       Blink         = 128;
     
     type
       TTextAttr = Byte;
     
     var
       { If False (default: True), catch interrupt signals (SIGINT;
         Ctrl-C), and other flow control characters as well as SIGTERM,
         SIGHUP and perhaps other signals }
       CheckBreak: Boolean = True; attribute (name = 'crt_CheckBreak');
     
       { If True (default : False), replace Ctrl-Z by #0 in input }
       CheckEOF: Boolean = False; attribute (name = 'crt_CheckEOF');
     
       { Ignored -- meaningless here }
       DirectVideo: Boolean = True;
     
       { Ignored -- curses or the terminal driver will take care of that
         when necessary }
       CheckSnow: Boolean = False;
     
       { Current (sic!) text mode }
       LastMode: CCardinal = 3; attribute (name = 'crt_LastMode');
     
       { Current text attribute }
       TextAttr: TTextAttr = 7; attribute (name = 'crt_TextAttr');
     
       { Window upper left coordinates. *Obsolete*! Please see WindowMin
         below. }
       WindMin: CCardinal = High (CCardinal); attribute (name
       = 'crt_WindMin');
     
       { Window lower right coordinates. *Obsolete*! Please see WindowMax
         below. }
       WindMax: CCardinal = High (CCardinal); attribute (name
       = 'crt_WindMax');
     
     procedure AssignCRT (var f: Text);
     function  KeyPressed: Boolean; external name 'crt_KeyPressed';
     function  ReadKey: Char; external name 'crt_ReadKey';
     
     { Not effective on all platforms, see above. See also SetScreenSize
       and SetMonochrome. }
     procedure TextMode (Mode: Integer);
     
     procedure Window (x1, y1, x2, y2: CInteger); external
       name 'crt_Window';
     procedure GotoXY (x, y: CInteger); external name 'crt_GotoXY';
     function  WhereX: CInteger; external name 'crt_WhereX';
     function  WhereY: CInteger; external name 'crt_WhereY';
     procedure ClrScr; external name 'crt_ClrScr';
     procedure ClrEOL; external name 'crt_ClrEOL';
     procedure InsLine; external name 'crt_InsLine';
     procedure DelLine; external name 'crt_DelLine';
     procedure TextColor (Color: TTextAttr);
     procedure TextBackground (Color: TTextAttr);
     procedure LowVideo;
     procedure HighVideo;
     procedure NormVideo;
     procedure Delay (MS: CCardinal); external name 'crt_Delay';
     
     { Not available on all platforms, see above }
     procedure Sound (Hz: CCardinal); external name 'crt_Sound';
     procedure NoSound; external name 'crt_NoSound';
     
     { =================== Extensions over BP's CRT =================== }
     
     { Initializes the CRT unit. Should be called before using any of
       CRT's routines.
     
       Note: For BP compatibility, CRT is initizalized automatically when
       (almost) any of its routines are used for the first time. In this
       case, some defaults are set to match BP more closely. In
       particular, the PC charset (see SetPCCharSet) is enabled then
       (disabled otherwise), and the update level (see SetCRTUpdate) is
       set to UpdateRegularly (UpdateWaitInput otherwise). This feature
       is meant for BP compatibility *only*. Don't rely on it when
       writing a new program. Use CRTInit then, and set the defaults to
       the values you want explicitly.
     
       SetCRTUpdate is one of those few routines which will not cause CRT
       to be initialized immediately, and a value set with it will
       survive both automatic and explicit initialization, so you can use
       it to set the update level without caring which way CRT will be
       initialized. (This does not apply to SetPCCharSet. Since it works
       on a per-panel basis, it has to initialize CRT first, so there is
       a panel to start with.)
     
       If you terminate the program before calling CRTInit or any routine
       that causes automatic initialization, curses will never be
       initialized, so e.g., the screen won't be cleared. This can be
       useful, e.g., to check the command line arguments (or anything
       else) and if there's a problem, write an error and abort. Just be
       sure to write the error to StdErr, not Output (because Output will
       be assigned to CRT, and therefore writing to Output will cause CRT
       to be initialized, and because errors belong to StdErr, anyway),
       and to call RestoreTerminal (True) before (just to be sure, in
       case some code -- perhaps added later, or hidden in the
       initialization of some unit -- does initialize CRT). }
     procedure CRTInit; external name 'crt_Init';
     
     { Changes the input and output file and the terminal description CRT
       uses. Only effective with ncurses, and only if called before CRT
       is initialized (automatically or explicitly; see the comments for
       CRTInit). If TerminalType is nil, the default will be used. If
       InputFile and/or OutputFile are Null, they remain unchanged. }
     procedure CRTSetTerminal (TerminalType: CString; var InputFile,
       OutputFile: AnyFile); attribute (name = 'crt_SetTerminal');
     
     { If called with an argument True, it causes CRT to save the
       previous screen contents if possible (see the comments at the
       beginning of the unit), and restore them when calling
       RestoreTerminal (True). After RestoreTerminal (False), they're
       saved again, and at the end of the program, they're restored. If
       called with an argument False, it will prohibit this behaviour.
       The default, if this procedure is not called, depends on the
       terminal (generally it is active on most xterms and similar and
       not active on most other terminals).
     
       This procedure should be called before initializing CRT (using
       CRTInit or automatically), otherwise the previous screen contents
       may already have been overwritten. It has no effect under XCurses,
       because the program uses its own window, anyway. }
     procedure CRTSavePreviousScreen (On: Boolean); external
       name 'crt_SavePreviousScreen';
     
     { Returns True if CRTSavePreviousScreen was called with argument
       True and the functionality is really available. Note that the
       result is not reliable until CRT is initialized, while
       CRTSavePreviousScreen should be called before CRT is initialized.
       That's why they are two separate routines. }
     function  CRTSavePreviousScreenWorks: Boolean; external
       name 'crt_SavePreviousScreenWorks';
     
     { If CRT is initialized automatically, not via CRTInit, and
       CRTAutoInitProc is not nil, it will be called before actually
       initializing CRT. }
     var
       CRTAutoInitProc: procedure = nil; attribute (name
       = 'crt_AutoInitProc');
     
     { Aborts with a runtime error saying that CRT was not initialized.
       If you set CRTAutoInitProc to this procedure, you can effectively
       disable CRT's automatic initialization. }
     procedure CRTNotInitialized; attribute (name
       = 'crt_NotInitialized');
     
     { Set terminal to shell or curses mode. An internal procedure
       registered by CRT via RegisterRestoreTerminal does this as well,
       so CRTSetCursesMode has to be called only in unusual situations,
       e.g. after executing a process that changes terminal modes, but
       does not restore them (e.g. because it crashed or was killed), and
       the process was not executed with the Execute routine, and
       RestoreTerminal was not called otherwise. If you set it to False
       temporarily, be sure to set it back to True before doing any
       further CRT operations, otherwise the result may be strange. }
     procedure CRTSetCursesMode (On: Boolean); external
       name 'crt_SetCursesMode';
     
     { Do the same as RestoreTerminal (True), but also clear the screen
       after restoring the terminal (except for XCurses, because the
       program uses its own window, anyway). Does not restore and save
       again the previous screen contents if CRTSavePreviousScreen was
       called. }
     procedure RestoreTerminalClearCRT; attribute (name
       = 'crt_RestoreTerminalClearCRT');
     
     { Keyboard and character graphics constants -- BP compatible! =:-}
     {$i crt.inc}
     
     var
       { Tells whether the XCurses version of CRT is used }
       XCRT: Boolean = {$ifdef XCURSES} True {$else} False {$endif};
       attribute (name = 'crt_XCRT');
     
       { If True (default: False), the Beep procedure and writing #7 do a
         Flash instead }
       VisualBell: Boolean = False; attribute (name = 'crt_VisualBell');
     
       { Cursor shape codes. Only to be used in very special cases. }
       CursorShapeHidden: CInteger = 0; attribute (name
       = 'crt_CursorShapeHidden');
       CursorShapeNormal: CInteger = 1; attribute (name
       = 'crt_CursorShapeNormal');
       CursorShapeFull:   CInteger = 2; attribute (name
       = 'crt_CursorShapeFull');
     
     type
       TKey = CCardinal;
     
       TCursorShape = (CursorIgnored, CursorHidden, CursorNormal,
       CursorFat, CursorBlock);
     
       TCRTUpdate = (UpdateNever, UpdateWaitInput, UpdateInput,
                     UpdateRegularly, UpdateAlways);
     
       TPoint = record
         x, y: CInteger
       end;
     
       PCharAttr = ^TCharAttr;
       TCharAttr = record
         ch       : Char;
         Attr     : TTextAttr;
         PCCharSet: Boolean
       end;
     
       PCharAttrs = ^TCharAttrs;
       TCharAttrs = array [1 .. MaxVarSize div SizeOf (TCharAttr)] of
       TCharAttr;
     
       TWindowXYInternalCard8 = Cardinal attribute (Size = 8);
       TWindowXYInternalFill = Integer attribute (Size = BitSizeOf
       (CCardinal) - 16);
       TWindowXY = packed record
         {$ifdef __BYTES_BIG_ENDIAN__}
         Fill: TWindowXYInternalFill;
         y, x: TWindowXYInternalCard8
         {$elif defined (__BYTES_LITTLE_ENDIAN__)}
         x, y: TWindowXYInternalCard8;
         Fill: TWindowXYInternalFill
         {$else}
         {$error Endianness is not defined!}
         {$endif}
       end;
     
     { Make sure TWindowXY really has the same size as WindMin and
       WindMax. The value of the constant will always be True, and is of
       no further interest. }
     const
       AssertTWindowXYSize = CompilerAssert ((SizeOf (TWindowXY) = SizeOf
       (WindMin)) and
                                             (SizeOf (TWindowXY) = SizeOf
       (WindMax)));
     
     var
       { Window upper and left coordinates. More comfortable to access
         than WindMin, but also *obsolete*. WindMin and WindowMin still
         work, but have the problem that they implicitly limit the window
         size to 255x255 characters. Though that's not really small for a
         text window, it's easily possible to create bigger ones (e.g. in
         an xterm with a small font, on a high resolution screen and/or
         extending over several virutal desktops). When using coordinates
         greater than 254, the corresponding bytes in WindowMin/WindowMax
         will be set to 254, so, e.g., programs which do
         Inc (WindowMin.x) will not fail quite as badly (but probably
         still fail). The routines Window and GetWindow use Integer
         coordinates, and don't suffer from any of these problems, so
         they should be used instead. }
       WindowMin: TWindowXY absolute WindMin;
     
       { Window lower right coordinates. More comfortable to access than
         WindMax, but also *obsolete* (see the comments for WindowMin).
         Use Window and GetWindow instead. }
       WindowMax: TWindowXY absolute WindMax;
     
       { The attribute set by NormVideo }
       NormAttr: TTextAttr = 7; attribute (name = 'crt_NormAttr');
     
       { Tells whether the current mode is monochrome }
       IsMonochrome: Boolean = False; attribute (name
       = 'crt_IsMonochrome');
     
       { This value can be set to a combination of the shFoo constants
         and will be ORed to the actual shift state returned by
         GetShiftState. This can be used to easily simulate shift keys on
         systems where they can't be accessed. }
       VirtualShiftState: CInteger = 0; attribute (name
       = 'crt_VirtualShiftState');
     
     { Returns the size of the screen. Note: In BP's WinCRT unit,
       ScreenSize is a variable. But since writing to it from a program
       is pointless, anyway, providing a function here should not cause
       any incompatibility. }
     function  ScreenSize: TPoint; attribute (name
       = 'crt_GetScreenSize');
     
     { Change the screen size if possible. }
     procedure SetScreenSize (x, y: CInteger); external
       name 'crt_SetScreenSize';
     
     { Turns colors off or on. }
     procedure SetMonochrome (Monochrome: Boolean); external
       name 'crt_SetMonochrome';
     
     { Tell which modifier keys are currently pressed. The result is a
       combination of the shFoo constants defined in crt.inc, or 0 on
       systems where this function is not supported -- but note
       VirtualShiftState. If supported, ReadKey automatically converts
       kbIns and kbDel keys to kbShIns and kbShDel, resp., if shift is
       pressed. }
     function  GetShiftState: CInteger; external
       name 'crt_GetShiftState';
     
     { Get the extent of the current window. Use this procedure rather
       than reading WindMin and WindMax or WindowMin and WindowMax, since
       this routine allows for window sizes larger than 255. The
       resulting coordinates are 1-based (like in Window, unlike WindMin,
       WindMax, WindowMin and WindowMax). Any of the parameters may be
       Null in case you're interested in only some of the coordinates. }
     procedure GetWindow (var x1, y1, x2, y2: Integer); attribute (name
       = 'crt_GetWindow');
     
     { Determine when to update the screen. The possible values are the
       following. The given conditions *guarantee* updates. However,
       updates may occur more frequently (even if the update level is set
       to UpdateNever). About the default value, see the comments for
       CRTInit.
     
       UpdateNever    : never (unless explicitly requested with
                        CRTUpdate)
       UpdateWaitInput: before Delay and CRT input, unless typeahead is
                        detected
       UpdateInput    : before Delay and CRT input
       UpdateRegularly: before Delay and CRT input and otherwise in
                        regular intervals without causing too much
                        refresh. This uses a timer on some systems
                        (currently, Unix with ncurses). This was created
                        for BP compatibility, but for many applications,
                        a lower value causes less flickering in the
                        output, and additionally, timer signals won't
                        disturb other operations. Under DJGPP, this
                        always updates immediately, but this fact should
                        not mislead DJGPP users into thinking this is
                        always so.
       UpdateAlways   : after each output. This can be very slow. (Not so
                        under DJGPP, but this fact should not mislead
                        DJGPP users ...) }
     procedure SetCRTUpdate (UpdateLevel: TCRTUpdate); external
       name 'crt_SetUpdateLevel';
     
     { Do an update now, independently of the update level }
     procedure CRTUpdate; external name 'crt_Update';
     
     { Do an update now and completely redraw the screen }
     procedure CRTRedraw; external name 'crt_Redraw';
     
     { Return Ord (key) for normal keys and $100 * Ord (fkey) for
       function keys }
     function  ReadKeyWord: TKey; external name 'crt_ReadKeyWord';
     
     { Extract the character and scan code from a TKey value }
     function  Key2Char (k: TKey): Char;
     function  Key2Scan (k: TKey): Char;
     
     { Convert a key to upper/lower case if it is a letter, leave it
       unchanged otherwise }
     function  UpCaseKey (k: TKey): TKey;
     function  LoCaseKey (k: TKey): TKey;
     
     { Return key codes for the combination of the given key with Ctrl,
       Alt, AltGr or Extra, resp. Returns 0 if the combination is
       unknown. }
     function  CtrlKey  (ch: Char): TKey; attribute (name
       = 'crt_CtrlKey');
     function  AltKey   (ch: Char): TKey; external name 'crt_AltKey';
     function  AltGrKey (ch: Char): TKey; external name 'crt_AltGrKey';
     function  ExtraKey (ch: Char): TKey; external name 'crt_ExtraKey';
     
     { Check if k is a pseudo key generated by a deadly signal trapped }
     function  IsDeadlySignal (k: TKey): Boolean;
     
     { Produce a beep or a screen flash }
     procedure Beep; external name 'crt_Beep';
     procedure Flash; external name 'crt_Flash';
     
     { Get size of current window (calculated using GetWindow) }
     function  GetXMax: Integer;
     function  GetYMax: Integer;
     
     { Get/goto an absolute position }
     function  WhereXAbs: Integer;
     function  WhereYAbs: Integer;
     procedure GotoXYAbs (x, y: Integer);
     
     { Turn scrolling on or off }
     procedure SetScroll (State: Boolean); external name 'crt_SetScroll';
     
     { Read back whether scrolling is enabled }
     function  GetScroll: Boolean; external name 'crt_GetScroll';
     
     { Determine whether to interpret non-ASCII characters as PC ROM
       characters (True), or in a system dependent way (False). About the
       default, see the comments for CRTInit. }
     procedure SetPCCharSet (PCCharSet: Boolean); external
       name 'crt_SetPCCharSet';
     
     { Read back the value set by SetPCCharSet }
     function  GetPCCharSet: Boolean; external name 'crt_GetPCCharSet';
     
     { Determine whether to interpret #7, #8, #10, #13 as control
       characters (True, default), or as graphics characters (False) }
     procedure SetControlChars (UseControlChars: Boolean); external
       name 'crt_SetControlChars';
     
     { Read back the value set by SetControlChars }
     function  GetControlChars: Boolean; external
       name 'crt_GetControlChars';
     
     procedure SetCursorShape (Shape: TCursorShape); external
       name 'crt_SetCursorShape';
     function  GetCursorShape: TCursorShape; external
       name 'crt_GetCursorShape';
     
     procedure HideCursor;
     procedure HiddenCursor;
     procedure NormalCursor;
     procedure FatCursor;
     procedure BlockCursor;
     procedure IgnoreCursor;
     
     { Simulates a block cursor by writing a block character onto the
       cursor position. The procedure automatically finds the topmost
       visible panel whose shape is not CursorIgnored and places the
       simulated cursor there (just like the hardware cursor), with
       matching attributes, if the cursor shape is CursorFat or
       CursorBlock (otherwise, no simulated cursor is shown).
     
       Calling this procedure again makes the simulated cursor disappear.
       In particular, to get the effect of a blinking cursor, you have to
       call the procedure repeatedly (say, 8 times a second). CRT will
       not do this for you, since it does not intend to be your main
       event loop. }
     procedure SimulateBlockCursor; external
       name 'crt_SimulateBlockCursor';
     
     { Makes the cursor simulated by SimulateBlockCursor disappear if it
       is active. Does nothing otherwise. You should call this procedure
       after using SimulateBlockCursor before doing any further CRT
       output (though failing to do so should not hurt except for
       possibly leaving the simulated cursor in its old position longer
       than it should). }
     procedure SimulateBlockCursorOff; external
       name 'crt_SimulateBlockCursorOff';
     
     function  GetTextColor: Integer;
     function  GetTextBackground: Integer;
     
     { Write string at the given position without moving the cursor.
       Truncated at the right margin. }
     procedure WriteStrAt (x, y: Integer; const s: String; Attr:
       TTextAttr);
     
     { Write (several copies of) a char at then given position without
       moving the cursor. Truncated at the right margin. }
     procedure WriteCharAt (x, y, Count: Integer; ch: Char; Attr:
       TTextAttr);
     
     { Write characters with specified attributes at the given position
       without moving the cursor. Truncated at the right margin. }
     procedure WriteCharAttrAt (x, y, Count: CInteger; CharAttr:
       PCharAttrs); external name 'crt_WriteCharAttrAt';
     
     { Write a char while moving the cursor }
     procedure WriteChar (ch: Char);
     
     { Read a character from a screen position }
     procedure ReadChar (x, y: CInteger; var ch: Char; var Attr:
       TTextAttr); external name 'crt_ReadChar';
     
     { Change only text attributes, leave characters. Truncated at the
       right margin. }
     procedure ChangeTextAttr (x, y, Count: Integer; NewAttr: TTextAttr);
     
     { Fill current window }
     procedure FillWin (ch: Char; Attr: TTextAttr); external
       name 'crt_FillWin';
     
     { Calculate size of memory required for ReadWin in current window. }
     function  WinSize: SizeType; external name 'crt_WinSize';
     
     { Save window contents. Buf must be WinSize bytes large. }
     procedure ReadWin (var Buf); external name 'crt_ReadWin';
     
     { Restore window contents saved by ReadWin. The size of the current
       window must match the size of the window from which ReadWin was
       used, but the position may be different. }
     procedure WriteWin (const Buf); external name 'crt_WriteWin';
     
     type
       WinState = record
         x1, y1, x2, y2, WhereX, WhereY, NewX1, NewY1, NewX2, NewY2:
       Integer;
         TextAttr: TTextAttr;
         CursorShape: TCursorShape;
         ScreenSize: TPoint;
         Buffer: ^Byte
       end;
     
     { Save window position and size, cursor position, text attribute and
       cursor shape -- *not* the window contents. }
     procedure SaveWin (var State: WinState);
     
     { Make a new window (like Window), and save the contents of the
       screen below the window as well as the position and size, cursor
       position, text attribute and cursor shape of the old window. }
     procedure MakeWin (var State: WinState; x1, y1, x2, y2: Integer);
     
     { Create window in full size, save previous text mode and all values
       that MakeWin does. }
     procedure SaveScreen (var State: WinState);
     
     { Restore the data saved by SaveWin, MakeWin or SaveScreen. }
     procedure RestoreWin (var State: WinState);
     
     { Panels }
     
     type
       TPanel = Pointer;
     
     function  GetActivePanel: TPanel; external
       name 'crt_GetActivePanel';
     procedure PanelNew                 (x1, y1, x2, y2: CInteger;
       BindToBackground: Boolean); external name 'crt_PanelNew';
     procedure PanelDelete              (Panel: TPanel); external
       name 'crt_PanelDelete';
     procedure PanelBindToBackground    (Panel: TPanel; BindToBackground:
       Boolean); external name 'crt_PanelBindToBackground';
     function  PanelIsBoundToBackground (Panel: TPanel): Boolean;
       external name 'crt_PanelIsBoundToBackground';
     procedure PanelActivate            (Panel: TPanel); external
       name 'crt_PanelActivate';
     procedure PanelHide                (Panel: TPanel); external
       name 'crt_PanelHide';
     procedure PanelShow                (Panel: TPanel); external
       name 'crt_PanelShow';
     function  PanelHidden              (Panel: TPanel): Boolean;
       external name 'crt_PanelHidden';
     procedure PanelTop                 (Panel: TPanel); external
       name 'crt_PanelTop';
     procedure PanelBottom              (Panel: TPanel); external
       name 'crt_PanelBottom';
     procedure PanelMoveAbove           (Panel, Above: TPanel); external
       name 'crt_PanelMoveAbove';
     procedure PanelMoveBelow           (Panel, Below: TPanel); external
       name 'crt_PanelMoveBelow';
     function  PanelAbove               (Panel: TPanel): TPanel; external
       name 'crt_PanelAbove';
     function  PanelBelow               (Panel: TPanel): TPanel; external
       name 'crt_PanelBelow';
     
     { TPCRT compatibility }
     
     { Write a string at the given position without moving the cursor.
       Truncated at the right margin. }
     procedure WriteString (const s: String; y, x: Integer);
     
     { Write a string at the given position with the given attribute
       without moving the cursor. Truncated at the right margin. }
     procedure FastWriteWindow (const s: String; y, x: Integer; Attr:
       TTextAttr);
     
     { Write a string at the given absolute position with the given
      attribute without moving the cursor. Truncated at the right
       margin. }
     procedure FastWrite       (const s: String; y, x: Integer; Attr:
       TTextAttr);
     
     { WinCRT compatibility }
     
     const
       cw_UseDefault = Integer ($8000);
     
     var
       { Ignored }
       WindowOrg : TPoint = (cw_UseDefault, cw_UseDefault);
       WindowSize: TPoint = (cw_UseDefault, cw_UseDefault);
       Origin    : TPoint = (0, 0);
       InactiveTitle: PChar = '(Inactive %s)';
       AutoTracking: Boolean = True;
       WindowTitle: {$ifdef __BP_TYPE_SIZES__}
                    array [0 .. 79] of Char
                    {$else}
                    TStringBuf
                    {$endif};
     
       { Cursor location, 0-based }
       Cursor    : TPoint = (0, 0); attribute (name = 'crt_Cursor');
     
     procedure InitWinCRT; attribute (name = 'crt_InitWinCRT');
     
     { Halts the program }
     procedure DoneWinCRT; attribute (noreturn, name = 'crt_DoneWinCRT');
     
     procedure WriteBuf (Buffer: PChar; Count: SizeType); attribute (name
       = 'crt_WriteBuf');
     
     function  ReadBuf (Buffer: PChar; Count: SizeType): SizeType;
       attribute (name = 'crt_ReadBuf');
     
     { 0-based coordinates! }
     procedure CursorTo (x, y: Integer); attribute (name
       = 'crt_CursorTo');
     
     { Dummy }
     procedure ScrollTo (x, y: Integer); attribute (name
       = 'crt_ScrollTo');
     
     { Dummy }
     procedure TrackCursor; attribute (name = 'crt_TrackCursor');
     