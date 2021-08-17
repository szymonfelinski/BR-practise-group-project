
PROGRAM _INIT

	RoboArm6Axis.Enable := TRUE;

	RoboArm6Axis.Override  := 100.0;
	RoboArm6AxisPara.ProgramName := 'Robotic.st';    //File stored on FileDevice
	RoboArm6Axis.MpLink     := ADR(gAxesGroupRacer3);
	RoboArm6Axis.Parameters := ADR(RoboArm6AxisPara);
	RoboArm6AxisPara.Acceleration := 1000.0;
	RoboArm6AxisPara.Deceleration := 1000.0;
	RoboArm6AxisPara.Velocity := 100.0;
	
	ManualControlPara.CoordinateSystem := 0;
	//SemiAutoControlPara.CoordinateSystem := 0;
	//SemiAutoControlPara.UpdatePending := TRUE;
	CoordinateSystem := FALSE;
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
	
	//MpAlarmXCore_Control(MpLink := ADR(gAlarmXCore), Enable := TRUE);
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF RoboArm6Axis.Error THEN
		State := STATE_ERROR;
	END_IF
	
	IF NOT Power THEN
		RoboArm6Axis.Power := FALSE;
		State:= STATE_INIT;
	END_IF
	
	IF Stop THEN
		//stops and goes to standby
		RoboArm6Axis.MoveLinear := FALSE;
		RoboArm6Axis.MoveDirect := FALSE;
		RoboArm6Axis.Jog := FALSE;
		SemiAutoControlPara.Flag := FALSE;
		ManualControlPara.ActivateMove:=FALSE;
		//TODO turn off traces from all moves for sure, not only flags (clean them up)
		State:= STATE_READY;
	END_IF
	
	IF CoordinateSystem THEN //Coordinate system in ManualControl and SemiAutoControl: 9-global  0-axis
		ManualControlPara.CoordinateSystem := 9;
		//SemiAutoControlPara.CoordinateSystem := 9;
		//SemiAutoControlPara.UpdatePending := TRUE;
	ELSE
		ManualControlPara.CoordinateSystem := 0;
		//SemiAutoControlPara.CoordinateSystem := 0;
		//SemiAutoControlPara.UpdatePending := TRUE;
	END_IF
	
	IF PathSystem THEN
		SemiAutoControlPara.PathMode := PathSystem;
		SemiAutoControlPara.UpdatePending :=TRUE;
		// TODO Auto too
	END_IF
	
	CASE State OF
		STATE_ERROR:
			txt_State_out:="Error";
			IF NOT RoboArm6Axis.Error THEN
				State := STATE_INIT;
			END_IF
			
		STATE_INIT:
			txt_State_out:="Initialization";
			RoboArm6Axis.Enable := TRUE;
			
			IF Power THEN
				State := STATE_POWER_ON;
			END_IF		
		STATE_POWER_ON:
			txt_State_out:="Power";
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
			txt_State_out:="Homing";
			IF RoboArm6Axis.IsHomed THEN
				RoboArm6Axis.Home := FALSE;
				State := STATE_READY;
			ELSE
				RoboArm6Axis.Home := TRUE;
			END_IF
			
			
		STATE_READY:
			txt_State_out:="Ready";

			
			//changeStatePending so change mode is impossible while in-move (before state comes to ready) for example for auto and semiauto
			
			IF ControlSelector = ManualJog AND changeModePending <> 1 THEN
				// exit from MANUAL
				// when exiting ManualMode from mappView bind ManualModePara.ExitMode := TRUE and pending state, both at once
				// because we want to wait till semiAuto and Auto finishes and then goes to READY state, but for manual we have to go out manually
				ManualControlPara.ExitManual:=TRUE;
			END_IF
			
			IF ControlSelector = ManualJog THEN
				State := STATE_MANUAL_CONTROL;
			END_IF
			IF ControlSelector = SemiAutomatic THEN
				State := STATE_SEMI_AUTOMATIC;
			END_IF
			
			ControlSelector:=changeModePending;
			// TODO think what happend when ControlSelector changes in-between init,update,start,go in auto and semiauto and fix it
			// maybe do something similar to exit mode in manual
		
		STATE_MANUAL_CONTROL:
			txt_State_out:="ManualControl";
			ManualControlPara.PathLimits.Acceleration;
			ManualControlPara.PathLimits.Deceleration;
			ManualControlPara.PathLimits.Jerk;
			ManualControlPara.PathLimits.Velocity;
			ManualControlPara; //main struct to be bound in mapp view
			ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara,MainState := State, ControlSelector := ControlSelector);
			//TODO wyjscie z Manual
		
		STATE_SEMI_AUTOMATIC:
			txt_State_out:="SemiAutoControl";
			//SemiAutoControlPara.Flag :=TRUE;
			SemiAutoControl(SemiAutoModePara := SemiAutoControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara, MainState := State, ControlSelector := ControlSelector);
			//testowo alarm
			//MpAlarmXSet(gAlarmXCore, 'OutOfLimits');
		
		STATE_AUTOMATIC:
			txt_State_out:="AutoControl";
		
		STATE_CALIBRATION:
			txt_State_out:="Calibration";
		
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

