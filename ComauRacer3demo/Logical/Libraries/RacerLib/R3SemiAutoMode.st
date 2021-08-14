
FUNCTION_BLOCK R3SemiAutoMode
	CASE SemiAutoModePara.State OF
		INIT:
			IF SemiAutoModePara.UpdatePending THEN
				SemiAutoModePara.State := UPDATE;
			ELSE
				SemiAutoModePara.State := START;
			END_IF
				
		UPDATE:
			RoboArm.Update:= TRUE;
			IF RoboArm.UpdateDone THEN
				SemiAutoModePara.ModeForThisMove:=SemiAutoModePara.Mode;
				RoboArm.Update:=FALSE;
				SemiAutoModePara.UpdatePending:=FALSE;
				SemiAutoModePara.State := START;
			END_IF
		START:
			IF SemiAutoModePara.ModeForThisMove THEN
				RoboArm.MoveLinear:=TRUE;
			ELSE 
				RoboArm.MoveDirect:=TRUE;
			END_IF
			SemiAutoModePara.State:=GO;
		GO:
			IF RoboArm.MoveDone THEN
				IF SemiAutoModePara.ModeForThisMove THEN
					RoboArm.MoveLinear:=FALSE;
				ELSE 
					RoboArm.MoveDirect:=FALSE;
				END_IF
				SemiAutoModePara.State:=INIT;
				MainState := STATE_READY;
				ControlSelector:=None;
			END_IF
	END_CASE
END_FUNCTION_BLOCK
