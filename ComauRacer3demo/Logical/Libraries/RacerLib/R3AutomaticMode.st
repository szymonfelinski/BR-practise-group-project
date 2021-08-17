
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3AutomaticMode
	
	IF AutoMode.Parameters.Abort THEN
		//implement something
	END_IF
	
	CASE AutoMode.Info.CurrentState OF				
		autoSTATE_WAIT:
			AutoMode.Info.Error := NO_ERROR; //reset error status in case it didn't reset. also useful for first-time execution
			
			IF AutoMode.Parameters.Load THEN //if "Load" is set, reset others (only one button can be pressed at a time, with priority to whichever was first)
				
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Parameters.Unload := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_LOAD;
				
			ELSIF AutoMode.Parameters.Execute THEN
				
				AutoMode.Parameters.Load := FALSE;
				AutoMode.Parameters.Unload := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_EXECUTE;
				
			ELSIF AutoMode.Parameters.Unload THEN
				
				AutoMode.Parameters.Load := FALSE;
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_UNLOAD;
				
			END_IF
			
			
		autoSTATE_LOAD: //this state loads a program specified in "ProgramName"
			
			AutoMode.Cmds.LoadProgram(AxesGroup := ADR(AutoMode.Info.AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName, Mode := mcLOADPRG_PROGRAM);
			
			IF AutoMode.Cmds.LoadProgram.Done THEN
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				AutoMode.Parameters.Load := FALSE;
			ELSIF AutoMode.Cmds.LoadProgram.Error THEN
				AutoMode.Info.ErrorID := AutoMode.Cmds.LoadProgram.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			END_IF
			
			
		autoSTATE_UNLOAD: //this state unloads a program specified in "ProgramName" OR all programs (UnloadAll = true) from memory
			
			IF AutoMode.Parameters.UnloadAll THEN
				UnloadMode := mcUNLOADPRG_ALL;
			ELSE
				UnloadMode := mcUNLOADPRG_PROGRAM;
			END_IF
						
			AutoMode.Cmds.UnloadProgram(AxesGroup := ADR(AutoMode.Info.AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName, Mode := UnloadMode);
			
			IF AutoMode.Cmds.UnloadProgram.Done THEN
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				AutoMode.Parameters.Unload := FALSE;
			ELSIF AutoMode.Cmds.UnloadProgram.Error THEN
				AutoMode.Info.ErrorID := AutoMode.Cmds.UnloadProgram.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			END_IF
			
			
		autoSTATE_EXECUTE: //this state executes a program specified in "ProgramName", if program isn't loaded it will automagically load it
			
		//	IF AutoMode.Parameters.Continuous AND RoboArm.MoveDone THEN
		//		RoboArm.MoveProgram := FALSE;
		//		RoboArm.MoveProgram := TRUE;
		//	END_IF
						
			AutoMode.Cmds.ExecuteProgram(AxesGroup := ADR(AutoMode.Info.AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName);
			
		(*	IF AutoMode.Cmds.ExecuteProgram.Done THEN
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_DONE;
			ELSIF AutoMode.Cmds.ExecuteProgram.Error THEN
				AutoMode.Info.ErrorID := AutoMode.Cmds.ExecuteProgram.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			END_IF
			RoboArmPara.ProgramName := AutoMode.Parameters.ProgramName;
			RoboArm.Update := TRUE;
			RoboArm.MoveProgram := TRUE;
			IF RoboArm.MoveDone THEN
				RoboArm.MoveProgram := FALSE;
			END_IF*)
						
		autoSTATE_DONE: //this state is a goto for load/unload/execute when they're done
			
			AutoMode.Info.CurrentState := autoSTATE_WAIT;
			
		autoSTATE_ERROR:
			IF AutoMode.Parameters.ErrorReset THEN
				AutoMode.Info.Error := NO_ERROR;
				AutoMode.Info.ErrorID := 0;
			END_IF
			
			IF AutoMode.Info.Error = NO_ERROR THEN
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
			END_IF
			
	END_CASE
	
	
END_FUNCTION_BLOCK
