
{REDUND_ERROR} FUNCTION_BLOCK R3ManualMode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ManualModePara : R3ManualModeType;
	END_VAR
	VAR_IN_OUT
		RoboArm : MpRoboArm6Axis;
		RoboArmPara : MpRoboArm6AxisParType;
	END_VAR
	VAR
		j : USINT;
		JogVelocityActual : REAL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_UNREPLICABLE} FUNCTION_BLOCK R3CalibrationMode
	VAR_IN_OUT
		CalibrationPara : R3CalibrationType;
		RoboArm : MpRoboArm6Axis;
		RoboArmPara : MpRoboArm6AxisParType;
	END_VAR
	VAR
		JogVelocityActual : {REDUND_UNREPLICABLE} REAL;
		j : USINT;
	END_VAR
END_FUNCTION_BLOCK
