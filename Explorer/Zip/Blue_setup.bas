REM Blue_setup.bas does not use the gw lib
REM It only uses Olibasic
REM Blue_setup.bas will unzip Blue.zip and put all files in the correct folder



IF VERSION$()<>"03.00" THEN END " Wrong Version of Basic, Blue can only run on Olibasic III (3)"
PERMISSION.AUTOMATIC 2

source$="Error can't find Blue.zip, files should be in\n source/ or \n downloads/"
destination$="Error Blue folder Exists, Process Aborted."

ARRAY.LOAD path_list$[], "Blue/", "Blue/Explorer/", "Blue/Explorer/Icons/", "Blue/Explorer/Jquery/", "Blue/Explorer/Themes/", "Blue/Explorer/Data/"

ARRAY.LOAD source$[], "Blue.bas", "Blue_FN.bas", "GW_BLUE.bas"

ARRAY.LOAD storage$[], "_External", "_SdRemovable", "_Dcim", "_Documents", "_Downloads", "_Movies", "_Music", "_Notifications", "_Pictures", "_Podcasts"

blue_zip$="Blue_3.1.zip"
blue_setup$="Blue_setup.bas"
html$="Run_me_first.html"

REM--------------------------- look for html file
REM
REM--------------------------- Download/
FILE.ROOT p$, "_download"
ddownload_path$=ext$+p$+"/"
FILE.EXISTS html3, ddownload_path$ +html$
IF html3
 path$=ddownload_path$
 GOTO html_done
ENDIF

REM--------------------------------- Main storage
ext$="file://"
FILE.ROOT p$, "_External"
main_path$=ext$+p$+"/"
FILE.EXISTS html1, main_path$+html$
IF html1
 path$=main_path$
 GOTO html_done
ENDIF

REM--------------------------------- source/
FILE.ROOT p$, "_source"
source_path$=ext$+p$+"/"
FILE.EXISTS html2, source_path$+html$
IF html2
 path$=source_path$
 GOTO html_done
ENDIF

END "Error, Can't file Run_me_first.html \n must be in Download/, Source/, or emulated/0/."

html_done:

GRABFILE var$, path$+html$
HTML.OPEN 0
HTML.LOAD.STRING var$
PAUSE 500

HTML.LOAD.URL "javascript:Status('Working');"

PAUSE 100

FN.DEF DumpToFile$(buf$, out$, file$)
 IF !LEN(buf$)
  ? "Zip ERROR - Empty Buffer "
 ENDIF
 FILE.EXISTS fi, out$
 IF !fi
  MKDIR out$
 ENDIF
 BYTE.OPEN w, b, out$+file$
 BYTE.WRITE.BUFFER b, buf$
 BYTE.CLOSE b
FN.END


FN.DEF Unzip( source$, destination$, file$)
 FILE.EXISTS fi, source$
 IF !fi THEN END " bad file name "
 ZIP.OPEN r, in, source$
 ZIP.READ in, buf$, file$
 ZIP.CLOSE in
 x$=DumpToFile$(buf$, destination$, file$)
FN.END



FN.DEF COPY(in$, out$)
 FILE.EXISTS out, OUT$
 IF out
  REM add error
  BUNDLE.PUT 1, "error", "Destination File Exists"
  FN.RTN -1
 ENDIF
 FILE.EXISTS in, in$
 IF !in
  REM add error
  BUNDLE.PUT 1, "error", "Source File Exists"
  FN.RTN -1
 ENDIF
 BYTE.OPEN r, in, in$
 BYTE.COPY in, out$
 BYTE.CLOSE in
 FILE.EXISTS in, OUT$
 FN.RTN in
FN.END



HTML.LOAD.URL "javascript:Status('Searching for Blue.zip');"
PAUSE 100

REM--------------------------------- Main storage
ext$="file://"
FILE.ROOT p$, "_External"
main_path$=ext$+p$+"/"
FILE.EXISTS path, path$


REM--------------------------------- source/
FILE.ROOT p$, "_source"
source_path$=ext$+p$+"/"
FILE.EXISTS source, source_path$


REM--------------------------- Download path Blue.zip should be there
FILE.ROOT p$, "_download"
ddownload_path$=ext$+p$+"/"
FILE.EXISTS ddownload, ddownload_path$


!!
PAUSE 200
REM--------------------------- Blue final path out_path$
blue_path$=main_path$+"Blue/"
FILE.EXISTS blue, blue_path$
IF blue
 HTML.LOAD.URL "javascript:Status('"+destination$+"');"
 DO
 UNTIL 0
 END "bye"
ENDIF
!!
destination$=main_path$


REM--------------------------- find location of blue.zip source$

FILE.EXISTS dd, ddownload_path$+ blue_zip$
FILE.EXISTS source, source_path$+blue_zip$
FILE.EXISTS path, main_path$+blue_zip$
rem FILE.EXISTS internal, internal_path$+blue_zip$


end internal_path$

IF dd
 source$=ddownload_path$
ELSEIF source
 source$=source_path$
ELSEIF path
 source$= main_path$
 
rem ELSEIF internal
rem source$=internal_path$
 
ELSE
 END source$
ENDIF

REM--------------------------- creating paths


HTML.LOAD.URL "javascript:Status('Creating Paths');"
!!
ARRAY.LENGTH l, path_list$[]
FOR i =1 TO l
 MKDIR destination$+path_list$[i]
NEXT
!!
PAUSE 500


ZIP.DIR source$+blue_zip$, filelist$[]
ARRAY.LENGTH l, filelist$[]
FOR i =1 TO l
 HTML.LOAD.URL "javascript:Status('"+filelist$[i]+"');"
 REM a=Unzip( source$+blue_zip$, destination$, filelist$[i]) 
 PAUSE 50
NEXT i
PAUSE 200


IF !a
 HTML.LOAD.URL "javascript:var d = document.getElementById('error');d.classList.add('noerror');"
 HTML.LOAD.URL "javascript:error('Done, Run Blue.bas to see Blue Explorer in action. Press BACK key to exit.');"
ELSE
 HTML.LOAD.URL "javascript:var d = document.getElementById('error');d.classList.add('error');"
 HTML.LOAD.URL "javascript:error('Done With Errors');"
ENDIF





DO
UNTIL 0
END "DONE"




DELETE BELOW



!!
REM--------------------- move source file to RFO-BASIC/source/

FILE.EXISTS fi, blue_path$+"source/"
? "Copying to "+blue_path$+"source/"
IF !fi
 END " Error Something went wrong "
ENDIF

FILE.DIR blue_path$+"source/", files$[]
ARRAY.LENGTH len, files$[]



FOR i = 1 TO len

 a=COPY(blue_path$+"source/"+files$[i], main_path$+"source/"+files$[i])

if a=-1
BUNDLE.GET 1, "error", error$
 ? error$
ENDIF

NEXT i


BUNDLE.GET 1, "error", error$
if error$<>"none"
? "There were errors"
ENDIF
!!

? " Done, Run Blue.bas to see Blue Explorer in action.

END "Bye"
