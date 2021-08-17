(*
TYPE
	ControlSelectEnum : 
		(
		ManualJog,
		SemiAutomatic,
		Automatic
		);
	CalibrationType : 	STRUCT 
		Info : CalibrationInfo; (*Information portion of calibration.*)
		Cmds : CalibrationCmds; (*Calibration commands*)
		Para : CalibrationPara; (*Calibration parameters*)
	END_STRUCT;
	CalibrationPara : 	STRUCT 
		Parameters : R3CalibrationType;
		HomingParameters : McAcpAxHomingParType;
		FakeHomingModeEnum : ARRAY[0..14]OF McHomingModeEnum := [15(mcHOMING_DIRECT)];
		Positions : ARRAY[0..14]OF LREAL := [15(0.0)];
		HomingModeEnum : ARRAY[0..14]OF McHomingModeEnum := [15(mcHOMING_INIT)];
	END_STRUCT;
	CalibrationCmds : 	STRUCT 
		Mode : R3CalibrationMode;
		InitHome : MC_BR_InitHome_AcpAx;
		GroupHome : MC_BR_GroupHome_15;
	END_STRUCT;
	CalibrationInfo : 	STRUCT 
		CurrentState : OuterCalibrationState;
	END_STRUCT;
	OuterCalibrationState : 
		(
		STATE_BEGIN,
		STATE_FAKE_HOME,
		STATE_MOVING,
		STATE_SAVING_POSITION,
		STATE_DONE
		);
END_TYPE
*)