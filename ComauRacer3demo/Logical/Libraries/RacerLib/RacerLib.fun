
FUNCTION_BLOCK R3BrakeSet
	VAR_INPUT
		Axis1 : REFERENCE TO UDINT;
		Axis2 : REFERENCE TO UDINT;
		Axis3 : REFERENCE TO UDINT;
		Axis4 : REFERENCE TO UDINT;
		Axis5 : REFERENCE TO UDINT;
		Axis6 : REFERENCE TO UDINT;
	END_VAR
	VAR_OUTPUT
		Done : BOOL;
		Error : BOOL;
	END_VAR
	VAR
		BrakePara : McAcpAxBrakeParType;
		CurrentAxis : USINT := 1;
		BrakeSet : MC_BR_BrakeSetPar_AcpAx;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK R3ManualMode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		ManualModePara : R3ManualModeType;
	END_VAR
	VAR_IN_OUT
		RoboArm : MpRoboArm6Axis;
		RoboArmPara : MpRoboArm6AxisParType;
		MainState : R3StateMachineEnum;
		ControlSelector : ControlSelectEnum;
	END_VAR
	VAR
		j : USINT;
		JogVelocityActual : REAL;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION_BLOCK R3SemiAutoMode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_IN_OUT
		SemiAutoModePara : R3SemiAutoModeType;
		RoboArm : MpRoboArm6Axis;
		RoboArmPara : MpRoboArm6AxisParType;
		MainState : R3StateMachineEnum;
		ControlSelector : ControlSelectEnum;
	END_VAR
	VAR
		SemiAutoModePara_memory : R3SemiAutoModeType;
		WeNeedToGoBack : BOOL;
		IsPaused : BOOL;
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
		j : {REDUND_UNREPLICABLE} USINT;
	END_VAR
END_FUNCTION_BLOCK

{REDUND_ERROR} FUNCTION checkAxisLimits : BOOL (*returns TRUE if semi-automatic path is containted in axis limits, check is for relative positions*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Q1 : REAL;
		Q2 : REAL;
		Q3 : REAL;
		Q4 : REAL;
		Q5 : REAL;
		Q6 : REAL;
		Mode : BOOL; (*1 for relative, 0 for absolute*)
		RoboArm : MpRoboArm6Axis; (*needed for current axis position*)
	END_VAR
END_FUNCTION

{REDUND_ERROR} {REDUND_UNREPLICABLE} FUNCTION_BLOCK R3AutomaticMode (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		AxesGroup : REFERENCE TO UDINT; (*AxesGroup to execute program on*)
	END_VAR
	VAR_IN_OUT
		AutoMode : R3AutomaticModeType; (*Main type variable*)
	END_VAR
	VAR
		UnloadMode : {REDUND_UNREPLICABLE} McUnloadProgramModeEnum; (*defines unload mode behaviour*)
	END_VAR
END_FUNCTION_BLOCK
