
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
	IF RoboArm6AxisPara.Distance[0] <>  SemiAutoControlPara.AskedValue.Q0 OR RoboArm6AxisPara.Distance[1] <>  SemiAutoControlPara.AskedValue.Q1 OR RoboArm6AxisPara.Distance[2] <>  SemiAutoControlPara.AskedValue.Q2 OR RoboArm6AxisPara.Distance[3] <>  SemiAutoControlPara.AskedValue.Q3 OR RoboArm6AxisPara.Distance[4] <>  SemiAutoControlPara.AskedValue.Q4 OR RoboArm6AxisPara.Distance[5] <>  SemiAutoControlPara.AskedValue.Q5  OR RoboArm6AxisPara.Position[0] <>  SemiAutoControlPara.AskedValue.Q0 OR RoboArm6AxisPara.Position[1] <>  SemiAutoControlPara.AskedValue.Q1 OR RoboArm6AxisPara.Position[2] <>  SemiAutoControlPara.AskedValue.Q2 OR RoboArm6AxisPara.Position[3] <>  SemiAutoControlPara.AskedValue.Q3 OR RoboArm6AxisPara.Position[4] <>  SemiAutoControlPara.AskedValue.Q4 OR RoboArm6AxisPara.Position[5] <>  SemiAutoControlPara.AskedValue.Q5 THEN
		SemiAutoControlPara.UpdatePending :=TRUE;
		
		// TODO possible update with bind event for change value in semi auto control panel so it doesnt have to check it every loop
	END_IF
	
END_ACTION
