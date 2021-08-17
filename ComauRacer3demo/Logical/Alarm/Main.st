
PROGRAM _INIT
	
	MpAlarmXCoreObject(MpLink := ADR(gAlarmXCoreLink) , Enable := FALSE);

	 
END_PROGRAM

PROGRAM _CYCLIC
	
	MpAlarmXCoreObject(Enable := TRUE);
	
	IF(TriggerAlarm)THEN
		MpAlarmXSet(MpLink := gAlarmXCoreLink, Name := 'AlarmTest');
		TriggerAlarm := FALSE;
	END_IF
	
		
END_PROGRAM

PROGRAM _EXIT
	
	MpAlarmXCoreObject(Enable := FALSE);
	 
END_PROGRAM

