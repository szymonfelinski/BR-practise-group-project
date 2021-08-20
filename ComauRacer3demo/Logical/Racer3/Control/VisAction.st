
ACTION VisAction: 
	Communication.NOTCoordinateSystem	:= NOT Communication.CoordinateSystem;
	Communication.NOTPathSystem	:= NOT Communication.PathSystem;
	Communication.NOTModeSystem := NOT Communication.ModeSystem;
	
	IF Calibration.Para.Parameters.AxisCalibrated[4] AND Calibration.Para.Parameters.AxisCalibrated[0] AND Calibration.Para.Parameters.AxisCalibrated[1] AND Calibration.Para.Parameters.AxisCalibrated[2] AND Calibration.Para.Parameters.AxisCalibrated[3] AND Calibration.Para.Parameters.AxisCalibrated[4] THEN
		Axis_1to5_calibrated :=TRUE;
	ELSE
		Axis_1to5_calibrated :=FALSE;
	END_IF
	IF KeyCheck.value_changed AND KeyCheck.event_achieved THEN
		KeyCheck.value_changed := FALSE;
		KeyCheck.event_achieved := FALSE;
	ELSIF KeyCheck.value_changed THEN
		IF KeyCheck.temp_value = KeyCheck.original_combo[KeyCheck.i] THEN
			KeyCheck.pending_combo[KeyCheck.i] := KeyCheck.temp_value;
			KeyCheck.i := KeyCheck.i + 1;
			KeyCheck.value_changed := FALSE;
			IF KeyCheck.i = 6 THEN
				//meets its end
				//make event happen
				KeyCheck.event_achieved := TRUE;
			END_IF
		ELSE
			KeyCheck.i:=0;
		END_IF
	END_IF
	
END_ACTION
