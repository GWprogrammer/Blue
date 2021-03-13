
REM INCLUDE "GW.bas"

INCLUDE "gw_blue.bas"






FN.DEF GETSONGINFO(path$)
 BUNDLE.CLEAR songinfo
 AUDIO.STOP
 AUDIO.LOAD mySong, path$
 AUDIO.INFO mySong, songInfo
 AUDIO.RELEASE  mysong
 FN.RTN songinfo
FN.END

FN.DEF AUDIO$(audio$)
 BUNDLE.GET 1, "gw-last-edited-page", page
 u$="blue_audio"
 ax$=GW_FORMAT_LINK$("audiooff")
 html$+="<div id='"+u$+"' class='audio-bar slide-in'>"
 html$+="<audio id='"+u$+"-src' controls> <source src='"+audio$+"'> </audio> <a class='aud_btn' href='#' onclick='"+ax$+"'><span class='aud_btn_txt'>X</span></a>"

 html$+="<div id='"+u$+"-txt' class='audio_txt_container'>"
 html$+="<span id='audio-title' class='audio_title aud_btn_txt'></span>"
 html$+="<span id='audio-artist' class='audio_artist aud_btn_txt'></span>"
 html$+="</div>"
 html$+="</div>"
 REM GW_INSERT_BEFORE(page, "<div", html$)
 GW_ADD_SKEY("control", u$)
 FN.RTN html$
FN.END

FN.DEF AUDIO(page, audio$)
 GW_REGISTER("AUDIO")
 GW_SET_SKEY("page", page, GW_PAGE$(page) + AUDIO$(audio$))
 ls = GW_KEY_IDX("control")
 FN.RTN ls
FN.END




FN.DEF MODIFY_AUDIO (ctl, path$)


 songinfo=getsonginfo(path$)
 BUNDLE.GET songInfo,"Title", title$
 BUNDLE.GET songInfo,"Artist",artist$
 REM  BUNDLE.CONTAIN songinfo, "Duration", ok
 REM  BUNDLE.GET songInfo,"Duration", duration$


 D$=CHR$(34)
 gw$="audio"

 JS("$('#"+GW$+"-player').removeClass('slide-out')")
 JS("$('#"+GW$+"-src')[0].pause();")
 JS$="$('#"+GW$+"-src').attr('src', '"+path$+"');"
 JS(js$)
 JS$="document.getElementById("+D$+gw$+"-src"+D$+").parentElement.load()"
 JS(js$)
 ? artist$, title$
 JS("populate("+D$+"audio-title"+D$+","+D$+title$+D$+")")
 JS("populate("+D$+"audio-artist"+D$+","+D$+artist$+D$+")")
 PAUSE 100

 JS("$('#"+GW$+"-player').addClass('on')")
 JS("$('#"+GW$+"-player').addClass('slide-in')")
 JS("$('#"+GW$+"-src')[0].play();")

FN.END









d$=CHR$(34)


l$="<script>"

l$+="$(document).ready(function(){

l$+="var aud = $('#audio-src')[0];"

l$+="aud.ontimeupdate = function(){"
l$+="document.getElementById('durttl').innerHTML = aud.duration;"
l$+="$('.progress').css('width', aud.currentTime / aud.duration * 100 + '%');"

l$+=" document.getElementById('elapse').innerHTML = minAndSec(aud.currentTime);

l$+="};"

l$+="});"

l$+="</script>









l$+="<script>

l$+="function minAndSec(sec) {

l$+=" sec = parseInt(sec);

l$+=" return Math.floor(sec / 60) + ':' + (sec % 60 < 10 ? '0' : '') + Math.FLOOR(sec % 60);"

l$+=" }"

l$+="</script>











!!
rem l$+="$('#durttl').text(aud.duration);
 rem l$+="alert(aud.duration);"

script$+="var song = $('#audio-src')[0];"
script$+="alert(song);
script$+="song.addEventListener('timeupdate',function (){"

script$+="var duration = song.duration;"
script$+="var sec= new Number();"
script$+="var min= new Number();"

script$+="sec = Math.FLOOR( duration );"
script$+="min = Math.FLOOR( sec / 60 );"
script$+="min = min >= 10 ? min : '0' + min;"
script$+="sec = Math.FLOOR( sec % 60 );"
script$+="sec = sec >= 10 ? sec : '0' + sec;"

script$+="$('#elapse').html(min + ':'+ sec); });

script$+=" $(document).ready(function() { var audio = $('#audio-src')[0]; $('#audio-src').on('loadedmetadata', function() { $('#durttl').text(audio.duration); }); });"

script$+="$(document).ready(function() { var audio = $('#audio-src')[0]; $('#audio-src').on('loadedmetadata', function() { $('#elapse').text(audio.currentTime); }); });"

script$+="$(document).ready(function() { var audio = $('#audio-src')[0]; $('#audio-src').on('loadedmetadata', function() { alert(audio.duration); }); });"

