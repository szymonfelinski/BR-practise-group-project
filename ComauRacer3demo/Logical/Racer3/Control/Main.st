
PROGRAM _INIT

	RoboArm6Axis.Enable := TRUE;

	RoboArm6Axis.Override  := 100.0;
	RoboArm6AxisPara.ProgramName := 'Robotic.st';    //File stored on FileDevice
	RoboArm6Axis.MpLink     := ADR(gAxesGroupRacer3);
	RoboArm6Axis.Parameters := ADR(RoboArm6AxisPara);
	RoboArm6AxisPara.Acceleration := 1000.0;
	RoboArm6AxisPara.Deceleration := 1000.0;
	RoboArm6AxisPara.Velocity := 100.0;
	
	ManualControlPara.PathLimits.Acceleration := 100.0;
	ManualControlPara.PathLimits.Deceleration := 100.0;
	ManualControlPara.PathLimits.Velocity := 10.0;
	ManualControlPara.PathLimits.Jerk := 0.0;
	ManualControlPara.Direction := -1;
	
	State := STATE_INIT;
	Power := FALSE;
	
	gRacer3HomeRestorePos; //call home restore position variable to init it in memory
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
	
	UpdateCheck;
	
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
				State := STATE_HOMING;
				
			END_IF
			
		STATE_HOMING:
			txt_State_out:="Homing";
			IF gIsCalibrated THEN
				IF RoboArm6Axis.IsHomed THEN //autohoming after power on
					RoboArm6Axis.Home := FALSE;
					State := STATE_READY;
				ELSE
				
					RoboArm6Axis.Home := TRUE;
					//Calibration.Cmds.GroupHome(AxesGroup := ADR(gAxesGroupRacer3), Execute := TRUE, HomingMode := Calibration.Para.HomingModeEnum);
					(*IF Calibration.Cmds.GroupHome.Done THEN
						State := STATE_READY;
					END_IF*)
					
				END_IF
			ELSE
				State := STATE_CALIBRATION; //if the system wasn't calibrated before, make it be calibrated
				Calibration.Info.CurrentState := STATE_BEGIN;
				
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
			
			//ChangeMode
			IF ControlSelector = ManualJog AND changeModePending <> 1 THEN
				// exit from MANUAL
				ManualControlPara.ExitManual:=TRUE;
				ControlSelector:=changeModePending;
				State:=STATE_READY;
			END_IF
			IF Stop THEN
				ManualControlPara.ExitManual:=TRUE;
				Stop:=FALSE;
			END_IF
		
			txt_State_out:="ManualControl";
			ManualControlPara.PathLimits.Acceleration;
			ManualControlPara.PathLimits.Deceleration;
			ManualControlPara.PathLimits.Jerk;
			ManualControlPara.PathLimits.Velocity;
			ManualControlPara; //main struct to be bound in mapp view
			ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara,MainState := State, ControlSelector := ControlSelector);
		
		STATE_SEMI_AUTOMATIC:
			
			//ChangeMode
			IF ControlSelector = SemiAutomatic AND changeModePending <> 2 THEN
				// exit from SemiAuto
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				ControlSelector:=changeModePending;
				State:=STATE_READY;
			END_IF
			IF Stop THEN
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				Stop:=FALSE;
			END_IF
			
			txt_State_out:="SemiAutoControl";
			//SemiAutoControlPara.Flag :=TRUE;
			SemiAutoControl(SemiAutoModePara := SemiAutoControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara, MainState := State, ControlSelector := ControlSelector);
		
		STATE_AUTOMATIC:
			txt_State_out:="AutoControl";
		
		STATE_CALIBRATION:
			
			//perform initial homing to trick ACOPOS into thinking axes are homed, basically set home to current position.
			CASE Calibration.Info.CurrentState OF
				STATE_BEGIN:
					IF RoboArm6Axis.IsHomed THEN
						Calibration.Info.CurrentState := STATE_MOVING; //if a home is set, go directly to manual calibration (perhaps calibration on demand?)
					ELSE
						Calibration.Info.CurrentState := STATE_FAKE_HOME; //otherwise set a fake home
					END_IF
					
				STATE_FAKE_HOME:
					
					FOR i := 0 TO 5 BY 1 DO
						Calibration.Para.Positions[i] := RoboArm6Axis.Info.JointAxisPosition[i];
					END_FOR
												
					Calibration.Cmds.GroupHome(AxesGroup := ADR(gAxesGroupRacer3), Execute := TRUE, Position := Calibration.Para.Positions, HomingMode := Calibration.Para.FakeHomingModeEnum);
					IF Calibration.Cmds.GroupHome.Done THEN
						Calibration.Info.CurrentState := STATE_MOVING;
					END_IF
								
				STATE_MOVING:
					
					Calibration.Para.Parameters.CalibrationModePara.PathLimits.Acceleration := 100.0; //set low acceleration, deceleration and velocity limits for calibration purposes
					Calibration.Para.Parameters.CalibrationModePara.PathLimits.Deceleration := 100.0;
					//CalibrationModePara.CalibrationModePara.PathLimits.Jerk := 1000.0; //no need to limit jerk
					Calibration.Para.Parameters.CalibrationModePara.PathLimits.Velocity := 100.0;
					Calibration.Para.Parameters.Axis5To6Para.Axis5Angle := 118.0; //angle defined in calibration pdf (see page 100 of _lb-rc-RACER3-STM_en)
					Calibration.Para.Parameters.Axis5To6Para.Axis5Velocity := 50.0; //use low velocity for moving axis 5 for calibrating axis 6
					Calibration.Para.Parameters.CalibrationModePara.CoordinateSystem := 0; //set axis coordinate system for calibration
					//CalibrationModePara.CalibrationState := STATE_START; //reset calibration state everytime after jog
					
					Calibration.Cmds.Mode(CalibrationPara := Calibration.Para.Parameters, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara); //call FB with set values
					
					IF Calibration.Para.Parameters.Axis5To6Para.Axis5Restored AND Calibration.Para.Parameters.AxisCalibrated[5] THEN
						Calibration.Info.CurrentState := STATE_SAVING_POSITION;
						i := 1;
					END_IF

				STATE_SAVING_POSITION:
					
					//common values used for homing, will be saved under gRacer3HomeRestorePos[0..5]
					Calibration.Para.HomingParameters.HomingMode := mcHOMING_RESTORE_POSITION;
					Calibration.Para.HomingParameters.RestorePositionVariableAddress; //SET FOR EVERY AXIS SEPARATELY!
					
					//save positions to PV
					IF i = 1 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[0]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ1), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							i := 2;
						END_IF
						
					ELSIF i = 2 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[1]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ2), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							i := 3;
						END_IF
						
					ELSIF i = 3 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[2]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ3), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							i := 4;
						END_IF
						
					ELSIF i = 4 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[3]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ4), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							i := 5;
						END_IF
						
					ELSIF i = 5 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[4]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ5), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							i := 6;
						END_IF
						
					ELSIF i = 6 THEN
						Calibration.Para.HomingParameters.RestorePositionVariableAddress := ADR(gRacer3HomeRestorePos[5]);
						Calibration.Cmds.InitHome(Axis := ADR(gAxisQ6), Execute := TRUE, HomingParameters := Calibration.Para.HomingParameters);
						IF Calibration.Cmds.InitHome.Done THEN
							Calibration.Info.CurrentState := STATE_DONE;
						END_IF
						
					END_IF
				
				STATE_DONE:
					gIsCalibrated := TRUE;
					State:=STATE_HOMING;

			END_CASE
				
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

