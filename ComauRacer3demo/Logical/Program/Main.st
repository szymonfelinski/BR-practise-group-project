
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
	ManualMode.Acceleration := 100.0;
	ManualMode.CoordinateSystem := 9;
	ManualMode.Deceleration := 100.0;
	ManualMode.Velocity := 10.0;
	ManualMode.Direction := POSITIVE;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	RoboArm6AxisPara.Jog.CoordSystem := ManualMode.CoordinateSystem;
	RoboArm6AxisPara.Jog.Acceleration := ManualMode.Acceleration;
	RoboArm6AxisPara.Jog.Deceleration := ManualMode.Deceleration;
	
	IF RoboArm6Axis.Info.ReadyToPowerOn THEN
		
		RoboArm6Axis.Power := TRUE;
		
		IF RoboArm6Axis.PowerOn THEN

			IF ManualMode.Direction = POSITIVE THEN // set actual axis velocity based on which direction it's set to be moved
				ManualMode.JogVelocity := ManualMode.Velocity;
			ELSIF gManualMode.Direction = NEGATIVE THEN
				ManualMode.JogVelocity := -1 * ManualMode.Velocity;
			END_IF
			
			IF ManualMode.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
				RoboArm6AxisPara.Jog.Velocity[0] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q2 THEN
				RoboArm6AxisPara.Jog.Velocity[1] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q3 THEN
				RoboArm6AxisPara.Jog.Velocity[2] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q4 THEN
				RoboArm6AxisPara.Jog.Velocity[3] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q5 THEN
				RoboArm6AxisPara.Jog.Velocity[4] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q6 THEN
				RoboArm6AxisPara.Jog.Velocity[5] := ManualMode.JogVelocity;
				RoboArm6Axis.Jog := TRUE;
			ELSE //if no buttons are pressed reset jog velocity array
				RoboArm6Axis.Jog := FALSE;
				FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
					RoboArm6AxisPara.Jog.Velocity[j] := 0.0;
				END_FOR;
			END_IF
			
		END_IF
	END_IF
	
	
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
	 
END_PROGRAM

