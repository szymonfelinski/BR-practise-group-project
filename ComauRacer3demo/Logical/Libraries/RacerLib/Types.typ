
TYPE
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		CoordinateSystem : McCoordinateSystemEnum; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : R3DirectionEnum; (*Stores which direction should the axis be moved*)
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
		(
		POSITIVE,
		NEGATIVE
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
	R3SemiAutoEnumType : 
		(
		INIT := 0,
		START := 1,
		UPDATE := 2,
		GO := 3
		);
	R3SemiAutoModeType : 	STRUCT 
		AxisDistance : R3AxisDistanceType; (*Stores given axis distance for relative move*)
		Flag : BOOL; (*Flag between READY and SEMIAUTO*)
		Mode : BOOL; (*Switches between relative and absolute modes, 1 for Relative, 0 for Absolute*)
		UpdatePending : BOOL; (*if UpdatePending then updates before starting move*)
		State : R3SemiAutoEnumType; (*state selector for state machine*)
		ModeForThisMove : BOOL; (*makes sure that switching mode in time of moving doesnt bugs out move*)
	END_STRUCT;
	ControlSelectEnum : 
		(
		ManualJog := 1,
		SemiAutomatic := 2,
		Automatic := 3,
		None := 0
		);
	R3AxisDistanceType : 	STRUCT  (*todo axis position for absolute*)
		Q2 : REAL;
		Q3 : REAL;
		Q4 : REAL;
		Q5 : REAL;
		Q6 : REAL;
		Q1 : REAL;
	END_STRUCT;
END_TYPE
