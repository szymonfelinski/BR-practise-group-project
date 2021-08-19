
PROGRAM _INIT

	RoboArm6Axis.Enable := TRUE;

	RoboArm6Axis.Override  := 100.0;
	RoboArm6AxisPara.ProgramName := 'Point.st';    //File stored on FileDevice, default program (Point.st moves TCP to -200, 300, 800)
	RoboArm6Axis.MpLink     := ADR(gAxesGroupRacer3);
	RoboArm6Axis.Parameters := ADR(RoboArm6AxisPara);
	RoboArm6AxisPara.Acceleration := 1000.0;
	RoboArm6AxisPara.Deceleration := 1000.0;
	RoboArm6AxisPara.Velocity := 69.0;
	
	ManualControlPara.PathLimits.Acceleration := 100.0;
	ManualControlPara.PathLimits.Deceleration := 100.0;
	ManualControlPara.PathLimits.Velocity := 100.0;
	ManualControlPara.PathLimits.Jerk := 0.0;
	ManualControlPara.Direction := -1;
	
	State := STATE_INIT;
	Communication.Power := FALSE;
	
	//FileMgmt(MpLink := ADR(FileManagement), Enable := TRUE, Configuration := ADR(FileMgmtConfig));
	
	gRacer3HomeRestorePos; //call home restore position variable to init it in memory
	//MpAlarmXCore_Control(MpLink := ADR(gAlarmXCore), Enable := TRUE);
	
	AutomaticCurrentLanguage; //variable used for changing script language
	
END_PROGRAM

PROGRAM _CYCLIC
	
	IF RoboArm6Axis.Error THEN
		State := STATE_ERROR;
	END_IF
	
	IF NOT Communication.Power THEN
		RoboArm6Axis.Power := FALSE;
		State:= STATE_INIT;
	END_IF
	
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
	
	UpdateCheck;
	
	CASE State OF
		STATE_ERROR:
			Communication.txt_State_out:="Error";

			IF NOT RoboArm6Axis.Error THEN
				RoboArm6Axis.ErrorReset := FALSE;
				State := STATE_INIT;
			END_IF
			
			IF Communication.ErrorReset THEN
				RoboArm6Axis.ErrorReset := TRUE;
				Communication.ErrorReset := FALSE;
			END_IF
			
		STATE_INIT:
			Communication.txt_State_out:="Initialization";
			
			RoboArm6Axis.Enable := TRUE;
			
			IF Communication.Power THEN
				State := STATE_POWER_ON;
			END_IF		
		STATE_POWER_ON:
			
			Communication.txt_State_out:="Power";
			IF NOT RoboArm6Axis.PowerOn AND RoboArm6Axis.Info.ReadyToPowerOn THEN
				RoboArm6Axis.Power := TRUE;
			END_IF
			
			IF RoboArm6Axis.PowerOn THEN
				State := STATE_HOMING;
				
			END_IF
			
		STATE_HOMING:
			Communication.txt_State_out:="Homing";
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
			
			Communication.txt_State_out:="Ready";
			
			//changeStatePending so change mode is impossible while in-move (before state comes to ready) for example for auto and semiauto
			
			IF ControlSelector = ManualJog AND Communication.changeModePending <> 1 THEN
				// exit from MANUAL
				// when exiting ManualMode from mappView bind ManualModePara.ExitMode := TRUE and pending state, both at once
				// because we want to wait till semiAuto and Auto finishes and then goes to READY state, but for manual we have to go out manually
				ManualControlPara.ExitManual:=TRUE;
			END_IF
			
			IF ControlSelector = ManualJog THEN
				MpAuditWStringChange(MpLink:= gAuditTrailLink, Old := Communication.txt_State_out ,New:="ManualControl", Identifier := 'ControlMode');
				
				State := STATE_MANUAL_CONTROL;
			ELSIF ControlSelector = SemiAutomatic THEN
				MpAuditWStringChange(MpLink:= gAuditTrailLink, Old :=Communication.txt_State_out,New:="SemiAutoControl", Identifier := 'ControlMode');
				State := STATE_SEMI_AUTOMATIC;
			ELSIF ControlSelector = Automatic THEN
				MpAuditWStringChange(MpLink:= gAuditTrailLink, Old :=Communication.txt_State_out,New:="AutoControl", Identifier := 'ControlMode');
				State := STATE_AUTOMATIC;
			END_IF
						
			ControlSelector:=Communication.changeModePending;
			// TODO think what happens when ControlSelector changes in-between init,update,start,go in auto and semiauto and fix it
			// maybe do something similar to exit mode in manual
		
		STATE_MANUAL_CONTROL:
			
			//ChangeMode
			IF ControlSelector = ManualJog AND Communication.changeModePending <> 1 THEN
				// exit from MANUAL
				ManualControlPara.ExitManual:=TRUE;
				ControlSelector:=Communication.changeModePending;
				State:=STATE_READY;
			END_IF
			IF Communication.Stop THEN
				ManualControlPara.ExitManual:=TRUE;
				Communication.Stop:=FALSE;
			END_IF
		
			Communication.txt_State_out:="ManualControl";
			//ManualControlPara.PathLimits.Acceleration;
			//ManualControlPara.PathLimits.Deceleration;
			//ManualControlPara.PathLimits.Jerk;
			//ManualControlPara.PathLimits.Velocity;
			//ManualControlPara; //main struct to be bound in mapp view
			ManualControl(ManualModePara := ManualControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara,MainState := State, ControlSelector := ControlSelector);
		
		STATE_SEMI_AUTOMATIC:
			
			//ChangeMode
			IF ControlSelector = SemiAutomatic AND Communication.changeModePending <> 2 THEN
				// exit from SemiAuto
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				ControlSelector:=Communication.changeModePending;
				State:=STATE_READY;
			END_IF
			IF Communication.Stop THEN
				SemiAutoControlPara.ExitSemiAuto:=TRUE;
				Communication.Stop:=FALSE;
			END_IF
			
			Communication.txt_State_out:="SemiAutoControl";
			SemiAutoControl(SemiAutoModePara := SemiAutoControlPara, RoboArm := RoboArm6Axis, RoboArmPara := RoboArm6AxisPara, MainState := State, ControlSelector := ControlSelector);
		
		STATE_AUTOMATIC:
			Communication.txt_State_out:="AutoControl";
			
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
			
			IF AutomaticCurrentLanguage THEN
					
				(*IF Pause AND NOT Stop THEN
					AutomaticModePara.Parameters.Pause:=TRUE;
				END_IF
				IF NOT Pause AND AutomaticModePara.Parameters.Pause AND NOT Stop THEN
					AutomaticModePara.Parameters.Continue:=TRUE;
				END_IF
				IF Stop THEN
					AutomaticModePara.Parameters.Abort:=TRUE;
					Stop:=FALSE;
				END_IF*) // this is probably not needed.
				
				AutomaticModePara.Parameters;
				AutomaticModePara.Parameters.ProgramName;
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
			
		STATE_UPDATE:
			
			IF RoboArm6Axis.UpdateDone THEN
				RoboArm6Axis.Update := FALSE;
				State := LastState;
			END_IF
						
			RoboArm6Axis.Update := TRUE;
		
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

