







GRABFILE FN$, "../source/blue_fn.bas"
 i=IS_IN("data-role='popup", FN$)
 WHILE i
  ct++
  i=IS_IN("data-role='popup", FN$, i+1)
  
 rem j=IS_IN("FN.DEF ", FN$, -1)
  
 rem ? mid$(fn$, i-20, 30)
  
 REPEAT
 
? ct;" list"
end






 i=IS_IN("ARRAY.LOAD", FN$)
 WHILE i
  ct++
  i=IS_IN("ARRAY.LOAD", FN$, i+1)
 REPEAT
 
? ct;"ARRAY.LOAD"

end "DONE"












!!
+ FN_COUNT(both, sort)
 LIST.CREATE s, FN_COUNTa
 LIST.CREATE s, FN_COUNTb
 ct=1
 GRABFILE FN$, "../source/blue_fn.bas"
 i=IS_IN("LIST.CREATE", FN$)
 WHILE i
  x=IS_IN(")", FN$, i+1)
  k$=MID$(FN$, i, x-i+1)
 ! LIST.ADD FN_COUNta, k$
 ? k$
  ct++
  i=IS_IN("LIST.CREATE", FN$, i+1)
 REPEAT
 IF both 
  ct2=1
  GRABFILE FN$, "../source/GW_blue.bas" 
  i=IS_IN("FN.DEF", FN$)
  WHILE i
   x=IS_IN(")", FN$, i+1)
   k$=MID$(FN$, i, x-i+1)
   LIST.ADD FN_COUNTb, k$
   ct2++
   i=IS_IN("FN.DEF", FN$, i+1)
  REPEAT 
 ENDIF
 IF sort
  LIST.SORT FN_COUNTa
  IF both
   LIST.SORT FN_COUNTb
  ENDIF
 ENDIF
 BUNDLE.PUT 1, "FN_COUNTa", FN_COUNTa
 BUNDLE.PUT 1, "FN_COUNTb", FN_COUNTb
 fn$=""
 FN.RTN FN_COUNTa
FN.END
!!




end "DONE"
