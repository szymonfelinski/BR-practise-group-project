
PROGRAM _INIT
	
	RoboArm6Axis.Enable := TRUE;

	RoboArm6Axis.Override := 100.0; //it's non-100 only for automatic mode
	RoboArm6AxisPara.ProgramName := 'Point.st';    //File stored on FileDevice, default program (Point.st moves TCP to -200, 300, 800)
	RoboArm6Axis.MpLink := ADR(gAxesGroupRacer3);
	RoboArm6Axis.Parameters := ADR(RoboArm6AxisPara);
	RoboArm6AxisPara.Acceleration := 1000.0;
	RoboArm6AxisPara.Deceleration := 1000.0;
	RoboArm6AxisPara.Velocity := 69.0;
	
	Communication.ReturnToZero := FALSE;
	ManualControlPara.PathLimits.Acceleration := 1000.0;
	ManualControlPara.PathLimits.Deceleration := 1000.0;
	ManualControlPara.PathLimits.Velocity := 150.0;
	ManualControlPara.PathLimits.Jerk := 0.0;
	ManualControlPara.Direction := -1;
	
	State := STATE_INIT;
	Communication.Power := FALSE;
	i;
	Brakes;
	
	//FileMgmt(MpLink := ADR(FileManagement), Enable := TRUE, Configuration := ADR(FileMgmtConfig));
	
	gRacer3HomeRestorePos; //call home restore position variable to init it in memory
	//MpAlarmXCore_Control(MpLink := ADR(gAlarmXCore), Enable := TRUE);
	
	AutomaticCurrentLanguage; //variable used for changing script language
	
	RoboArm6Axis();
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF RoboArm6Axis.Error THEN
		State := STATE_ERROR;
	END_IF
	(*
	IF Communication.Stop THEN
		//stops and goes to standby
		RoboArm6Axis.MoveLinear := FALSE;
		RoboArm6Axis.MoveDirect := FALSE;
		RoboArm6Axis.Jog := FALSE;
		SemiAutoControlPara.Flag := FALSE;
		ManualControlPara.ActivateMove:=FALSE;
		//TODO turn off traces from all moves for sure, not only flags (clean them up)
		State:= STATE_READY;
	END_IF
	*)
	
	IF Communication.WarmRestart THEN
		Communication.WarmRestart := FALSE;
		SYSreset(1,1);
	END_IF
	UpdateCheck;
	
	IF NOT Communication.Power AND NOT (State = STATE_BRAKES) THEN //power commands have no effect in STATE_BRAKES
		//RoboArm6Axis.Power := FALSE;
		GroupPower(AxesGroup := ADR(gAxesGroupRacer3), Enable := FALSE);
		State := STATE_INIT;
	END_IF
	
	
	CASE State OF
		STATE_ERROR:
			Communication.txt_State_out:="Error";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Error';
			
			GroupPower(AxesGroup := ADR(gAxesGroupRacer3), Enable := FALSE); //this powers off the axes
			ManualControlPara.ExitManual:=FALSE;
			IF GroupReset.Done THEN
				GroupReset.Execute := FALSE;
				GroupReset();
				Communication.ErrorReset := FALSE;
			ELSIF NOT RoboArm6Axis.Error THEN //if there's no error, go to INIT
				RoboArm6Axis.ErrorReset := FALSE;
				State := STATE_INIT;
			ELSIF Communication.ErrorReset THEN
				GroupReset(AxesGroup := ADR(gAxesGroupRacer3), Execute := TRUE);
				RoboArm6Axis.ErrorReset:=TRUE;
			END_IF
			
		STATE_INIT:
			Communication.txt_State_out:="Initialization";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Init';
			ManualControlPara.ExitManual := FALSE;
			IF NOT Communication.BrakesSet THEN
				SetBrakes.Axis1 := ADR(gAxisQ1);
				SetBrakes.Axis2 := ADR(gAxisQ2);
				SetBrakes.Axis3 := ADR(gAxisQ3);
				SetBrakes.Axis4 := ADR(gAxisQ4);
				SetBrakes.Axis5 := ADR(gAxisQ5);
				SetBrakes.Axis6 := ADR(gAxisQ6);
				SetBrakes();
				IF SetBrakes.Done THEN
					Communication.BrakesSet := TRUE;
				END_IF
				//RoboArm6Axis.Enable := TRUE;
				
			ELSE //if brake parameters have been set
				// brake operation functions (only when robot is powered off!)
				IF Communication.BrakeClose THEN
					i := 1;
					Brakes.Info.State := brakeCLOSE;
					State := STATE_BRAKES;
		
				ELSIF Communication.BrakeOpen THEN
					i := 1;
					Brakes.Info.State := brakeOPEN;
					State := STATE_BRAKES;
		
				ELSIF Communication.BrakeReadStatus THEN
					i := 1;
					Brakes.Info.State := brakeREAD;
					State := STATE_BRAKES;
		
				ELSIF Communication.Power AND NOT (State = STATE_BRAKES) THEN //power commands have no effect in STATE_BRAKES
					State := STATE_POWER_ON;
				END_IF
			END_IF
			
		STATE_POWER_ON:
			Communication.txt_State_out:="Power";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Power';
			
			IF NOT RoboArm6Axis.PowerOn AND RoboArm6Axis.Info.ReadyToPowerOn THEN
				GroupPower(AxesGroup := ADR(gAxesGroupRacer3), Enable := TRUE);
				//RoboArm6Axis.Power := TRUE;
			END_IF
			
			IF GroupPower.Status AND GroupPower.Enable THEN //Status tells whether the group is really powered on, Enable must be true.
				State := STATE_HOMING;
			END_IF
						
			(*IF RoboArm6Axis.PowerOn THEN //unused
				State := STATE_HOMING;
				
			END_IF*)
			
		STATE_HOMING:
			Communication.txt_State_out:="Homing";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Homing';
			
			IF gIsCalibrated THEN
				CalibrationStateBtn := FALSE;
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
				CalibrationStateBtn := TRUE;
				State := STATE_CALIBRATION; //if the system wasn't calibrated before, make it be calibrated
				Calibration.Info.CurrentState := STATE_BEGIN;
				
			END_IF
			
		STATE_READY:
			//changeStatePending so change mode is impossible while in-move (before state comes to ready) for example for auto and semiauto
			(*
			IF ControlSelector = ManualJog AND Communication.changeModePending <> 1 THEN
				// exit from MANUAL
				// when exiting ManualMode from mappView bind ManualModePara.ExitMode := TRUE and pending state, both at once
				// because we want to wait till semiAuto and Auto finishes and then goes to READY state, but for manual we have to go out manually
				ManualControlPara.ExitManual := TRUE;
			END_IF
			*)
			(* TODO: Better handling of fake home, do it per axis after each save - IMPORTANT*)
			IF NOT Communication.ResetHome THEN 
				
				IF ControlSelector = ManualJog THEN
					MpAuditWStringChange(MpLink:= gAuditTrailLink, Old := Communication.txt_State_out ,New:="ManualControl", Identifier := 'ControlMode');
					
					State := STATE_MANUAL_CONTROL;
				ELSIF ControlSelector = SemiAutomatic THEN
					MpAuditWStringChange(MpLink:= gAuditTrailLink, Old :=Communication.txt_State_out,New:="SemiAutoControl", Identifier := 'ControlMode');
					State := STATE_SEMI_AUTOMATIC;
				ELSIF ControlSelector = Automatic THEN
					MpAuditWStringChange(MpLink:= gAuditTrailLink, Old :=Communication.txt_State_out,New:="AutoControl", Identifier := 'ControlMode');
					State := STATE_AUTOMATIC;
				ELSE 
					Communication.txt_State_out:="Ready";
					Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Ready';
				END_IF
			ELSE
				State := STATE_CALIBRATION;
			END_IF
			
			ControlSelector := Communication.changeModePending;
			// TODO think what happens when ControlSelector changes in-between init,update,start,go in auto and semiauto and fix it
			// maybe do something similar to exit mode in manual
		
		STATE_MANUAL_CONTROL:
			//Communication.LastControlState := 'Manual';
			//ChangeMode
			ManualControlPara.ExitManual:=FALSE;
			IF ControlSelector = ManualJog AND Communication.changeModePending <> 1 THEN
				// exit from MANUAL
				ManualControlPara.ExitManual :=TRUE;
				ControlSelector := Communication.changeModePending;
				State := STATE_READY;
				//Communication.Stop:=FALSE;
			END_IF
			IF Communication.Stop THEN
				ManualControlPara.ExitManual := TRUE;
				Communication.Stop := FALSE;
			END_IF
		
			Communication.txt_State_out := "ManualControl";
			Communication.txt_State_out_front := '$$IAT/ControlPage/txt_State_out_front.Manual';
			RoboArm6Axis.Override := 100.0; //required for Jog
			//ManualControlPara.PathLimits.Acceleration;
			//ManualControlPara.PathLimits.Deceleration;
			//ManualControlPara.PathLimits.Jerk;
			ManualControlPara.PathLimits.Velocity := 1000.0;
			//ManualControlPara; //main struct to be bound in mapp view
			IF Communication.ReturnToZero AND ManualControlPara.JogVelocity >= 1.0 THEN //return to Zero function, only works when velocity is greater than 1.0 (otherwise move could not be executed)
				RoboArm6AxisPara.Position := gRacer3ZeroPosition; //read from PV set during calibration
				RoboArm6AxisPara.CoordSystem := 0;
				RoboArm6AxisPara.ManualMoveType := mcMOVE_ABSOLUTE;
				RoboArm6AxisPara.Velocity := ManualControlPara.JogVelocity;
				RoboArm6Axis.MoveDirect := TRUE;
				IF RoboArm6Axis.MoveDone THEN
					RoboArm6Axis.MoveDirect := FALSE;
					Communication.ReturnToZero := FALSE;
				END_IF
				
			ELSE
				Communication.ReturnToZero := FALSE;
				RoboArm6Axis.MoveDirect := FALSE;
				ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara,MainState := State, ControlSelector := ControlSelector);
			END_IF
			
		STATE_SEMI_AUTOMATIC:
			//Communication.LastControlState := 'SemiAuto';
			
			//ChangeMode
			IF ControlSelector = SemiAutomatic AND Communication.changeModePending <> 2 THEN
				// exit from SemiAuto
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				ControlSelector:=Communication.changeModePending;
				State:=STATE_READY;
				//Communication.Stop:=FALSE;
			END_IF
			IF Communication.Stop THEN
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				Communication.Stop:=FALSE;
			END_IF
			
			Communication.txt_State_out:="SemiAutoControl";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.SemiAuto';
			RoboArm6Axis.Override := 100.0;
			SemiAutoControl(SemiAutoModePara := SemiAutoControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara, MainState := State, ControlSelector := ControlSelector);
		
		STATE_AUTOMATIC:
			//Communication.LastControlState := 'Automatic';
			Communication.txt_State_out:="AutoControl";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Auto';
			
			IF ControlSelector = Automatic AND Communication.changeModePending <> 3 THEN
				// exit from Auto
				AutomaticModePara.Parameters.Abort:=TRUE;
				ControlSelector:=Communication.changeModePending;
				State:=STATE_READY;
			END_IF
			(*IF Communication.Pause AND NOT Communication.Stop THEN
				AutomaticModePara.Parameters.Pause:=TRUE;
			END_IF
			IF NOT Communication.Pause AND AutomaticModePara.Parameters.Pause AND NOT Communication.Stop THEN
				AutomaticModePara.Parameters.Continue:=TRUE;
			END_IF
			IF Communication.Stop THEN
				AutomaticModePara.Parameters.Abort:=TRUE;
				Communication.Stop:=FALSE;
			END_IF

			AutomaticModePara.Parameters;
			AutomaticModePara.Parameters.ProgramName;
			//AutomaticModePara.Parameters.Execute := TRUE;
			//AutomaticModePara.Info.CurrentState := autoSTATE_WAIT;
			AutomaticMode(AutoMode := AutomaticModePara, AxesGroup := ADR(gAxesGroupRacer3));*)
			PathName;
			FileName;
			IF AutomaticCurrentLanguage THEN
				
				AutomaticModePara.Parameters;
				AutomaticModePara.Parameters.ProgramName := FileName;
				//AutomaticModePara.Parameters.Execute := TRUE;
				//AutomaticModePara.Info.CurrentState := autoSTATE_WAIT;
				AutomaticMode(AutoMode := AutomaticModePara, AxesGroup := ADR(gAxesGroupRacer3));
				
				//AutomaticModePara.Cmds.ExecuteProgram(AxesGroup := ADR(gAxesGroupRacer3), Execute := TRUE, Name := AutomaticModePara.Parameters.ProgramName);
			ELSE
				//everything here happens in the widget
			END_IF
							
		STATE_CALIBRATION:
			
			//perform initial homing to trick ACOPOS into thinking axes are homed, basically set home to current position.
			CalibrationAction;
				
			Communication.txt_State_out:="Calibration";
			Communication.txt_State_out_front:= '$$IAT/ControlPage/txt_State_out_front.Calibration';
		
		STATE_BRAKES:
			//Brakes.Cmds.BrakeOperation.SelectMode := 0;
			IF Brakes.Cmds.BrakeOperation.Error THEN
				Brakes.Info.State := brakeERROR;
			ELSE
				Brakes.Info.Error := FALSE;
			END_IF
						
			CASE Brakes.Info.State OF
				brakeERROR:
					Communication.BrakeClose := FALSE;
					Communication.BrakeOpen := FALSE;
					Communication.BrakeReadStatus := FALSE;
					Brakes.Cmds.BrakeOperation.Execute := FALSE;
					Brakes.Info.Error := TRUE;
					Brakes.Cmds.BrakeOperation();
					State := STATE_INIT;
				brakeDONE:
					Brakes.Cmds.BrakeOperation.Execute := FALSE;
					
					Brakes.Cmds.BrakeOperation();
					State := STATE_INIT;
					
				brakeOPEN:
					Communication.BrakeOpen := FALSE;
					Brakes.Cmds.BrakeOperation.AxesGroup := ADR(gAxesGroupRacer3);
					Brakes.Parameters.BrakeCmd := mcBRAKE_OPEN;
					IF Brakes.Cmds.BrakeOperation.Done AND (i = 1) THEN
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 2;
					ELSIF Brakes.Cmds.BrakeOperation.Done AND (i = 2) THEN
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 3;
						Communication.BrakeReadStatus := TRUE;
						Brakes.Info.State := brakeDONE;
					ELSIF (i < 3) THEN
						Brakes.Cmds.BrakeOperation.Command := Brakes.Parameters.BrakeCmd;
						Brakes.Cmds.BrakeOperation.Identifier := i;
						Brakes.Cmds.BrakeOperation.Execute := TRUE;
						
						Brakes.Cmds.BrakeOperation();
					END_IF
				
				brakeCLOSE:
					Communication.BrakeClose := FALSE;
					Brakes.Cmds.BrakeOperation.AxesGroup := ADR(gAxesGroupRacer3);
					Brakes.Parameters.BrakeCmd := mcBRAKE_CLOSE;
					IF Brakes.Cmds.BrakeOperation.Done AND (i = 1) THEN
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 2;
					ELSIF Brakes.Cmds.BrakeOperation.Done AND (i = 2) THEN
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 3;
						Communication.BrakeReadStatus := TRUE;
						Brakes.Info.State := brakeDONE;
					ELSIF (i < 3) THEN
						Brakes.Cmds.BrakeOperation.Command := Brakes.Parameters.BrakeCmd;
						Brakes.Cmds.BrakeOperation.Identifier := i;
						Brakes.Cmds.BrakeOperation.Execute := TRUE;
						
						Brakes.Cmds.BrakeOperation();
					END_IF
				
				brakeREAD:
					Communication.BrakeReadStatus := FALSE;
					Brakes.Parameters.BrakeCmd := mcBRAKE_GET_STATUS;
					Brakes.Cmds.BrakeOperation.AxesGroup := ADR(gAxesGroupRacer3);
					IF Brakes.Cmds.BrakeOperation.Done AND (i = 1) THEN
						Brakes.Info.BrakeStatus[i] := Brakes.Cmds.BrakeOperation.BrakeStatus;
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 2;
					ELSIF Brakes.Cmds.BrakeOperation.Done AND (i = 2) THEN
						Brakes.Info.BrakeStatus[i] := Brakes.Cmds.BrakeOperation.BrakeStatus;
						Brakes.Cmds.BrakeOperation.Execute := FALSE;
						Brakes.Cmds.BrakeOperation();
						i := 3;
						Brakes.Info.State := brakeDONE;
					ELSIF (i < 3) THEN
						Brakes.Cmds.BrakeOperation.Command := Brakes.Parameters.BrakeCmd;
						Brakes.Cmds.BrakeOperation.Identifier := i;
						Brakes.Cmds.BrakeOperation.Execute := TRUE;
						
						Brakes.Cmds.BrakeOperation();
					END_IF
				
				END_CASE
		
	END_CASE
	
	RoboArm6Axis();
	
	
	////////////Visualization Variables/////////////
	VisAction;
		
		
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	RoboArm6Axis.Power := FALSE;
	RoboArm6Axis.Enable := FALSE;
	
	RoboArm6Axis(); //this will free up MpLink (possibly)
END_PROGRAM

