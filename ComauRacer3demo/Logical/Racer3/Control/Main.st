
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
			IF RoboArm6Axis.IsHomed THEN
				RoboArm6Axis.Home := FALSE;
				State := STATE_READY;
			ELSE
				RoboArm6Axis.Home := TRUE;
			END_IF
			
			
		STATE_READY:
			
			IF ControlSelector = ManualJog THEN
				State := STATE_MANUAL_CONTROL;
			END_IF
			IF ControlSelector = SemiAutomatic THEN
				State := STATE_SEMI_AUTOMATIC;
			END_IF
			
		
		STATE_MANUAL_CONTROL:
			ManualControlPara.PathLimits.Acceleration;
			ManualControlPara.PathLimits.Deceleration;
			ManualControlPara.PathLimits.Jerk;
			ManualControlPara.PathLimits.Velocity;
			ManualControlPara; //main struct to be bound in mapp view
			ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara);
		
		STATE_SEMI_AUTOMATIC:
		
			SemiAutoControl(SemiAutoModePara := SemiAutoControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara, MainState := State, ControlSelector := ControlSelector);
		
		STATE_AUTOMATIC:
		
		STATE_CALIBRATION:
		
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

