
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

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK R3SemiAutoMode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		SemiAutoModePara : {REDUND_UNREPLICABLE} R3SemiAutoModeType;
	END_VAR
	VAR_IN_OUT
		RoboArm : MpRoboArm6Axis;
		RoboArmPara : MpRoboArm6AxisParType;
		MainState : R3StateMachineEnum;
		ControlSelector : ControlSelectEnum;
	END_VAR
END_FUNCTION_BLOCK
