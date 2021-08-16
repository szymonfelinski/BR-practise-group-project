
FUNCTION_BLOCK R3SemiAutoMode
	CASE SemiAutoModePara.State OF
		INIT:
			IF SemiAutoModePara.UpdatePending THEN
				SemiAutoModePara.State := UPDATE;
			ELSE
				SemiAutoModePara.State := START;
			END_IF
				
		UPDATE:
			RoboArmPara.Distance[0] := SemiAutoModePara.AxisDistance.Q1;
			RoboArmPara.Distance[1] := SemiAutoModePara.AxisDistance.Q2;
			RoboArmPara.Distance[2] := SemiAutoModePara.AxisDistance.Q3;
			RoboArmPara.Distance[3] := SemiAutoModePara.AxisDistance.Q4;
			RoboArmPara.Distance[4] := SemiAutoModePara.AxisDistance.Q5;
			RoboArmPara.Distance[5] := SemiAutoModePara.AxisDistance.Q6;
			IF SemiAutoModePara.Mode THEN
				//TODO change to enum values
				RoboArmPara.ManualMoveType := 1;
			ELSE
				RoboArmPara.ManualMoveType := 0;
			END_IF
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
				SemiAutoModePara.Flag:=FALSE;
				MainState := STATE_READY;
				ControlSelector:=None;
			END_IF
	END_CASE
END_FUNCTION_BLOCK