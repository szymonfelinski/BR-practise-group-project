
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3AutomaticMode
	
	IF AutoMode.Parameters.Abort THEN
		//aborts execution
		AutoMode.Info.CurrentState := autoSTATE_ABORT;
	ELSIF AutoMode.Parameters.Pause AND NOT AutoMode.Info.Paused THEN
		//pauses execution
		AutoMode.Info.CurrentState := autoSTATE_PAUSE;
	END_IF
	
	CASE AutoMode.Info.CurrentState OF				
		autoSTATE_WAIT:
			IF NOT AutoMode.Info.Paused THEN
				
				AutoMode.Info.Error := autoNO_ERROR; //reset error status in case it didn't reset. also useful for first-time execution
				AutoMode.Info.ErrorID := 0;
				
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
			ELSIF AutoMode.Parameters.Continue THEN
				AutoMode.Info.CurrentState := autoSTATE_CONTINUE;
			END_IF
						
		autoSTATE_LOAD: //this state loads a program specified in "ProgramName"
			
			AutoMode.Cmds.LoadProgram(AxesGroup := ADR(AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName, Mode := mcLOADPRG_PROGRAM);
			
			IF AutoMode.Cmds.LoadProgram.Done THEN
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				AutoMode.Parameters.Load := FALSE;
			ELSIF AutoMode.Cmds.LoadProgram.Error THEN
				AutoMode.Info.ErrorID := AutoMode.Cmds.LoadProgram.ErrorID;
				AutoMode.Info.Error := autoLOAD_PROGRAM_ERROR;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			END_IF
			
			
		autoSTATE_UNLOAD: //this state unloads a program specified in "ProgramName" OR all programs (UnloadAll = true) from memory
			
			IF AutoMode.Parameters.UnloadAll THEN
				UnloadMode := mcUNLOADPRG_ALL;
			ELSE
				UnloadMode := mcUNLOADPRG_PROGRAM;
			END_IF
						
			AutoMode.Cmds.UnloadProgram(AxesGroup := ADR(AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName, Mode := UnloadMode);
			
			IF AutoMode.Cmds.UnloadProgram.Done THEN
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				AutoMode.Parameters.Unload := FALSE;
			ELSIF AutoMode.Cmds.UnloadProgram.Error THEN
				AutoMode.Info.ErrorID := AutoMode.Cmds.UnloadProgram.ErrorID;
				AutoMode.Info.Error := autoUNLOAD_PROGRAM_ERROR;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			END_IF
			
			
		autoSTATE_EXECUTE: //this state executes a program specified in "ProgramName", if program isn't loaded it will automagically load it
				
			AutoMode.Cmds.ExecuteProgram(AxesGroup := ADR(AxesGroup), Execute := TRUE, Name := AutoMode.Parameters.ProgramName);
			
			IF AutoMode.Cmds.ExecuteProgram.Done AND NOT AutoMode.Parameters.Execute THEN //if "Execute" was reset during program execution, disable Continuous. (user pressed the button again)
				AutoMode.Parameters.Continuous := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				
			ELSIF AutoMode.Cmds.ExecuteProgram.Done AND AutoMode.Parameters.Execute THEN //if Execute is set after program execution, simply go to the Done state and handle Continuous there.
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_DONE;
				
			ELSIF AutoMode.Cmds.ExecuteProgram.Error THEN //save error ID and go to error state
				AutoMode.Info.ErrorID := AutoMode.Cmds.ExecuteProgram.ErrorID;
				AutoMode.Info.Error := autoEXECUTE_PROGRAM_ERROR;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
				
			END_IF
			(*RoboArmPara.ProgramName := AutoMode.Parameters.ProgramName;
			RoboArm.Update := TRUE;
			RoboArm.MoveProgram := TRUE;
			IF RoboArm.MoveDone THEN
				RoboArm.MoveProgram := FALSE;
			END_IF*)
						
		autoSTATE_DONE: //this state is a goto for execute when it's done
			
			IF NOT AutoMode.Parameters.Continuous THEN //if Continuous isn't set, return to idle
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
			ELSE //do it as long as Continuous is set or until Abort isn't set
				AutoMode.Parameters.Execute := TRUE;
				AutoMode.Info.CurrentState := autoSTATE_EXECUTE;
			END_IF
				//AutoMode.Info.CurrentState := autoSTATE_WAIT;
			AutoMode.Cmds.UnloadProgram(Execute := FALSE); //just a precaution
			AutoMode.Cmds.LoadProgram(Execute := FALSE);
			AutoMode.Cmds.ExecuteProgram(Execute := FALSE);
			
		autoSTATE_PAUSE: //this state pauses active program execution
			IF AutoMode.Cmds.PauseProgram.Done THEN
				AutoMode.Cmds.PauseProgram.Execute := FALSE;
				AutoMode.Cmds.PauseProgram();
				AutoMode.Parameters.Pause := FALSE;
				AutoMode.Info.Paused := TRUE;
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
			ELSIF AutoMode.Cmds.PauseProgram.Error THEN
				AutoMode.Info.Error := autoPAUSE_ERROR;
				AutoMode.Info.ErrorID := AutoMode.Cmds.PauseProgram.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			ELSE
							
				AutoMode.Cmds.PauseProgram(AxesGroup := ADR(AxesGroup), Execute := TRUE);
			END_IF
			
		autoSTATE_CONTINUE: //this state continues paused program
			IF AutoMode.Cmds.ContinueProgram.Done THEN
				AutoMode.Cmds.ContinueProgram.Execute := FALSE;
				AutoMode.Cmds.ContinueProgram();
				AutoMode.Parameters.Continue := FALSE;
				AutoMode.Info.Paused := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
			ELSIF AutoMode.Cmds.ContinueProgram.Error THEN
				AutoMode.Info.Error := autoCONTINUE_ERROR;
				AutoMode.Info.ErrorID := AutoMode.Cmds.ContinueProgram.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			ELSE
				AutoMode.Cmds.ContinueProgram(AxesGroup := ADR(AxesGroup), Execute := TRUE);
			END_IF
			
		autoSTATE_ABORT: //a noncritical stop
			IF AutoMode.Cmds.GroupStop.Done THEN //it's stopped
				AutoMode.Cmds.GroupStop.Execute := FALSE;
				AutoMode.Cmds.GroupStop();
				AutoMode.Parameters.Execute := FALSE;
				AutoMode.Parameters.Unload := FALSE;
				AutoMode.Parameters.Load := FALSE;
				AutoMode.Parameters.Abort := FALSE;
				AutoMode.Parameters.Continuous := FALSE;
				AutoMode.Info.Paused := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
					
			ELSIF AutoMode.Cmds.GroupStop.Error THEN
				AutoMode.Info.Error := autoABORT_ERROR;
				AutoMode.Info.ErrorID := AutoMode.Cmds.GroupStop.ErrorID;
				AutoMode.Info.CurrentState := autoSTATE_ERROR;
			ELSE
							
				AutoMode.Cmds.GroupStop(AxesGroup := ADR(AxesGroup), Execute := TRUE, StopMode := mcSTOPMODE_JERK_LIMIT); //take into account jerk limit as it's a noncritical stop
			END_IF
			
			//D edit
			AutoMode.Parameters.Abort:=FALSE;
						
		autoSTATE_ERROR: //error state, ErrorReset is reset automatically. reset state control variables
			AutoMode.Parameters.Execute := FALSE;
			AutoMode.Parameters.Unload := FALSE;
			AutoMode.Parameters.Load := FALSE;
			AutoMode.Parameters.Continuous := FALSE;
			
			IF AutoMode.Parameters.ErrorReset THEN
				AutoMode.Info.Error := autoNO_ERROR;
				AutoMode.Info.ErrorID := 0;
			END_IF
			
			IF AutoMode.Info.Error = autoNO_ERROR THEN
				AutoMode.Parameters.ErrorReset := FALSE;
				AutoMode.Info.CurrentState := autoSTATE_WAIT;
			END_IF
		
	END_CASE
	
	
END_FUNCTION_BLOCK
