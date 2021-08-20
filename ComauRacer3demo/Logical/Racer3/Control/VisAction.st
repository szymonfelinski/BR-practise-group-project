
ACTION VisAction: 
	Communication.NOTCoordinateSystem	:= NOT Communication.CoordinateSystem;
	Communication.NOTPathSystem	:= NOT Communication.PathSystem;
	Communication.NOTModeSystem := NOT Communication.ModeSystem;
	
	IF Calibration.Para.Parameters.AxisCalibrated[4] AND Calibration.Para.Parameters.AxisCalibrated[0] AND Calibration.Para.Parameters.AxisCalibrated[1] AND Calibration.Para.Parameters.AxisCalibrated[2] AND Calibration.Para.Parameters.AxisCalibrated[3] AND Calibration.Para.Parameters.AxisCalibrated[4] THEN
		Axis_1to5_calibrated :=TRUE;
	ELSE
		Axis_1to5_calibrated :=FALSE;
	END_IF
	
END_ACTION
