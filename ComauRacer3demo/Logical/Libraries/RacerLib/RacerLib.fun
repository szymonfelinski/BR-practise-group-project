
FUNCTION test : USINT
	VAR_INPUT
		New_Member : USINT;
	END_VAR
END_FUNCTION

FUNCTION ManualMode : BOOL
	VAR_IN_OUT
		RoboArmPara : MpRoboArm6AxisParType;
		RoboArm : MpRoboArm6Axis;
	END_VAR
END_FUNCTION
