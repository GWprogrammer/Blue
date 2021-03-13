REM Start of BASIC! Program
REM----------------------------------------

FN.DEF MENU_TREE_BTN$(ctl_id$, btn$[])
 ! sub is the number of sub menus
 b=1 % btn counter
 sbm=0 % sub-menu flag , 1=submenu 0= no submenu  

 ARRAY.LENGTH l, btn$[]
 BUNDLE.GET 1, "sub", sub % maybe an error, if the menu is used on more than 1 page the next page inherit the counting order? 

 FOR i=1 TO l
  IF IS_IN(">", btn$[i])=1 THEN sbm =1 % chk if sub menu
  k=IS_IN(">", btn$[i], -1) % find the Callback
  IF !k THEN k=LEN(btn$[i])+1 % no callback, use txt
  txt$=WEB$(LEFT$(btn$[i], k-1)) % text plus menu key still there
  ax$=MID$(btn$[i], k+1) % Callback setup
  btn$=GW_FORMAT_LINK$(ax$)

  IF txt$="" % empty string is a line
   e$+="<hr style='margin:0; padding:0;'>"
  ELSEIF sbm=1 % if this is a sub menu 
   t=VAL(REPLACE$(LEFT$(txt$, 2), ">", "")) % t is the number of items in the sub menu, NOT including the sub menu btn 

   txt$=MID$(txt$, 3) % remove >x sub key
   REM btn for sub menu
   REM about CTL_IDs, the ctl_id is the control ctl_id + btn TEXT 
   REM example: menu1-Home
   REM there was an issue if the text had a space, the replace adding a - in place of the space.
   REM example: button text of, main menu 1, will have a ctl_id of
   REM menu1-main-menu-1, this will be the id to add css, disable etc.

   e$+="<a id='"+ctl_id$+"-"+ REPLACE$(txt$, " ", "-") +"' class='ui-btn sub-a' href='#' onclick='"+btn$+"'>"+txt$
   e$+="<span> > </span></a>" % sub menu arrow indicator
   i++ % this will change count on the for/next i loop
   h=i % to keep numbering correct
   REM put sub menu is a div, display none will be charged later when that menu item is tapped
   e$+= "<div id='"+"SUB"+INT$(sub)+"' style='display:none;'>
   REM this loop will process the sub menu items
   FOR j = 1 TO t
    k=IS_IN(">", btn$[h], -1)
    txt$=WEB$(LEFT$(btn$[h], k-1))
    ax$=MID$(btn$[h], k+1)
    btn$=GW_FORMAT_LINK$(ax$)
    REM class sub-z is in blue.css
    e$+="<a id='"+ctl_id$+"-"+ REPLACE$(txt$, " ", "-") +"' class='ui-btn sub-z' href='#' data-rel='back' onclick='"+btn$+"'>"+txt$+"</a>" 
    h++
   NEXT j
   i+=t-1
   sub++
   e$+="</div>" % sub contain
  ELSE % regular menu item
   e$+="<a id='"+ctl_id$+"-"+ REPLACE$(txt$, " ", "-") +"' class='ui-btn menu-btn' href='#' data-rel='back' onclick='"+btn$+"'>"+txt$+"</a>" 
  ENDIF
  b++
  sbm=0 % clear flag
 NEXT i
 REM number of sub menus
 sub--
 BUNDLE.PUT 1, "sub", sub
 FN.RTN e$
FN.END



FN.DEF MENU_TREE$(title$, btn$[])
 u$=GW_NEWID$("menu")
 REM BUNDLE.GET 1, "themes_path", themes_path$
 BUNDLE.GET 1, "gw-last-edited-page", page
 REM setup popup, dismissible, slidedown, data-arrow, data-tolerance
 e$="<div data-role='popup' data-transition='slidedown' data-arrow='t,t' data-tolerance='40px,0,0,10px' id='"+u$+"' data-dismissible='true' class='menu-tree'>"
 e$+="<div role='main' class='mini-menu' style='z-index:9990;'>
 e$+="<div data-role='header' id='menu-title' style='padding:4px; text-align: center; '><h7>"+title$+"</h7></div>" % header
 e$+="<div class='mini-menub' id='"+u$+"-buttons' >"
 e$+= MENU_TREE_BTN$ (u$, btn$[])
 e$+="</div>" % btns
 e$+="</div></div>" % main  popup
 GW_ADD_SKEY("control", u$)
 FN.RTN e$
FN.END


FN.DEF MENU_TREE(page, title$, btn$[])
 GW_REGISTER("MENU_TREE")
 ctl$ = MENU_TREE$(title$, btn$[])
 GW_INSERT_BEFORE(page, "<div data-role='content'", ctl$)
 ls = GW_KEY_IDX("control")
 FN.RTN ls
FN.END


REM----------------------------------------
