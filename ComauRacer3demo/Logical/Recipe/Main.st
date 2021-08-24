
PROGRAM _INIT
	MpRecipeXml_0(MpLink := ADR(gRecipeXmlLink), Enable := FALSE, ErrorReset := TRUE, DeviceName := ADR('RECIPE') , FileName := ADR('Recipe_0'));
END_PROGRAM

PROGRAM _CYCLIC
		MpRecipeXml_0(Enable :=TRUE);
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

