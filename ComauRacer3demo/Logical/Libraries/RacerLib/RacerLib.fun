
FUNCTION test : USINT
	VAR_INPUT
		New_Member : USINT;
	END_VAR
END_FUNCTION

FUNCTION R3ManualMode : BOOL
	VAR_INPUT
		ManualModePara : R3ManualModeType;
	END_VAR
	VAR_IN_OUT
		RoboArmPara : MpRoboArm6AxisParType;
		RoboArm : MpRoboArm6Axis;
	END_VAR
	VAR
		j : USINT;
		JogVelocityActual : REAL;
	END_VAR
END_FUNCTION
