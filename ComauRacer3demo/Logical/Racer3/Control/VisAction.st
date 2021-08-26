
ACTION VisAction: 
	Communication.NOTCoordinateSystemSemiAuto := NOT Communication.CoordinateSystemSemiAuto;
	Communication.NOTPathSystem	:= NOT Communication.PathSystem;
	Communication.NOTModeSystem := NOT Communication.ModeSystem;
	
	IF Calibration.Para.Parameters.AxisCalibrated[0] AND Calibration.Para.Parameters.AxisCalibrated[1] AND Calibration.Para.Parameters.AxisCalibrated[2] AND Calibration.Para.Parameters.AxisCalibrated[3] THEN
		Axis_1to4_calibrated := TRUE;
	ELSE
		Axis_1to4_calibrated := FALSE;
	END_IF
	
	IF Axis_1to4_calibrated AND Calibration.Para.Parameters.AxisCalibrated[4] THEN
		Axis5Calibrated := TRUE;
	ELSE
		Axis5Calibrated := FALSE;
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
		ELSIF KeyCheck.temp_value <> KeyCheck.pending_combo[KeyCheck.i] THEN
			KeyCheck.i:=0;
		END_IF
	END_IF
	
	IF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q1 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis1.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.1';
	ELSIF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q2 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis2.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.2';
	ELSIF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q3 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis3.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.3';
	ELSIF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q4 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis4.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.4';
	ELSIF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q5 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis5.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.5';
	ELSIF Calibration.Para.Parameters.CalibrationModePara.AxisButton.Q6 THEN
		Communication.CalibrationImage := 'Media/calibration/calib_axis6.PNG';
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.6';
	ELSE
		Communication.CalibrationImage := '';
		Communication.TextManager.CalibHelper := '';
	END_IF
	
	IF Calibration.Para.Parameters.AxisCalibrated[0] AND Calibration.Para.Parameters.AxisCalibrated[1] AND Calibration.Para.Parameters.AxisCalibrated[2] AND Calibration.Para.Parameters.AxisCalibrated[3] AND Calibration.Para.Parameters.AxisCalibrated[4] AND Calibration.Para.Parameters.AxisCalibrated[5] AND NOT gIsCalibrated THEN
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.7';
		Communication.RestoreAxis5 := TRUE;
	ELSIF gIsCalibrated THEN
		Communication.TextManager.CalibHelper := '$$IAT/ControlPage/Calibration.Helper.8';
		Communication.RestoreAxis5 := FALSE;
	ELSE 
		Communication.RestoreAxis5 := FALSE;
	END_IF
	
	IF Communication.CalibrateAgain THEN
		
		gIsCalibrated:=FALSE;
		Calibration.Para.Parameters.AxisCalibrated[0] := FALSE;
		Calibration.Para.Parameters.AxisCalibrated[1] := FALSE;
		Calibration.Para.Parameters.AxisCalibrated[2] := FALSE;
		Calibration.Para.Parameters.AxisCalibrated[3] := FALSE;
		Calibration.Para.Parameters.AxisCalibrated[4] := FALSE;
		Calibration.Para.Parameters.AxisCalibrated[5] := FALSE;
		Communication.CalibrateAgain := FALSE;
	END_IF
	
	
END_ACTION
