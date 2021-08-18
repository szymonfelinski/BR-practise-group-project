
ACTION UpdateCheck: 
	IF CoordinateSystem THEN //Coordinate system in ManualControl and SemiAutoControl: 9-global  0-axis
		ManualControlPara.CoordinateSystem := 9;
		IF SemiAutoControlPara.CoordinateSystem <> 9 THEN
			SemiAutoControlPara.CoordinateSystem := 9;
			SemiAutoControlPara.UpdatePending := TRUE;
		END_IF
	ELSE
		ManualControlPara.CoordinateSystem := 0;
		IF SemiAutoControlPara.CoordinateSystem <> 0 THEN
			SemiAutoControlPara.CoordinateSystem := 0;
			SemiAutoControlPara.UpdatePending := TRUE;
		END_IF
	END_IF
	
	IF SemiAutoControlPara.PathMode <> PathSystem THEN
		SemiAutoControlPara.PathMode := PathSystem;
		SemiAutoControlPara.UpdatePending :=TRUE;
		// TODO Auto too
	END_IF
	
	IF SemiAutoControlPara.Mode <> ModeSystem THEN
		SemiAutoControlPara.Mode := ModeSystem;
		SemiAutoControlPara.UpdatePending :=TRUE;
		// TODO Auto too
	END_IF
	IF RoboArm6AxisPara.Distance[0] <>  SemiAutoModePara.AxisDistance.Q1 OR RoboArm6AxisPara.Distance[1] <>  SemiAutoModePara.AxisDistance.Q2 OR RoboArm6AxisPara.Distance[2] <>  SemiAutoModePara.AxisDistance.Q3 OR RoboArm6AxisPara.Distance[3] <>  SemiAutoModePara.AxisDistance.Q4 OR RoboArm6AxisPara.Distance[4] <>  SemiAutoModePara.AxisDistance.Q5 OR RoboArm6AxisPara.Distance[5] <>  SemiAutoModePara.AxisDistance.Q6 THEN
		SemiAutoControlPara.UpdatePending :=TRUE;
	END_IF
	
END_ACTION
