
PROGRAM _INIT
	
	MpAlarmXCoreObject(MpLink := ADR(gAlarmXCoreLink) , Enable := FALSE);
	MpAlarmXHistory_0(MpLink := ADR(gAlarmXHistoryLink), DeviceName := ADR('AUDIT'), Enable := FALSE);
	
END_PROGRAM

PROGRAM _CYCLIC
	
	MpAlarmXCoreObject(Enable := TRUE);
	MpAlarmXHistory_0(Enable := TRUE);
	
	//TEST ALARM
	IF(TriggerAlarm)THEN
		MpAlarmXSet(MpLink := gAlarmXCoreLink, Name := 'AlarmTest');
		TriggerAlarm := FALSE;
	END_IF
		
END_PROGRAM

PROGRAM _EXIT
	
	MpAlarmXCoreObject(Enable := FALSE);
	MpAlarmXHistory_0(Enable := FALSE);
	 
END_PROGRAM

