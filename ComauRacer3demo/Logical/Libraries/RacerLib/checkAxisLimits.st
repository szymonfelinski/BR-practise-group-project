
(* returns TRUE if semi-automatic path is containted in axis limits, check is for relative positions *)
FUNCTION checkAxisLimits
	// Q1 -170 170
	// Q2 -95 135
	// Q3 -155 90
	// Q4 -200 200
	// Q5 -125 125
	// Q6 -270 270
	checkAxisLimits:=TRUE;
	IF Mode THEN
	//relative
		IF RoboArm.Info.JointAxisPosition[0] + Q1 < -170 OR RoboArm.Info.JointAxisPosition[0] + Q1 > 170 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF RoboArm.Info.JointAxisPosition[1] + Q2 < -95 OR RoboArm.Info.JointAxisPosition[1] + Q2 > 135 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF RoboArm.Info.JointAxisPosition[2] + Q3 < -155 OR RoboArm.Info.JointAxisPosition[2] + Q3 > 90 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF RoboArm.Info.JointAxisPosition[3] + Q4 < -200 OR RoboArm.Info.JointAxisPosition[3] + Q4 > 200 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF RoboArm.Info.JointAxisPosition[4] + Q5 < -125 OR RoboArm.Info.JointAxisPosition[4] + Q5 > 125 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF RoboArm.Info.JointAxisPosition[5] + Q6 < -270 OR RoboArm.Info.JointAxisPosition[5] + Q6 > 270 THEN
			checkAxisLimits := FALSE;
		END_IF
	ELSE
	//absolute
		IF Q1 < -170 OR  Q1 > 170 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF Q2 < -95 OR Q2 > 135 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF Q3 < -155 OR Q3 > 90 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF Q4 < -200 OR Q4 > 200 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF Q5 < -125 OR Q5 > 125 THEN
			checkAxisLimits := FALSE;
		END_IF
		IF Q6 < -270 OR Q6 > 270 THEN
			checkAxisLimits := FALSE;
		END_IF
	END_IF
END_FUNCTION
