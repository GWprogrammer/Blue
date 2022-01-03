

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


FN.DEF Unzip( inpath$, outpath$, file$)
 FILE.EXISTS fi, inpath$
 IF !fi THEN END " bad file name "
 ZIP.OPEN r, in, inpath$
 ZIP.READ in, buf$, file$
 ZIP.CLOSE in
 x$=DumpToFile$(buf$, outpath$, file$)
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
? " 
inpath$="Error can't find Blue.zip, files should be in\n source/ or \n downloads/"
outpath$="Error Blue folder Exists, Overwrite Existing files?"




ARRAY.LOAD source$[], "Blue.bas", "Blue_FN.bas", "GW_BLUE.bas", ""


ARRAY.LOAD storage$[], "_External", "_SdRemovable", "_Dcim", "_Documents", "_Downloads", "_Movies", "_Music", "_Notifications", "_Pictures", "_Podcasts"

blue_zip$="Blue - copy.zip"
blue_setup$="Blue_setup.bas"

blue_fn$="1aBlue_fn.bas"
blue_lib$="gw_Blue.bas"


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
blue_path$=main_path$+"Blue2/"
FILE.EXISTS blue, blue_path$
IF blue
 FILE.EXISTS blue2, blue_path$+"blue.css"
 IF blue2

  REM ? outpath$

  ! end
 ENDIF
 outpath$=blue_path$
ENDIF


REM--------------------------- find location of blue.zip inpath$

FILE.EXISTS dd, ddownload_path$+ blue_zip$
FILE.EXISTS source, source_path$+blue_zip$
IF dd
 inpath$=ddownload_path$
ELSEIF source
 inpath$=source_path$
ENDIF



outpath$=main_path$



? "Unzipping "
ZIP.DIR inpath$+blue_zip$, filelist$[]

ARRAY.LENGTH l, filelist$[]
FOR i =1 TO l
 file$= filelist$[i]
 IF RIGHT$(file$, 1)="/"
  MKDIR outpath$+file$
 ELSE  
  a=Unzip( inpath$+blue_zip$, outpath$, file$) 
 ENDIF
NEXT


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
? " Done, Run Blue.bas to see Blue Explorer in action."



END


