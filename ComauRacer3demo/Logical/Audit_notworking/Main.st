PROGRAM _INIT
	MpAuditTrail_0.Enable := TRUE;
	MpAuditTrail_0.MpLink := ADR(gAuditTrail);
	MpAuditTrail_0.DeviceName := ADR('CF');
	MpAuditTrail_0.Language := ADR('end|metric');
END_PROGRAM

PROGRAM _CYCLIC

	MpAuditTrail_0();
	
	IF(TriggerEvent)THEN
		CustomEventStatus := MpAuditCustomEvent(MpLink := gAuditTrail, Type := TypeVar, Message := MessageVar, Comment := CommentVar);
		TriggerEvent := FALSE;
	END_IF
	
	
END_PROGRAM

PROGRAM _EXIT
	MpAuditTrail_0.Enable := FALSE;
	MpAuditTrail_0();
END_PROGRAM