formatTime(seconds) { const h = Math.floor(seconds / 3600) const m = Math.floor((seconds % 3600) / 60) const s = seconds % 60 return [h, m > 9 ? m : h ? '0' + m : m || '0', s > 9 ? s : '0' + s] .filter(a => a) .join(':') }
!!






l$+="<style>

l$+=".audio-player {"
REM l$+="display:none;
l$+="position: fixed;"
l$+="bottom:49px;
l$+="width: 95%;"
l$+="height: 40px;"
l$+="background-color: rgba(0,0,0,0.2);"
REM l$+="display: flex;"
l$+="border-radius: 0px;"
l$+="padding: 4px;"
REM l$+="background-color:red;
l$+="}"

l$+=".audio-info {"
l$+="display: flex;"
l$+="flex-flow: column nowrap;"
l$+="justify-content: center;"
l$+="width: 50%;"
l$+="padding: 0;"
l$+="}"

l$+=".audio-title {"
l$+="font-size: 15px;"
l$+="font-weight: bold;"
l$+="}"

l$+=".audio-artist {"
l$+="font-size: 12px;"
l$+="}"



l$+=".dur {"
l$+="position:absolute;
l$+="right: 6px;
l$+="}"

l$+=".durttl {"
REM l$+="font-weight: bold;
l$+="}"

l$+=".elapse {"
l$+="font-weight: bold;
l$+="}"




l$+=".progress {"
l$+="position: absolute;"
l$+="height: 4px;"
l$+="left: 0;"
l$+="bottom: 0;"
l$+="background-color: #00a8ff;"
l$+="width: 0;"
l$+="}"

l$+="</style>








l$+="<div id='audio-player' class='audio-player' >"



l$+="<div class='progress'>"
l$+="</div>"




l$+="<div class='audio-info'>"
l$+="<div id='audio-artist' class='audio-artist'>Pink Floyd</div>"
l$+="<div id='audio-title' class='audio-title'>Dark side of the moon</div>"
l$+="</div>"



l$+="<audio id='audio-src' src='song.m4a' > </audio>"


l$+="<div class='dur'>"
l$+="<div id='durttl'>P 00:00</div>"
l$+="<div id='elapsed'> <span id='elapse'>00:00</span>


l$+="</div>"

l$+="</div>"





l$+="</div>"





!!

l$="<h2>Sound Information</h2> <div id='length'>Duration:</div> <div id='source'>Source:</div> <div id='status' style='color:red;'>Status: Loading</div> <hr> <h2>Control Buttons</h2> <button id='play'>Play</button> <button id='pause'>Pause</button> <button id='restart'>Restart</button> <hr> <h2>Playing Information</h2> <div id='currentTime'>0</div>

!!









BUNDLE.PUT 1, "blue_path", ""
REM setup alot of paths
ext$="file://"
FILE.ROOT p$
rootpath$=ext$+p$+"/"
BUNDLE.PUT 1, "rootpath", rootpath$
ARRAY.LOAD type$[], "_External", "_SdRemovable", "_Dcim", "_Documents", "_Downloads", "_Movies", "_Music", "_Notifications", "_Pictures", "_Podcasts"

FILE.ROOT Path$, type$[1]
path$=ext$+path$+"/"
internal_path$=path$
blue_path$=path$+"Blue/Explorer/"
BUNDLE.PUT 1, "blue_path", blue_path$
BUNDLE.PUT 1, "internal_path", path$

source_path$ =internal_path$+"RFO-BASIC/source/"
BUNDLE.PUT 1, "source_path", source_path$
rfo_data_path$ =internal_path$+"RFO-BASIC/data/"
BUNDLE.PUT 1, "rfo_data_path", rfo_data_path$

REM--------- sdcard will always refer to the external removable
FILE.ROOT SDcard_Path$, type$[2]
IF LEN(sdcard_path$)
 sdcard_path$=ext$+sdcard_path$+"/"
ENDIF
BUNDLE.PUT 1, "sdcard_path", sdcard_path$

FILE.ROOT camera_path$, type$[3]
camera_path$=ext$+camera_path$+"/"
BUNDLE.PUT 1, "camera_path", camera_path$

FILE.ROOT ddocuments_path$, type$[4]
ddocuments_path$=ext$+ ddocuments_path$+"/"
BUNDLE.PUT 1, "documents_path", ddocuments_path$

FILE.ROOT ddownloads_path$, type$[5]
ddownloads_path$=ext$+ddownloads_path$+"/" 
BUNDLE.PUT 1, "downloads_path", ddownloads_path$

FILE.ROOT movies_path$, type$[6]
movies_path$=ext$+movies_path$+"/"
BUNDLE.PUT 1, "movies_path", movies_path$

FILE.ROOT music_path$, type$[7]
music_path$=ext$+music_path$+"/" 
BUNDLE.PUT 1, "music_path", music_path$

FILE.ROOT notifications_path$, type$[8]
notifications_path$=ext$+notifications_path$+"/"
BUNDLE.PUT 1, "notifications_path", notifications_path$

