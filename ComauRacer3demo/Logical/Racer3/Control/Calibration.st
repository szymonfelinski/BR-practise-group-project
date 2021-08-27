
ACTION CalibrationAction:
	IF Communication.ResetHome THEN //this enables the user to reset each axis to 0.0 in software - allows for movement when a (false) workspace violation is set off during calibration.
		Calibration.Info.CurrentState := STATE_FAKE_HOME;
	END_IF
	
	IF Calibration.Cmds.GroupHome.Done OR NOT Calibration.Cmds.GroupHome.Busy THEN
		Calibration.Cmds.GroupHome.Execute := FALSE;
		Calibration.Cmds.GroupHome();
	END_IF
	
	CASE Calibration.Info.CurrentState OF
		STATE_BEGIN:
			IF gIsCalibrated THEN
				Calibration.Info.CurrentState := STATE_DONE;
			ELSE
				
			Calibration.Para.Parameters.CalibrationModePara.JogVelocity := 5.0; //default velocity
			IF RoboArm6Axis.IsHomed AND NOT Communication.ResetHome THEN
				Calibration.Info.CurrentState := STATE_MOVING; //if a home is set, go directly to manual calibration (perhaps calibration on demand?)
			ELSE
				Calibration.Info.CurrentState := STATE_FAKE_HOME; //otherwise set a fake home
				END_IF
			END_IF
			
			
		STATE_FAKE_HOME:
			
			FOR i := 0 TO 5 BY 1 DO
				IF i = 2 THEN
					Calibration.Para.Positions[i] := -90.0; //axis 3 default position is -90.0 degrees
				ELSE
					Calibration.Para.Positions[i] := 0.0;
				END_IF
				
			END_FOR
										
			Calibration.Cmds.GroupHome(AxesGroup := ADR(gAxesGroupRacer3), Execute := TRUE, Position := Calibration.Para.Positions, HomingMode := Calibration.Para.FakeHomingModeEnum); //this makes the robot think its axes are 0.0
			IF Calibration.Cmds.GroupHome.Done THEN
				Calibration.Cmds.GroupHome.Execute := FALSE;
				Calibration.Cmds.GroupHome();
				IF Communication.ResetHome THEN //if manual homing reset
					Calibration.Info.CurrentState := STATE_BEGIN;
					Communication.ResetHome := FALSE;
				ELSE
					Calibration.Info.CurrentState := STATE_MOVING;
				END_IF
				
			END_IF
						
		STATE_MOVING:
			
			Calibration.Para.Parameters.CalibrationModePara.PathLimits.Acceleration := 1000.0; //set low acceleration, deceleration and velocity limits for calibration purposes
			Calibration.Para.Parameters.CalibrationModePara.PathLimits.Deceleration := 1000.0;
			//CalibrationModePara.CalibrationModePara.PathLimits.Jerk := 1000.0; //no need to limit jerk
			Calibration.Para.Parameters.CalibrationModePara.PathLimits.Velocity := 100.0;
			//Calibration.Para.Parameters.Axis5to6Para.Axis5Angle := -118.0; //angle defined in calibration pdf (see page 100 of _lb-rc-RACER3-STM_en)
			Calibration.Para.Parameters.Axis5To6Para.AxisMoveVelocity := Calibration.Para.Parameters.CalibrationModePara.JogVelocity; //use low velocity for moving axis 5 for calibrating axis 6
			Calibration.Para.Parameters.CalibrationModePara.CoordinateSystem := 0; //set axis coordinate system for calibration
			//CalibrationModePara.CalibrationState := STATE_START; //reset calibration state everytime after jog
			
			//Block below send axis references to FB (for inithome)
			Calibration.Para.Parameters.AxesRef[0] := ADR(gAxisQ1);
			Calibration.Para.Parameters.AxesRef[1] := ADR(gAxisQ2);
			Calibration.Para.Parameters.AxesRef[2] := ADR(gAxisQ3);
			Calibration.Para.Parameters.AxesRef[3] := ADR(gAxisQ4);
			Calibration.Para.Parameters.AxesRef[4] := ADR(gAxisQ5);
			Calibration.Para.Parameters.AxesRef[5] := ADR(gAxisQ6);
			
			Calibration.Cmds.Mode(CalibrationPara := Calibration.Para.Parameters, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara); //call FB with set values
						
			IF Calibration.Para.Parameters.Axis5To6Para.Axis35Restored AND Calibration.Para.Parameters.AxisCalibrated[5] THEN
				Calibration.Info.CurrentState := STATE_SAVING_POSITION;
				Calibration.Para.Parameters.Axis5To6Para.Axis35Restored := FALSE;
				i := 1;
			END_IF

		STATE_SAVING_POSITION:
			
			gRacer3ZeroPosition := Calibration.Para.Parameters.SavedPositions; //saving calibrated joint values to PV, might be used for zeroing robot position.
			
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
					gIsCalibrated := TRUE;
					Calibration.Info.CurrentState := STATE_DONE;
				END_IF
				
			END_IF
		
		STATE_DONE:
			//gRacer3BasePosition := RoboArm6Axis.Info.JointAxisPosition; //replaced by assignment at the beginning of STATE_SAVING_POSITIONS
			
			
			State:=STATE_HOMING;

	END_CASE
END_ACTION
