
PROGRAM _INIT

	RoboArm6Axis.Enable := TRUE;

	RoboArm6Axis.Override  := 100.0;
	RoboArm6AxisPara.ProgramName := 'Robotic.st';    //File stored on FileDevice
	RoboArm6Axis.MpLink     := ADR(gAxesGroupRacer3);
	RoboArm6Axis.Parameters := ADR(RoboArm6AxisPara);
	RoboArm6AxisPara.Acceleration := 1000.0;
	RoboArm6AxisPara.Deceleration := 1000.0;
	RoboArm6AxisPara.Velocity := 100.0;
	//RoboArm6AxisPara.Distance[0] := 50.0;
	(*ManualMode.PathLimits.Acceleration := 100.0;
	ManualMode.CoordinateSystem := 9;
	ManualMode.PathLimits.Deceleration := 100.0;
	ManualMode.PathLimits.Velocity := 10.0;
	ManualMode.PathLimits.Jerk := 0.0;
	ManualMode.Direction := POSITIVE;*)
	
	//ManualControl();
	//R3ManualMode(
	
	State := STATE_INIT;
	Power := FALSE;
	
	gRacer3HomeRestorePos; //call home restore position variable to init it in memory
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF RoboArm6Axis.Error THEN
		State := STATE_ERROR;
	END_IF
	
	CASE State OF
		STATE_ERROR:
			IF NOT RoboArm6Axis.Error THEN
				State := STATE_INIT;
			END_IF
			
		STATE_INIT:
		
			RoboArm6Axis.Enable := TRUE;
			
			IF Power THEN
				State := STATE_POWER_ON;
			END_IF
			
		STATE_POWER_ON:
			
			IF NOT RoboArm6Axis.PowerOn AND RoboArm6Axis.Info.ReadyToPowerOn THEN
				RoboArm6Axis.Power := TRUE;
			END_IF
			
			IF RoboArm6Axis.PowerOn THEN
				IF RoboArm6Axis.IsHomed THEN
					State := STATE_READY;
				ELSE
					State := STATE_HOMING;
				END_IF
				
			END_IF
			
		STATE_HOMING:
			IF gIsCalibrated THEN
				IF RoboArm6Axis.IsHomed THEN
					RoboArm6Axis.Home := FALSE;
					State := STATE_READY;
				ELSE
					RoboArm6Axis.Home := TRUE;
				END_IF
			ELSE
				State := STATE_CALIBRATION;
			END_IF
			
		STATE_READY:
			
			IF ControlSelector = ManualJog THEN
				State := STATE_MANUAL_CONTROL;
			END_IF
			
		
		STATE_MANUAL_CONTROL:
			ManualControlPara.PathLimits.Acceleration;
			ManualControlPara.PathLimits.Deceleration;
			ManualControlPara.PathLimits.Jerk;
			ManualControlPara.PathLimits.Velocity;
			ManualControlPara; //main struct to be bound in mapp view
			ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara);
		
		STATE_SEMI_AUTOMATIC:
		
		STATE_AUTOMATIC:
		
		STATE_CALIBRATION:
			
			CalibrationModePara.CalibrationModePara.PathLimits.Acceleration := 100.0; //set low acceleration, deceleration and velocity limits for calibration purposes
			CalibrationModePara.CalibrationModePara.PathLimits.Deceleration := 100.0;
			//CalibrationModePara.CalibrationModePara.PathLimits.Jerk := 1000.0; //no need to limit jerk
			CalibrationModePara.CalibrationModePara.PathLimits.Velocity := 100.0;
			CalibrationModePara.Axis5To6Para.Axis5Angle := 118.0; //angle defined in calibration pdf (see page 100 of _lb-rc-RACER3-STM_en)
			CalibrationModePara.Axis5To6Para.Axis5Velocity := 50.0; //use low velocity for moving axis 5 for calibrating axis 6
			CalibrationModePara.CalibrationModePara.CoordinateSystem := 0; //set axis coordinate system for calibration
			//CalibrationModePara.CalibrationState := STATE_START; //reset calibration state everytime after jog
			CalibrationMode(CalibrationPara := CalibrationModePara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara); //call FB with set values
			
			IF CalibrationModePara.Axis5To6Para.Axis5Restored AND CalibrationModePara.AxisCalibrated[5] THEN
				//save positions to PV
				IF i = 1 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ1), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						i = 2;
					END_IF
				ELSIF i = 2 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ2), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						i = 3;
					END_IF
				ELSIF i = 3 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ3), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						i = 4;
					END_IF
				ELSIF i = 4 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ4), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						i = 5;
					END_IF
				ELSIF i = 5 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ5), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						i = 6;
					END_IF
				ELSIF i = 6 THEN
					MC_BR_InitHome(Axis := ADR(gAxisQ6), Execute := TRUE, HomingParameters := mcHOMING_RESTORE_POSITION);
					IF MC_BR_InitHome.Done THEN
						gIsCalibrated := TRUE;
						State := STATE_INIT;
					END_IF
			END_IF
		
		
	END_CASE
	
	
	IF RoboArm6Axis.UpdateDone THEN
		RoboArm6Axis.Update := FALSE;
	END_IF
	
	IF NOT RoboArm6Axis.Error THEN
		RoboArm6Axis.ErrorReset := FALSE;
	END_IF
	
	
	
	RoboArm6Axis();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	RoboArm6Axis.Power := FALSE;
	RoboArm6Axis.Enable := FALSE;
END_PROGRAM

