
TYPE
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3AxisBtnType; (*Stores button states for select coordinate system*)
		Velocity : REAL; (*Stores set velocity*)
		Acceleration : REAL; (*Stores set acceleration*)
		Deceleration : REAL; (*Stores set deceleration*)
		CoordinateSystem : UDINT; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : DirectionEnum; (*Stores which direction should the axis be moved*)
		JogVelocity : REAL; (*Stores the actual velocity to be written to axis*)
	END_STRUCT;
	R3AxisBtnType : 	STRUCT  (*Global Coordinate System Select button*)
		Q1 : BOOL;
		Q2 : BOOL;
		Q3 : BOOL;
		Q4 : BOOL;
		Q5 : BOOL;
		Q6 : BOOL;
	END_STRUCT;
	DirectionEnum : 
		(
		POSITIVE,
		NEGATIVE
		);
END_TYPE
