
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3ManualMode
	
	IF ManualModePara.Direction = 1 THEN // set actual axis velocity based on which direction it's set to be moved
		JogVelocityActual := ManualModePara.JogVelocity;
	ELSIF ManualModePara.Direction = -1 THEN
		JogVelocityActual := -1 * ManualModePara.JogVelocity;
	END_IF
	
	RoboArmPara.Jog.CoordSystem := ManualModePara.CoordinateSystem;
	RoboArmPara.Jog.PathLimits := ManualModePara.PathLimits;
	
	IF ManualModePara.ActivateMove THEN
		
		IF ManualModePara.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
			RoboArmPara.Jog.Velocity[0] := JogVelocityActual;
			
		ELSIF ManualModePara.AxisButton.Q2 THEN
			RoboArmPara.Jog.Velocity[1] := JogVelocityActual;
			
		ELSIF ManualModePara.AxisButton.Q3 THEN
			RoboArmPara.Jog.Velocity[2] := JogVelocityActual;
			
		ELSIF ManualModePara.AxisButton.Q4 THEN
			RoboArmPara.Jog.Velocity[3] := JogVelocityActual;
			
		ELSIF ManualModePara.AxisButton.Q5 THEN
			RoboArmPara.Jog.Velocity[4] := JogVelocityActual;
			
		ELSIF ManualModePara.AxisButton.Q6 THEN
			RoboArmPara.Jog.Velocity[5] := JogVelocityActual;
			
		ELSE //if no buttons are pressed reset jog velocity array
			
			FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
				RoboArmPara.Jog.Velocity[j] := 0.0;
			END_FOR;
		END_IF
		RoboArm.Jog := TRUE;
	ELSE
		RoboArm.Jog := FALSE;
	END_IF
	
		
END_FUNCTION_BLOCK
