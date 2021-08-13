
ACTION ManualMode:
	
	IF ManualModePara.Direction = POSITIVE THEN // set actual axis velocity based on which direction it's set to be moved
		ManualModePara.JogVelocityActual := ManualModePara.JogVelocity;
	ELSIF ManualModePara.Direction = NEGATIVE THEN
		ManualModePara.JogVelocityActual := -1 * ManualModePara.JogVelocity;
	END_IF
	
	RoboArmPara.Jog.CoordSystem := ManualModePara.CoordinateSystem;
	RoboArmPara.Jog.PathLimits := ManualModePara.PathLimits;
	
	IF ManualModePara.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
		RoboArmPara.Jog.Velocity[0] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSIF ManualModePara.AxisButton.Q2 THEN
		RoboArmPara.Jog.Velocity[1] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSIF ManualModePara.AxisButton.Q3 THEN
		RoboArmPara.Jog.Velocity[2] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSIF ManualModePara.AxisButton.Q4 THEN
		RoboArmPara.Jog.Velocity[3] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSIF ManualModePara.AxisButton.Q5 THEN
		RoboArmPara.Jog.Velocity[4] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSIF ManualModePara.AxisButton.Q6 THEN
		RoboArmPara.Jog.Velocity[5] := ManualModePara.JogVelocityActual;
		RoboArm6Axis.Jog := TRUE;
	ELSE //if no buttons are pressed reset jog velocity array
		RoboArm6Axis.Jog := FALSE;
		FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
			RoboArmPara.Jog.Velocity[j] := 0.0;
		END_FOR;
	END_IF
	
END_ACTION
