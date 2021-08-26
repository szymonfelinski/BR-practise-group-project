
(* TODO: Add your comment here
ActivateMove and AxisSaveBtn are assumed momentary. 
not resetting AxisSaveBtn and switching AxisButton will result in immediate AxisCalibrated[i] := TRUE!
not resetting ActivateMove might result in damage to physical system! *)
FUNCTION_BLOCK R3CalibrationMode
	CalibrationPara.InitHomePara.Position := 0.0; //this is non-zero only for Axis 3
	CalibrationPara.InitHomePara.HomingMode := mcHOMING_DIRECT; //this saves current position as value 'Position'
	IF CalibrationPara.InitHome.Done THEN
		CalibrationPara.InitHome(Execute := FALSE);
	END_IF
		
	IF CalibrationPara.CalibrationModePara.Direction = 1 THEN // set actual axis velocity based on which direction it's set to be moved
		
		JogVelocityActual := CalibrationPara.CalibrationModePara.JogVelocity;
		
	ELSIF CalibrationPara.CalibrationModePara.Direction = -1 THEN
		
		JogVelocityActual := -1 * CalibrationPara.CalibrationModePara.JogVelocity;
		
	END_IF
	
	CASE CalibrationPara.CalibrationState OF
		STATE_START:
			
			IF RoboArm.MoveDirect THEN
				RoboArm.MoveDirect := FALSE;
			END_IF
						
			RoboArmPara.Jog.CoordSystem := CalibrationPara.CalibrationModePara.CoordinateSystem;
			RoboArmPara.Jog.PathLimits := CalibrationPara.CalibrationModePara.PathLimits;
			
			IF NOT CalibrationPara.CalibrationModePara.ActivateMove THEN //disable jog if "Move" flag isn't set
				RoboArm.Jog := FALSE;
				FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
					RoboArmPara.Jog.Velocity[j] := 0.0;
				END_FOR;
			END_IF
			
			IF CalibrationPara.AxisSaveBtn THEN //if AxisSaveBtn flag is set, reset it
				CalibrationPara.AxisSaveBtn := FALSE;
			END_IF
			
			IF CalibrationPara.CalibrationModePara.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q1;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q2 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q2;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q3 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q3;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q4 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q4;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q5 THEN
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q5;
			
			ELSIF CalibrationPara.CalibrationModePara.AxisButton.Q6 THEN //don't permit axis 6 calibration until all the others are calibrated!
				CalibrationPara.CalibrationState := STATE_CALIBRATE_Q6;
			END_IF
			
			IF CalibrationPara.Axis5To6Para.Axis5Return AND CalibrationPara.AxisCalibrated[5] AND NOT CalibrationPara.Axis5To6Para.Axis35Restored AND CalibrationPara.Axis5To6Para.Axis5Moved AND CalibrationPara.Axis5To6Para.Axis3Moved THEN 
				//only allow this if axis 6 has been calibrated (Show button in HMI)
				CalibrationPara.CalibrationState := STATE_RESTORE_Q3_Q5;
			END_IF			
			
		STATE_CALIBRATE_Q1:
			RoboArmPara.Jog.Velocity[0] := JogVelocityActual; //write jog velocity to robot
			
			IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set
				RoboArm.Jog := TRUE;
			ELSE
				RoboArm.Jog := FALSE;
			END_IF
			
			IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
				CalibrationPara.AxisCalibrated[0] := TRUE;
				CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[0]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
				CalibrationPara.SavedPositions[0] := CalibrationPara.InitHomePara.Position;
				RoboArm.Jog := FALSE;
				CalibrationPara.AxisSaveBtn := FALSE;
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q1 THEN //go back if button is released
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
			
			
		STATE_CALIBRATE_Q2:
			RoboArmPara.Jog.Velocity[1] := JogVelocityActual;
			
			IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set
				RoboArm.Jog := TRUE;
			ELSE
				RoboArm.Jog := FALSE;
			END_IF
			
			IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
				CalibrationPara.AxisCalibrated[1] := TRUE;
				CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[1]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
				CalibrationPara.SavedPositions[1] := CalibrationPara.InitHomePara.Position;
				RoboArm.Jog := FALSE;
				CalibrationPara.AxisSaveBtn := FALSE;
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q2 THEN
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
			
		STATE_CALIBRATE_Q3:
			RoboArmPara.Jog.Velocity[2] := JogVelocityActual;
			
			IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set
				RoboArm.Jog := TRUE;
			ELSE
				RoboArm.Jog := FALSE;
			END_IF
			
			IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
				CalibrationPara.AxisCalibrated[2] := TRUE;
				CalibrationPara.InitHomePara.Position := -90.0;
				CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[2]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
				CalibrationPara.SavedPositions[2] := CalibrationPara.InitHomePara.Position;
				RoboArm.Jog := FALSE;
				CalibrationPara.AxisSaveBtn := FALSE;
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q3 THEN
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
			
		STATE_CALIBRATE_Q4:
			RoboArmPara.Jog.Velocity[3] := JogVelocityActual;
			
			IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set
				RoboArm.Jog := TRUE;
			ELSE
				RoboArm.Jog := FALSE;
			END_IF
			
			IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
				CalibrationPara.AxisCalibrated[3] := TRUE;
				CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[3]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
				CalibrationPara.SavedPositions[3] := CalibrationPara.InitHomePara.Position;
				RoboArm.Jog := FALSE;
				CalibrationPara.AxisSaveBtn := FALSE;
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q4 THEN
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
			
		STATE_CALIBRATE_Q5:
			IF CalibrationPara.AxisCalibrated[0] AND CalibrationPara.AxisCalibrated[1] AND CalibrationPara.AxisCalibrated[2] AND CalibrationPara.AxisCalibrated[3] THEN //if axes 1-4 have been calibrated
				(*one-time execution of relative movement of axis 3 by -45 degrees*)
				IF NOT CalibrationPara.Axis5To6Para.Axis3Moved AND NOT RoboArm.MoveActive AND NOT RoboArm.MoveDirect THEN
					
					FOR j := 0 TO 5 BY 1 DO //set every distance to 0
						RoboArmPara.Distance[j] := 0.0;
					END_FOR;
					
					RoboArmPara.Distance[2] := CalibrationPara.Axis5To6Para.Axis3Angle; //axis 3 may be moved this amount in order to make calibrating axis 5 and 6 easier (default -45)
					RoboArmPara.Velocity := CalibrationPara.Axis5To6Para.AxisMoveVelocity; // use a low velocity for this (just to be safe)
					RoboArmPara.ManualMoveType := mcMOVE_RELATIVE; //select relative movement (to restore position after calibrating axis 6)
					RoboArmPara.CoordSystem := 0; // select ACS for moving
					RoboArm.MoveDirect := TRUE; //execute movement
					
				ELSIF RoboArm.MoveDone AND RoboArm.MoveDirect THEN //if move has been executed
					
					RoboArm.MoveDirect := FALSE; //reset move flag
					CalibrationPara.Axis5To6Para.Axis3Moved := TRUE; //set flag to let the program know axis 5 has been moved to correct position
					
				ELSIF CalibrationPara.Axis5To6Para.Axis3Moved THEN //actual calibration
					
					RoboArmPara.Jog.Velocity[4] := JogVelocityActual;
			
					IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set
						RoboArm.Jog := TRUE;
					ELSE
						RoboArm.Jog := FALSE;
					END_IF
			
					IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
						CalibrationPara.AxisCalibrated[4] := TRUE;
						CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[4]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
						CalibrationPara.SavedPositions[4] := CalibrationPara.InitHomePara.Position;
						RoboArm.Jog := FALSE;
						CalibrationPara.AxisSaveBtn := FALSE;
					END_IF
					
				END_IF
				
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q5 THEN
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
			
		STATE_CALIBRATE_Q6:
			(* if all previous axes have been calibrated and set in place *)
			IF CalibrationPara.AxisCalibrated[0] AND CalibrationPara.AxisCalibrated[1] AND CalibrationPara.AxisCalibrated[2] AND CalibrationPara.AxisCalibrated[3] AND CalibrationPara.AxisCalibrated[4] THEN
				(*one-time execution of relative movement of axis 5 by -118 degrees*)
				IF NOT CalibrationPara.Axis5To6Para.Axis5Moved AND NOT RoboArm.MoveActive AND NOT RoboArm.MoveDirect THEN
					
					FOR j := 0 TO 5 BY 1 DO //set every distance to 0
						RoboArmPara.Distance[j] := 0.0;
					END_FOR;
					
					RoboArmPara.Distance[4] := CalibrationPara.Axis5To6Para.Axis5Angle; //axis 5 has to be moved this amount in order to calibrate axis 6 (see page 100 of _lb-rc-RACER3-STM_en) (default -118.0)
					//axis 3 is assumed to have been moved in order to make calibrating axis 6 easier (default -45)
					RoboArmPara.Velocity := CalibrationPara.Axis5To6Para.AxisMoveVelocity; // use a low velocity for this (just to be safe)
					RoboArmPara.ManualMoveType := mcMOVE_RELATIVE; //select relative movement (to restore position after calibrating axis 6)
					RoboArmPara.CoordSystem := 0; // select ACS for moving
					RoboArm.MoveDirect := TRUE; //execute movement
					
				ELSIF RoboArm.MoveDone AND RoboArm.MoveDirect THEN //if move has been executed
					
					RoboArm.MoveDirect := FALSE; //reset move flag
					CalibrationPara.Axis5To6Para.Axis5Moved := TRUE; //set flag to let the program know axis 5 has been moved to correct position
					
				ELSIF CalibrationPara.Axis5To6Para.Axis5Moved THEN //actual calibration
					
					RoboArmPara.Jog.Velocity[5] := JogVelocityActual;
				
					IF CalibrationPara.CalibrationModePara.ActivateMove THEN //enable jog only if ActivateMove flag is set (momentary switch in HMI)
						RoboArm.Jog := TRUE;
					ELSE
						RoboArm.Jog := FALSE;
					END_IF
				
					IF CalibrationPara.AxisSaveBtn THEN //set Calibrated flag for given axis if AxisSaveBtn flag is set
						CalibrationPara.AxisCalibrated[5] := TRUE;
						CalibrationPara.InitHome(Axis := (*ADR*)(CalibrationPara.AxesRef[5]), Execute := TRUE, HomingParameters := CalibrationPara.InitHomePara);
						CalibrationPara.SavedPositions[5] := CalibrationPara.InitHomePara.Position;
						RoboArm.Jog := FALSE;
						CalibrationPara.AxisSaveBtn := FALSE;
					END_IF
					
				END_IF
				
			END_IF
			
			IF NOT CalibrationPara.CalibrationModePara.AxisButton.Q6 THEN
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
		
		STATE_RESTORE_Q3_Q5:
			
			IF CalibrationPara.Axis5To6Para.Axis5Moved AND CalibrationPara.Axis5To6Para.Axis3Moved AND NOT RoboArm.MoveActive AND NOT RoboArm.MoveDirect THEN
					
				FOR j := 0 TO 5 BY 1 DO //set every distance to 0
					RoboArmPara.Distance[j] := 0.0;
				END_FOR;
					
				RoboArmPara.Distance[4] := -1 * CalibrationPara.Axis5To6Para.Axis5Angle; // simply move axis 5 by negative of what it was moved before (see page 100 of _lb-rc-RACER3-STM_en)
				RoboArmPara.Distance[2] := -1 * CalibrationPara.Axis5To6Para.Axis3Angle; //reverse the move done previously
				RoboArmPara.Velocity := CalibrationPara.Axis5To6Para.AxisMoveVelocity; // use a slow velocity for this (just to be safe)
				RoboArmPara.ManualMoveType := mcMOVE_RELATIVE; //select relative movement (to restore position after calibrating axis 6)
				RoboArmPara.CoordSystem := 0; // select ACS for moving
				RoboArm.MoveDirect := TRUE; //execute movement
					
			ELSIF RoboArm.MoveDone AND RoboArm.MoveDirect THEN //if move has been executed
					
				RoboArm.MoveDirect := FALSE; //reset move flag
				CalibrationPara.Axis5To6Para.Axis3Moved := FALSE;
				CalibrationPara.Axis5To6Para.Axis5Moved := FALSE; //set flag to let the program know axis 5 has been moved to correct position
				CalibrationPara.Axis5To6Para.Axis35Restored := TRUE;
				
			END_IF
			
			IF CalibrationPara.Axis5To6Para.Axis35Restored THEN
				CalibrationPara.Axis5To6Para.Axis5Return := FALSE;
				CalibrationPara.CalibrationState := STATE_START;
			END_IF
		
	END_CASE
	
END_FUNCTION_BLOCK
