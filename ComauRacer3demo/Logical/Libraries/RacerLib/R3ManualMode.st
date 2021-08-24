
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3ManualMode
	
	IF ManualModePara.Direction = 1 THEN // set actual axis velocity based on which direction it's set to be moved
		JogVelocityActual := ManualModePara.JogVelocity;
	ELSIF ManualModePara.Direction = -1 THEN
		JogVelocityActual := -1 * ManualModePara.JogVelocity;
	ELSIF  ManualModePara.Direction = 0 THEN
		JogVelocityActual := 0;
	END_IF
	
	RoboArmPara.Jog.CoordSystem := ManualModePara.CoordinateSystem;
	RoboArmPara.Jog.PathLimits := ManualModePara.PathLimits;
	
	IF ManualModePara.ActivateMove THEN
		(* old Szymon's version
		IF ManualModePara.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
			//IF RoboArmPara.Jog.Velocity[0] <> JogVelocityActual THEN // test if this fixes strange movement style
				RoboArmPara.Jog.Velocity[0] := JogVelocityActual;
			//END_IF
		ELSIF ManualModePara.AxisButton.Q2 THEN
			//IF RoboArmPara.Jog.Velocity[1] <> JogVelocityActual THEN
				RoboArmPara.Jog.Velocity[1] := JogVelocityActual;
			//END_IF	
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
		*)
		
		IF ManualModePara.AxisButton.Q1 THEN
			RoboArmPara.Jog.Velocity[0] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[0] := 0;
		END_IF
		
		IF ManualModePara.AxisButton.Q2 THEN
			RoboArmPara.Jog.Velocity[1] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[1] := 0;
		END_IF
		
		IF ManualModePara.AxisButton.Q3 THEN
			RoboArmPara.Jog.Velocity[2] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[2] := 0;
		END_IF
		
		IF ManualModePara.AxisButton.Q4 THEN
			RoboArmPara.Jog.Velocity[3] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[3] := 0;
		END_IF
		
		IF ManualModePara.AxisButton.Q5 THEN
			RoboArmPara.Jog.Velocity[4] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[4] := 0;
		END_IF
		
		IF ManualModePara.AxisButton.Q6 THEN
			RoboArmPara.Jog.Velocity[5] := JogVelocityActual;
		ELSE
			RoboArmPara.Jog.Velocity[5] := 0;
		END_IF
		IF RoboArm.Jog <> TRUE THEN
			RoboArm.Jog := TRUE;
		END_IF
	ELSE
		RoboArm.Jog := FALSE;
	END_IF
	
	IF ManualModePara.ExitManual THEN
		//clean up
		ManualModePara.Direction:=0;
		JogVelocityActual:=0;
		FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
				RoboArmPara.Jog.Velocity[j] := 0;
		END_FOR;
		ManualModePara.ActivateMove:=FALSE;
		RoboArm.Jog:=FALSE;
		//go out
		ManualModePara.ExitManual := FALSE;
	END_IF
	
		
END_FUNCTION_BLOCK
