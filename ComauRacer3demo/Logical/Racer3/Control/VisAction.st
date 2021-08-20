
ACTION VisAction: 
	Communication.NOTCoordinateSystem	:= NOT Communication.CoordinateSystem;
	Communication.NOTPathSystem	:= NOT Communication.PathSystem;
	Communication.NOTModeSystem := NOT Communication.ModeSystem;
	
	IF Calibration.Para.Parameters.AxisCalibrated[4] AND Calibration.Para.Parameters.AxisCalibrated[0] AND Calibration.Para.Parameters.AxisCalibrated[1] AND Calibration.Para.Parameters.AxisCalibrated[2] AND Calibration.Para.Parameters.AxisCalibrated[3] AND Calibration.Para.Parameters.AxisCalibrated[4] THEN
		Axis_1to5_calibrated :=TRUE;
	ELSE
		Axis_1to5_calibrated :=FALSE;
	END_IF
	
	
	// Easter Egg Time
	IF Egg.value_changed THEN
		IF Egg.temp_value = Egg.original_combo[Egg.i] THEN
			Egg.pending_combo[Egg.i] := Egg.temp_value;
			Egg.i := Egg.i + 1;
			Egg.value_changed := FALSE;
			IF Egg.i = 6 THEN
				//meets its end
				//make event happen
				Egg.event_achieved := TRUE;
			END_IF
		ELSE
			Egg.i:=0;
		END_IF
	END_IF
	
END_ACTION
