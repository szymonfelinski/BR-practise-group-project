
FUNCTION_BLOCK R3SemiAutoMode
	CASE SemiAutoModePara.State OF
		INIT:
			IF SemiAutoModePara.UpdatePending THEN
				SemiAutoModePara.State := UPDATE;
			ELSE
				SemiAutoModePara.State := START;
			END_IF
			SemiAutoModePara.ModeForThisMove:=SemiAutoModePara.Mode;
			SemiAutoModePara.PathModeForThisMove:=SemiAutoModePara.PathMode;
			//TODO CHECK AXIS LIMITS AND SINGULAR POINT AND SEND ERROR (ALARM) AND AVOID MOVING
			IF checkAxisLimits(Q1:=SemiAutoModePara.AxisDistance.Q1,Q2:=SemiAutoModePara.AxisDistance.Q2,Q3:=SemiAutoModePara.AxisDistance.Q3,Q4:=SemiAutoModePara.AxisDistance.Q4,Q5:=SemiAutoModePara.AxisDistance.Q5,Q6:=SemiAutoModePara.AxisDistance.Q6,Mode := SemiAutoModePara.ModeForThisMove, RoboArm:=RoboArm) THEN
			// send alarm out of bounds
			//MpAlarmXSet(gAlarmXCore, 'OutOfLimits');
			END_IF
			
			// check for singular point and send alarm
				
		UPDATE:
			RoboArmPara.Distance[0] := SemiAutoModePara.AxisDistance.Q1;
			RoboArmPara.Distance[1] := SemiAutoModePara.AxisDistance.Q2;
			RoboArmPara.Distance[2] := SemiAutoModePara.AxisDistance.Q3;
			RoboArmPara.Distance[3] := SemiAutoModePara.AxisDistance.Q4;
			RoboArmPara.Distance[4] := SemiAutoModePara.AxisDistance.Q5;
			RoboArmPara.Distance[5] := SemiAutoModePara.AxisDistance.Q6;
			RoboArmPara.CoordSystem := SemiAutoModePara.CoordinateSystem;
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
			END_IF
		START:
			IF SemiAutoModePara.Flag THEN
				IF SemiAutoModePara.PathModeForThisMove THEN
					RoboArm.MoveLinear:=TRUE;
				ELSE 
					RoboArm.MoveDirect:=TRUE;
				END_IF
				SemiAutoModePara.State:=GO;
			END_IF
		GO:
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
	END_CASE
END_FUNCTION_BLOCK
