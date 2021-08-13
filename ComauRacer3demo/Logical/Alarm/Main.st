
PROGRAM _INIT
	
	MpAlarmXCore_0(MpLink := ADR(gAlarmXCore) , Enable := TRUE);
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	MpAlarmXCore_0();
	 
END_PROGRAM

PROGRAM _EXIT
	
	MpAlarmXCore_0(MpLink := ADR(gAlarmXCore) , Enable := FALSE);
	 
END_PROGRAM

