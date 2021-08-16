
TYPE
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : INT; (*Stores which direction should the axis be moved (1 - POSITIVE, -1 - NEGATIVE)*)
		JogVelocity : REAL; (*Stores the velocity of axis*)
		PathLimits : McJogPathLimitsType; (*Stores set limits of acceleration and deceleration, velocity and jerk*)
		ActivateMove : BOOL; (*Enables or disables current move execution*)
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
		STATE_HOMING (*Homing mode*)
		);
	R3CalibrationType : 	STRUCT 
		CalibrationState : R3CalibrationStateEnum; (*State machine used to control Calibration behaviour*)
		CalibrationModePara : R3ManualModeType; (*same type used for manual mode (slightly different code handling)*)
		AxisCalibrated : ARRAY[0..5]OF BOOL := [6(0)]; (*Saves which axes have been calibrated (defaults to 0 upon creation)*)
		AxisSaveBtn : BOOL; (*Button to save current position as calibrated*)
		Axis5To6Para : R3Axis5To6Type; (*Stores axis 5 settings for axis 6 calibration*)
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
		STATE_RESTORE_Q5
		);
	R3Axis5To6Type : 	STRUCT  (*Type for storing axis 5 setting for axis 6 calibration*)
		Axis5MovedToCalAxis6 : BOOL; (*Stores whether axis 5 has been moved in order to calibrate axis 6*)
		Axis5Velocity : REAL; (*Velocity of axis 5*)
		Axis5Angle : LREAL; (*Angle of axis 5 to be set*)
		Axis5Return : BOOL; (*Flag to be set by a button to restore axis 5's position after calibrating axis 6*)
		Axis5Restored : BOOL; (*Axis 5 has been restored to previous position*)
	END_STRUCT;
END_TYPE
