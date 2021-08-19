PROGRAM _INIT
	MpAuditTrail_0.Enable := FALSE;
	MpAuditTrail_0.MpLink := ADR(gAuditTrailLink);
	MpAuditTrail_0.DeviceName := ADR('AUDIT');
	MpAuditTrail_0();
END_PROGRAM

PROGRAM _CYCLIC

	MpAuditTrail_0.Enable := TRUE;	
	//Triggering User custom event used for testing audit system.
	IF(TriggerEvent)THEN
		CustomEventStatus := MpAuditCustomEvent(MpLink := gAuditTrailLink, Type := TypeVar, Message := MessageVar, Comment := CommentVar);
		//MpAuditStringChange(MpLink:= gAuditTrailLink, Old :='MANUAL',New:='AUTO', Identifier := 'MODE');
 
		TriggerEvent := FALSE;
	END_IF
	//Cleaning Buffer using ClearBufferBool/ Click button event sets ClearBufferBool value to TRUE.
	IF(ClearBufferBool)THEN
		MpAuditClearBuffer(MpLink :=gAuditTrailLink);
		ClearBufferBool := FALSE;
	END_IF
	
	MpAuditTrail_0();
	
END_PROGRAM

PROGRAM _EXIT
	MpAuditTrail_0.Enable := FALSE;
	MpAuditTrail_0();
END_PROGRAM
