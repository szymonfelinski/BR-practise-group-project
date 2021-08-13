
ACTION ManualMode:
	IF ManualMode.Direction = POSITIVE THEN // set actual axis velocity based on which direction it's set to be moved
		ManualMode.JogVelocityActual := ManualMode.JogVelocity;
	ELSIF ManualMode.Direction = NEGATIVE THEN
		ManualMode.JogVelocityActual := -1 * ManualMode.JogVelocity;
	END_IF
	IF ManualMode.AxisButton.Q1 THEN // if a button is pressed, write corresponding velocity to the jog velocity array
				RoboArm6AxisPara.Jog.Velocity[0] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q2 THEN
				RoboArm6AxisPara.Jog.Velocity[1] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q3 THEN
				RoboArm6AxisPara.Jog.Velocity[2] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q4 THEN
				RoboArm6AxisPara.Jog.Velocity[3] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q5 THEN
				RoboArm6AxisPara.Jog.Velocity[4] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSIF ManualMode.AxisButton.Q6 THEN
				RoboArm6AxisPara.Jog.Velocity[5] := ManualMode.JogVelocityActual;
				RoboArm6Axis.Jog := TRUE;
			ELSE //if no buttons are pressed reset jog velocity array
				RoboArm6Axis.Jog := FALSE;
				FOR j := 0 TO 5 BY 1 DO //set every jog velocity to 0
					RoboArm6AxisPara.Jog.Velocity[j] := 0.0;
				END_FOR;
			END_IF
END_ACTION
