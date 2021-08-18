
FUNCTION_BLOCK R3SemiAutoMode

	IF SemiAutoModePara.ExitSemiAuto THEN
		SemiAutoModePara.State := STATE_STOP;
	END_IF
	
	(*
	IF SemiAutoModePara.Pause THEN
		SemiAutoModePara_memory := SemiAutoModePara;
		RoboArm.MoveDirect:=FALSE;
		RoboArm.MoveLinear:=FALSE;
		SemiAutoModePara.Flag:=FALSE;
	END_IF
	*)
	CASE SemiAutoModePara.State OF
		INIT:
			IF SemiAutoModePara.UpdatePending THEN
				SemiAutoModePara.State := UPDATE;
			ELSE
				SemiAutoModePara.State := START;
			END_IF

			//TODO CHECK AXIS LIMITS AND SINGULAR POINT AND SEND ERROR (ALARM) AND AVOID MOVING
			IF checkAxisLimits(Q1:=SemiAutoModePara.AskedValue.Q0,Q2:=SemiAutoModePara.AskedValue.Q1,Q3:=SemiAutoModePara.AskedValue.Q2,Q4:=SemiAutoModePara.AskedValue.Q3,Q5:=SemiAutoModePara.AskedValue.Q4,Q6:=SemiAutoModePara.AskedValue.Q5,Mode := SemiAutoModePara.ModeForThisMove, RoboArm:=RoboArm) THEN
			// send alarm out of bounds
			//MpAlarmXSet(gAlarmXCore, 'OutOfLimits');
			END_IF
			
			// check for singular point and send alarm
				
		UPDATE:
				RoboArmPara.Distance[0] := SemiAutoModePara.AskedValue.Q0;
				RoboArmPara.Distance[1] := SemiAutoModePara.AskedValue.Q1;
				RoboArmPara.Distance[2] := SemiAutoModePara.AskedValue.Q2;
				RoboArmPara.Distance[3] := SemiAutoModePara.AskedValue.Q3;
				RoboArmPara.Distance[4] := SemiAutoModePara.AskedValue.Q4;
				RoboArmPara.Distance[5] := SemiAutoModePara.AskedValue.Q5;
				
				RoboArmPara.Position[0] := SemiAutoModePara.AskedValue.Q0;
				RoboArmPara.Position[1] := SemiAutoModePara.AskedValue.Q1;
				RoboArmPara.Position[2] := SemiAutoModePara.AskedValue.Q2;
				RoboArmPara.Position[3] := SemiAutoModePara.AskedValue.Q3;
				RoboArmPara.Position[4] := SemiAutoModePara.AskedValue.Q4;
				RoboArmPara.Position[5] := SemiAutoModePara.AskedValue.Q5;

			RoboArmPara.CoordSystem := SemiAutoModePara.CoordinateSystem;
			SemiAutoModePara.ModeForThisMove:=SemiAutoModePara.Mode;
			SemiAutoModePara.PathModeForThisMove:=SemiAutoModePara.PathMode;
			IF SemiAutoModePara.Mode THEN
				RoboArmPara.ManualMoveType := 1;
			ELSE
				RoboArmPara.ManualMoveType := 0;
			END_IF
			RoboArm.Update:= TRUE;
			IF RoboArm.UpdateDone THEN
				RoboArm.Update:=FALSE;
				SemiAutoModePara.UpdatePending:=FALSE;
				SemiAutoModePara.State := START;
				WeNeedToGoBack:=FALSE;
			END_IF
		START:
			IF SemiAutoModePara.UpdatePending THEN
				SemiAutoModePara.State:=UPDATE;
				WeNeedToGoBack := TRUE;
			END_IF
			IF SemiAutoModePara.Flag AND NOT WeNeedToGoBack THEN
				IF SemiAutoModePara.PathModeForThisMove THEN
					RoboArm.MoveLinear:=TRUE;
				ELSE 
					RoboArm.MoveDirect:=TRUE;
				END_IF
				SemiAutoModePara.State:=GO;
			END_IF
		GO:
			IF NOT SemiAutoModePara.Flag THEN
				SemiAutoModePara.State:=STATE_STOP;
			END_IF
			IF RoboArm.MoveDone THEN
				IF SemiAutoModePara.PathModeForThisMove THEN
					RoboArm.MoveLinear:=FALSE;
				ELSE 
					RoboArm.MoveDirect:=FALSE;
				END_IF
				SemiAutoModePara.State:=INIT;
				SemiAutoModePara.Flag:=FALSE;
				MainState := STATE_READY;
			END_IF
		STATE_STOP:
			RoboArm.MoveDirect:=FALSE;
			RoboArm.MoveLinear:=FALSE;
			SemiAutoModePara.Flag:=FALSE;
			SemiAutoModePara.State:=INIT;
			SemiAutoModePara.ExitSemiAuto:=FALSE;
		STATE_PAUSE:
			//TODO count movement deegrees in relative and substract so unpause in relative mode "continues"

			
	END_CASE
END_FUNCTION_BLOCK