FILE.ROOT  pictures_path$, type$[9] 
pictures_path$=ext$+pictures_path$+"/"
BUNDLE.PUT 1, "pictures_path", pictures_path$

FILE.ROOT podcasts_path$, type$[10]
podcasts_path$=ext$+ podcasts_path$+"/"
BUNDLE.PUT 1, "podcasts_path", podcasts_path$


REM------------------ setup explorer paths
icon_path$= blue_path$+"Icons/"
BUNDLE.PUT 1, "icon_path", icon_path$

font_path$= blue_path$+"Fonts/"
BUNDLE.PUT 1, "font_path", font_path$

jquery_path$=blue_path$+"Jquery/"
BUNDLE.PUT 1, "jquery_path", jquery_path$

themes_path$=blue_path$+"Themes/"
BUNDLE.PUT 1, "themes_path", themes_path$

colorpicker_path$ =blue_path$+"Colorpicker/"
BUNDLE.PUT 1, "colorpicker_path", colorpicker_path$

REM--------------------------- Permissions
ARRAY.LOAD permissions$[], "OOPS", "Read", "Write", "Read and Write", "No Sdcard"
FILE.EXISTS lvar, internal_path$
BUNDLE.PUT 1, "permission_main", permissions$[lvar]
FILE.EXISTS lvar, sdcard_path$
IF !lvar | var= -1
 lvar=5
ENDIF
BUNDLE.PUT 1, "permission_sd", permissions$[lvar]
data_path$=blue_path$+"data/"
BUNDLE.PUT 1, "Sdcard_exists", lvar % if lvar =5 no sdcard
BUNDLE.PUT 1, "data_path", data_path$
data_file$="default.txt" % set default
BUNDLE.PUT 1, "data_file", data_file$ 
BUNDLE.PUT 1, "Sdcard", "" % note:
BUNDLE.PUT 1, "SDCard", "" % CAPS matter in a BUNDLE
BUNDLE.PUT 1, "error", "none"

REM--------------------------- sdcard name, mine is 3231-6231
p$=sdcard_path$
IF LEN(p$)
 SPLIT p$[], p$, "/"
 ARRAY.LENGTH l, p$[]
 BUNDLE.PUT 1, "sdcard_name", p$[l]
ENDIF



REM INCLUDE "BLUE_FN.bas"



MainPage:

main = GW_NEW_PAGE()

sub_num =GW_ADD_TEXT(main, "Items Disabled: 0")
sub_open_A =GW_ADD_TEXT(main, "Name: ")
sub_open_B =GW_ADD_TEXT(main, "Ctl ID: ")
menu_open_a = GW_ADD_TEXT(main, "Ctl ID: ")

REM GW_USE_THEME_CUSTO_ONCE("icon=off notext style='background:transparent; border:0; shadow: none;'")

GW_ADD_BUTTON (main, "on ", "on")


GW_ADD_BUTTON (main, "off ", "off")

GW_ADD_BUTTON (main, "play ", "play")
GW_ADD_BUTTON (main, "duration", "duration")


GW_INJECT_HTML(main, l$)



REM GW_INSERT_BEFORE(main, "<div", script$)

GW_RENDER (main)

REM change_theme(1,1)

b$="song.m4a"
REM MODIFY_AUDIO (AUDIO, pat$+b$)
d$=CHR$(34)
title$="PUSSY"
JS("populate("+D$+"audio-title"+D$+","+D$+title$+D$+")")

REMJS$="$('.progress').css('width','40%')"
REM js(js$)

REM JS("$('#audio')[0].play();")
loop:



a$=gw_wait_action$()
IF a$= "BACK" THEN END
? a$


IF a$="duration"

 js$="var dur = $('#audio-src')[0];"
 js$+="alert(dur.duration);"
 REM js(js$)


 js$="var dur = $('#audio-src')[0];"
 js$+="alert(dur.currentTime);"
 js(js$)




ENDIF






IF a$="off"
 JS$="$('.audio-player').addClass('slide-out').css('display','none');"
 js(js$)
 JS("$('#audio-src')[0].pause();")
ENDIF





IF a$="on"
 REM  p$= sdcard_path$+"music/rock/"+ "rainbow.mp3"


 p$= sdcard_path$+"music/rock/"+"Boston - A New World.mp3"

 REM  file$= "rainbow.mp3"
 JS$="$('#audio-src').attr('src', '"+p$+"');"
 JS(js$)
 JS$="document.getElementById("+D$+"audio-src"+D$+").parentElement.load()"
 JS(js$)
 JS$="$('.audio-player').addClass('slide-in').css('display','flex');"
 js(js$)
 JS("$('#audio-src')[0].play();")


ENDIF


IF a$="play"
 REM  p$= sdcard_path$+"music/rock/rainbow.mp3"

 p$= sdcard_path$+"music/rock/"+"Boston - A New World.mp3"

 MODIFY_AUDIO (ctl, p$)
ENDIF

REM JS("$('#audio')[0].pause();")





GOTO loop
