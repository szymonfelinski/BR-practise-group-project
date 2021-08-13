
TYPE
	R3ManualModeType : 	STRUCT  (*Manual mode type*)
		AxisButton : R3TCPAxisBtnType; (*Stores button states for global coordinate system*)
		JointButton : R3JointBtnType; (*Stores button states for axis coordinate system*)
		Velocity : REAL; (*Stores set velocity*)
		Acceleration : REAL; (*Stores set acceleration*)
		Deceleration : REAL; (*Stores set deceleration*)
		CoordinateSystem : UDINT; (*Stores selected coordinate system (0 - axis, 9 - global, 10 - tool) (no tool is set, so 9=10)*)
		Direction : DirectionEnum; (*Stores which direction should the axis be moved*)
	END_STRUCT;
	R3JointBtnType : 	STRUCT  (*Axes 1-6 select button*)
		Q1 : BOOL;
		Q2 : BOOL;
		Q3 : BOOL;
		Q4 : BOOL;
		Q5 : BOOL;
		Q6 : BOOL;
	END_STRUCT;
	R3TCPAxisBtnType : 	STRUCT  (*Global Coordinate System Select button*)
		X : BOOL;
		Y : BOOL;
		Z : BOOL;
		A : BOOL;
		B : BOOL;
		C : BOOL;
	END_STRUCT;
	DirectionEnum : 
		(
		POSITIVE,
		NEGATIVE
		);
END_TYPE
