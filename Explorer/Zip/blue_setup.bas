

IF VERSION$()<>"03.00" THEN END " Wrong Version of Basic, Blue can only run on Olibasic III (3)"
PERMISSION.AUTOMATIC 2


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




CLS

? " Setting up Paths"
? "Searching for Blue.zip"




source$="Error can't find Blue.zip, files should be in\n source/ or \n downloads/"
destination$="Error Blue folder Exists, Overwrite Existing files?"


ARRAY.LOAD path_list$[], "Blue/", "Blue/Explorer/", "Blue/Explorer/Icons/", "Blue/Explorer/Jquery/", "Blue/Explorer/Themes/", "Blue/Explorer/Data/"


ARRAY.LOAD source$[], "Blue.bas", "Blue_FN.bas", "GW_BLUE.bas"

ARRAY.LOAD storage$[], "_External", "_SdRemovable", "_Dcim", "_Documents", "_Downloads", "_Movies", "_Music", "_Notifications", "_Pictures", "_Podcasts"

blue_zip$="Blue.zip"
blue_setup$="Blue_setup.bas"


REM--------------------------------- Main storage
ext$="file://"
FILE.ROOT p$, "_External"
main_path$=ext$+p$+"/"
FILE.EXISTS path, path$


REM--------------------------------- .bas files end up here
FILE.ROOT p$, "_source"
source_path$=ext$+p$+"/"
FILE.EXISTS source, source_path$


REM--------------------------- Download path Blue.zip should be there
FILE.ROOT p$, "_download"
ddownload_path$=ext$+p$+"/"
FILE.EXISTS ddownload, ddownload_path$


REM--------------------------- Blue final path out_path$
blue_path$=main_path$+"Blue/"
FILE.EXISTS blue, blue_path$
IF blue
 END destination$
ENDIF
destination$=main_path$


REM--------------------------- find location of blue.zip source$

FILE.EXISTS dd, ddownload_path$+ blue_zip$
FILE.EXISTS source, source_path$+blue_zip$
IF dd
 source$=ddownload_path$
ELSEIF source
 source$=source_path$
ENDIF


CLS
REM--------------------------- creating paths
? "Creating Paths"
ARRAY.LENGTH l, path_list$[]
FOR i =1 TO l
 MKDIR destination$+path_list$[i]
NEXT



? "Unzipping "
ZIP.DIR source$+blue_zip$, filelist$[]
ARRAY.LENGTH l, filelist$[]
FOR i =1 TO l
 ? filelist$[i]
 a=Unzip( source$+blue_zip$, destination$, filelist$[i]) 
 PAUSE 50
NEXT i




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

? " Done, Run Blue.bas to see Blue Explorer in action."

END "Bye"
