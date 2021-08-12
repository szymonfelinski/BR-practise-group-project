
PROGRAM _INIT

	MpRoboArm6Axis_0.Enable := TRUE;

	MpRoboArm6Axis_0.Override  := 100.0;
	RoboParameters.ProgramName := 'Robotic.st';    //File stored on FileDevice
     
END_PROGRAM

PROGRAM _CYCLIC
    
	MpRoboArm6Axis_0.MpLink     := ADR(g6AxRobA);
	MpRoboArm6Axis_0.Parameters := ADR(RoboParameters);
	MpRoboArm6Axis_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

