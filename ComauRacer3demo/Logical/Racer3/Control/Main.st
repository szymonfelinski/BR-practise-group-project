
PROGRAM _INIT
	(* Insert code here *)
	RoboArm.MpLink := ADR(gAxesGroupR3);
	RoboArm.Parameters := ADR(RoboArmPara);
	RoboArm.Enable := TRUE;
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	RoboArm();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	
END_PROGRAM

