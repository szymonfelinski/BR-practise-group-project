
TYPE
	R3AutomaticModeErrorEnum : 
		(
		autoNO_ERROR := 0,
		autoLOAD_PROGRAM_ERROR := 1,
		autoUNLOAD_PROGRAM_ERROR := 2,
		autoEXECUTE_PROGRAM_ERROR := 3,
		autoPAUSE_ERROR := 4,
		autoCONTINUE_ERROR := 5,
		autoABORT_ERROR := 6
		);
	R3AutomaticModeCmds : 	STRUCT  (*Automatic mode commands*)
		LoadProgram : MC_BR_LoadProgram;
		ExecuteProgram : MC_BR_MoveProgram;
		UnloadProgram : MC_BR_UnloadProgram;
		PauseProgram : MC_GroupInterrupt;
		ContinueProgram : MC_GroupContinue;
		GroupStop : MC_GroupStop;
	END_STRUCT;
	R3AutomaticModeState : 
		( (*Automatic mode state machine*)
		autoSTATE_WAIT := 1, (*waiting for instruction*)
		autoSTATE_LOAD := 2, (*loading program*)
		autoSTATE_UNLOAD := 3, (*Unloading program state*)
		autoSTATE_EXECUTE := 4, (*executing program*)
		autoSTATE_DONE := 5, (*execution done*)
		autoSTATE_PAUSE := 6, (*program paused*)
		autoSTATE_CONTINUE := 7, (*Continues paused program*)
		autoSTATE_ABORT := 8, (*Abort current program*)
		autoSTATE_ERROR := 0 (*error state*)
		);
	R3AutomaticModePara : 	STRUCT  (*Automatic mode parameters*)
		ProgramName : STRING[260]; (*Program name to load/execute*)
		Load : BOOL; (*Load a program*)
		Execute : BOOL; (*Executes a program*)
		Unload : BOOL; (*Unloads a program*)
		ErrorReset : BOOL; (*Resets errors*)
		Abort : BOOL; (*Aborts execution.*)
		UnloadAll : BOOL; (*tells the program to unload all programs from memory (used with Unload)*)
		Pause : BOOL; (*Pauses execution*)
		Continue : BOOL; (*Continues execution*)
		Continuous : BOOL; (*Defines whether the program will be called continuously*)
	END_STRUCT;
	R3AutomaticModeInfo : 	STRUCT 
		CurrentState : R3AutomaticModeState; (*Current automode state*)
		Error : R3AutomaticModeErrorEnum;
		ErrorID : DINT;
		Paused : BOOL;
		IsError : BOOL; (*Only for visualisation.*)
	END_STRUCT;
	R3AutomaticModeType : 	STRUCT  (*Automatic mode main structure*)
		Parameters : R3AutomaticModePara;
		Info : R3AutomaticModeInfo;
		Cmds : R3AutomaticModeCmds;
	END_STRUCT;
	R3WorkspaceType : 	STRUCT  (*this allows workspace to be set during runtime.*)
		Para : McCfgAxGrpFeatWsmType := (ModalDataBehaviour:=(Type:=mcAGFMDB_USE_AX_GRP_SET));
		Cmd : MC_BR_ProcessConfig;
		Done : BOOL; (*indicates the FB has finished*)
	END_STRUCT;
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : INT; (*Stores which direction should the axis be moved (1 - POSITIVE, -1 - NEGATIVE)*)
		JogVelocity : REAL := 20; (*Stores the velocity of axis*)
		PathLimits : McJogPathLimitsType; (*Stores set limits of acceleration and deceleration, velocity and jerk*)
		ActivateMove : BOOL; (*Enables or disables current move execution*)
		ExitManual : BOOL; (*Exits Manual Mode on True*)
	END_STRUCT;
	R3AxisBtnType : 	STRUCT  (*Global Coordinate System Select button*)
		Q1 : BOOL;
		Q2 : BOOL;
		Q3 : BOOL;
		Q4 : BOOL;
		Q5 : BOOL;
		Q6 : BOOL;
	END_STRUCT;
	R3DirectionEnum : 
		( (*Currently unused*)
		POSITIVE := 1,
		NEGATIVE := -1
		);
	R3StateMachineEnum : 
		(
		STATE_ERROR, (*Error state*)
		STATE_INIT, (*Initialisation state*)
		STATE_POWER_ON, (*Powering on state*)
		STATE_READY, (*Ready for commands*)
		STATE_MANUAL_CONTROL, (*Manual mode*)
		STATE_SEMI_AUTOMATIC, (*Semi automatic mode*)
		STATE_AUTOMATIC, (*Automatic mode (script execution)*)
		STATE_CALIBRATION, (*Calibration mode*)
		STATE_HOMING, (*Homing mode*)
		STATE_BRAKES (*This will read brakes' status.*)
		);
	R3CalibrationType : 	STRUCT 
		CalibrationState : R3CalibrationStateEnum; (*State machine used to control Calibration behaviour*)
		CalibrationModePara : R3ManualModeType; (*same type used for manual mode (slightly different code handling)*)
		AxisCalibrated : ARRAY[0..5]OF BOOL := [6(0)]; (*Saves which axes have been calibrated (defaults to 0 upon creation)*)
		AxisSaveBtn : BOOL; (*Button to save current position as calibrated*)
		Axis5To6Para : R3Axis5To6Type; (*Stores axis 4 and 5 settings for axis 5 and 6 calibration*)
		SavedPositions : ARRAY[0..5]OF LREAL;
		InitHome : MC_BR_InitHome_AcpAx; (*Used to init home positions after each save*)
		InitHomePara : McAcpAxHomingParType; (*Homing parameters after each save*)
		AxesRef : ARRAY[0..5]OF UDINT; (*Axes reference.*)
	END_STRUCT;
	R3CalibrationStateEnum : 
		(
		STATE_START,
		STATE_CALIBRATE_Q1,
		STATE_CALIBRATE_Q2,
		STATE_CALIBRATE_Q3,
		STATE_CALIBRATE_Q4,
		STATE_CALIBRATE_Q5,
		STATE_CALIBRATE_Q6,
		STATE_RESTORE_Q3_Q5
		);
	R3Axis5To6Type : 	STRUCT  (*Type for storing axis 3 and 5 settings for axes 5 and 6 calibration*)
		Axis3Moved : BOOL; (*Stores whether axis 3 has been moved in order to calibrate axes 5 and  6*)
		Axis5Moved : BOOL; (*Stores whether axis 5 has been moved in order to calibrate axis 6*)
		AxisMoveVelocity : REAL; (*Velocity of axis 3 and 5*)
		Axis3Angle : LREAL := -45.0; (*Angle of axis 3 to be set*)
		Axis5Angle : LREAL := -118.0; (*Angle of axis 5 to be set*)
		Axis5Return : BOOL; (*Flag to be set by a button to restore axis 3 and 5's positions after calibrating axis 6*)
		Axis35Restored : BOOL; (*Axis 3 and 5 have been restored to previous position*)
	END_STRUCT;
	R3SemiAutoEnumType : 
		(
		INIT := 0,
		START := 1,
		UPDATE := 2,
		GO := 3,
		STATE_STOP := 5,
		STATE_PAUSE := 4
		);
	R3SemiAutoModeType : 	STRUCT 
		AskedValue : R3AskedValueType; (*Stores given axis distance for relative move*)
		Flag : BOOL; (*Flag between READY and SEMIAUTO*)
		Mode : BOOL; (*Switches between relative and absolute modes, 1 for Relative, 0 for Absolute*)
		UpdatePending : BOOL; (*if UpdatePending then updates before starting move*)
		State : R3SemiAutoEnumType; (*state selector for state machine*)
		ModeForThisMove : BOOL; (*makes sure that switching mode in time of moving doesnt bugs out move*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		PathMode : BOOL; (*Switches between direct and linear path mode, 1 for linear , 0 for direct*)
		PathModeForThisMove : BOOL;
		ExitSemiAuto : BOOL;
		Pause : BOOL;
	END_STRUCT;
	ControlSelectEnum : 
		(
		ManualJog := 1,
		SemiAutomatic := 2,
		Automatic := 3,
		None := 0
		);
	R3AskedValueType : 	STRUCT  (*for SemiAuto*)
		Velocity : REAL := 69;
		Acceleration : REAL := 100;
		Deceleration : REAL := 100;
		Jerk : REAL := 0;
		TCS : ARRAY[0..5]OF REAL := [420,420,420,69,69,69];
		ACS : ARRAY[0..5]OF REAL := [-69,69,69,69,-69,69];
	END_STRUCT;
	R3CalibrationMainType : 	STRUCT 
		Info : CalibrationInfo; (*Information portion of calibration.*)
		Cmds : CalibrationCmds; (*Calibration commands*)
		Para : CalibrationParaType; (*Calibration parameters*)
	END_STRUCT;
	CalibrationParaType : 	STRUCT 
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
	CommunicationType : 	STRUCT 
		Power : BOOL := FALSE;
		Pause : BOOL := FALSE;
		Stop : BOOL := FALSE;
		ErrorReset : BOOL := FALSE;
		ModeSystem : BOOL := TRUE;
		PathSystem : BOOL := TRUE;
		changeModePending : USINT := 0; (*1-Manual       2-SemiManual      3-Auto 0-none*)
		NOTPathSystem : BOOL;
		NOTModeSystem : BOOL;
		CoordinateSystemManual : BOOL := FALSE;
		NOTCoordinateSystemSemiAuto : BOOL := FALSE;
		CoordinateSystemSemiAuto : BOOL := FALSE;
		NOTCoordinateSystem : BOOL;
		txt_State_out : WSTRING[80];
		AskedMaxVelocity : REAL; (*not needed*)
		AskedMaxAcc : REAL; (*not needed*)
		AskedMaxDeAcc : REAL; (*not needed*)
		AskedAutoJerk : REAL; (*not needed*)
		AskedAutoDeAcc : REAL; (*not needed*)
		AskedAutoAcc : REAL; (*not needed*)
		AskedAutoVelocity : REAL; (*not needed*)
		AskedManualVelocity : REAL; (*not needed*)
		UpdateSemiAutoVars : BOOL := FALSE;
		CalibBtn1To5 : BOOL := FALSE;
		CalibrationImage : STRING[80];
		TextManager : TextManagerType;
		RestoreAxis5 : BOOL := FALSE;
		CalibrateAgain : BOOL := FALSE;
		txt_State_out_front : STRING[80];
		BrakeOpen : BOOL; (*open the brakes*)
		BrakeClose : BOOL; (*close the brakes*)
		BrakeReadStatus : BOOL; (*read status of brakes*)
		BrakesSet : BOOL; (*This variable tells the program if brake parameters have been set.*)
		ToolOutput : BOOL; (*This variable enables tool control*)
		ReturnToZero : BOOL; (*This variable allows returning to zero position in manual mode.*)
		ResetHome : BOOL;
		WarmRestart : BOOL := FALSE;
		ReadWorkspace : BOOL;
	END_STRUCT;
	R3BrakeStateMachineEnum : 
		(
		brakeREAD,
		brakeOPEN,
		brakeCLOSE,
		brakeDONE,
		brakeERROR
		);
	R3BrakeParaType : 	STRUCT 
		BrakeCmd : McBrakeCmdEnum;
		Identifier : UDINT;
	END_STRUCT;
	R3BrakeCmdsType : 	STRUCT 
		BrakeOperation : MC_BR_GroupBrakeOperation;
	END_STRUCT;
	R3BrakeInfoType : 	STRUCT 
		BrakeStatus : ARRAY[1..2]OF McBrakeStatusEnum;
		Done : BOOL;
		State : R3BrakeStateMachineEnum;
		Error : BOOL;
	END_STRUCT;
	R3BrakeType : 	STRUCT 
		Parameters : R3BrakeParaType;
		Info : R3BrakeInfoType;
		Cmds : R3BrakeCmdsType;
	END_STRUCT;
	R3KeyCheckType : 	STRUCT 
		original_combo : ARRAY[0..4]OF USINT := [1,2,3,0,17];
		pending_combo : ARRAY[0..4]OF USINT;
		i : USINT := 0;
		temp_value : USINT;
		value_changed : BOOL := FALSE;
		event_achieved : BOOL := FALSE;
	END_STRUCT;
	TextManagerType : 	STRUCT 
		CalibHelper : STRING[80];
	END_STRUCT;
END_TYPE
