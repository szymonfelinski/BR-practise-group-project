
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3CalibrationMode
	
	FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
		RoboArmPara.Jog.Velocity[j] := 0.0;
	END_FOR;
	
	IF CalibrationPara.CalibrationModePara.Direction = POSITIVE THEN // set actual axis velocity based on which direction it's set to be moved
		JogVelocityActual := CalibrationModePara.JogVelocity;
	ELSIF CalibrationPara.CalibrationModePara.Direction = NEGATIVE THEN
		JogVelocityActual := -1 * CalibrationModePara.JogVelocity;
	END_IF
	
	RoboArmPara.Jog.CoordSystem := CalibrationPara.CalibrationModePara.CoordinateSystem;
	RoboArmPara.Jog.PathLimits := CalibrationPara.CalibrationModePara.PathLimits;
	
	CASE CalibrationPara.CalibrationState OF
		STATE_START:
			
		STATE_CALIBRATE_Q1:
			RoboArmPara.Jog.Velocity[0] := JogVelocityActual;
			
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
