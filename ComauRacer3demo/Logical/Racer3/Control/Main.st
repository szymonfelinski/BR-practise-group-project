
PROGRAM _INIT
	(* Insert code here *)
	RoboArm.MpLink := ADR(gAxesGroupR3);
	RoboArm.Parameters := ADR(RoboArmPara);
	RoboArm.Enable := TRUE;
	RoboArm();
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	//RoboArm.MpLink := ADR(gAxesGroupR3);
	//RoboArm.Parameters := ADR(RoboArmPara);
	//RoboArm.Enable := TRUE;

	RoboArm();
	IF test_bol2 THEN
		test_bol := AxisControl(1,1,1,1,1,1);
	END_IF
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	
END_PROGRAM

