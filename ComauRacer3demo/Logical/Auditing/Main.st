PROGRAM _INIT
	MpAuditTrail_0.Enable := FALSE;
	MpAuditTrail_0.MpLink := ADR(gAuditTrailLink);
	MpAuditTrail_0.DeviceName := ADR('AUDIT');
	MpAuditTrail_0();
END_PROGRAM

PROGRAM _CYCLIC

	MpAuditTrail_0.Enable := TRUE;	

	IF(TriggerEvent)THEN
		CustomEventStatus := MpAuditCustomEvent(MpLink := gAuditTrailLink, Type := TypeVar, Message := MessageVar, Comment := CommentVar);
		TriggerEvent := FALSE;
	END_IF
	
	MpAuditTrail_0();
	
END_PROGRAM

PROGRAM _EXIT
	MpAuditTrail_0.Enable := FALSE;
	MpAuditTrail_0();
END_PROGRAM
