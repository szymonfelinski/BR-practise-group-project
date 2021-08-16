
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3CalibrationMode
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
			
		STATE_CALIBRATE_Q3:
			
		STATE_CALIBRATE_Q4:
			
		STATE_CALIBRATE_Q5:
			
		STATE_CALIBRATE_Q6:
			
	END_CASE
	
END_FUNCTION_BLOCK
