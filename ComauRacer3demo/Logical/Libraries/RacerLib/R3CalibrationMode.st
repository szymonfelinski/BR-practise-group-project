
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3CalibrationMode
	
	RoboArm.Jog := FALSE; //by default stop any jogging taking place
	
	FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
		RoboArmPara.Jog.Velocity[j] := 0.0;
	END_FOR;
	
	IF CalibrationPara.CalibrationModePara.Direction = 1 THEN // set actual axis velocity based on which direction it's set to be moved
		JogVelocityActual := CalibrationModePara.JogVelocity;
	ELSIF CalibrationPara.CalibrationModePara.Direction = -1 THEN
		JogVelocityActual := -1 * CalibrationModePara.JogVelocity;
	END_IF
	
	RoboArmPara.Jog.CoordSystem := CalibrationPara.CalibrationModePara.CoordinateSystem;
	RoboArmPara.Jog.PathLimits := CalibrationPara.CalibrationModePara.PathLimits;
	
	CASE CalibrationPara.CalibrationState OF
		STATE_START:
			
			IF CalibrationPara.CalibrationModePara.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q1;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q2 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q2;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q3 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q3;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q4 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q4;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q5 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q5;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q6 THEN //don't permit axis 6 calibration until all the others are calibrated!
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q6;
		
			END_IF
			
		STATE_CALIBRATE_Q1:
			RoboArmPara.Jog.Velocity[0] := JogVelocityActual;
			IF CalibrationPara.CalibrationModePara.ActivateMove THEN
				RoboArm.Jog := TRUE;
			ELSE
				RoboArm.Jog := FALSE;
			END_IF
			if 
			
		STATE_CALIBRATE_Q2:
			RoboArmPara.Jog.Velocity[1] := JogVelocityActual;
			
		STATE_CALIBRATE_Q3:
			RoboArmPara.Jog.Velocity[2] := JogVelocityActual;
			
		STATE_CALIBRATE_Q4:
			RoboArmPara.Jog.Velocity[3] := JogVelocityActual;
			
		STATE_CALIBRATE_Q5:
			RoboArmPara.Jog.Velocity[4] := JogVelocityActual;
			
		STATE_CALIBRATE_Q6:
			RoboArmPara.Jog.Velocity[5] := JogVelocityActual;	
			
	END_CASE
	
END_FUNCTION_BLOCK
