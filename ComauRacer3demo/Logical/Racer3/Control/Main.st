
PROGRAM _INIT
	(* Insert code here *)
	RoboArm.MpLink := ADR(gAxesGroupRacer3);
	RoboArm.Parameters := ADR(RoboArmPara);
	RoboArm.Enable := TRUE;
	RoboArm();
END_PROGRAM

PROGRAM _CYCLIC
	(* Insert code here *)
	RoboArm.MpLink := ADR(gAxesGroupRacer3);
	RoboArm.Parameters := ADR(RoboArmPara);
	RoboArm.Enable := TRUE;
	//Ans := test(4,8,5);
	//act1;
	
	//main state machine
	CASE MainState OF
		Init:
			IF NOT InitEnable THEN
				//reset remaining actions etc
				RoboArm.Power := FALSE;
				RoboArm.Home := FALSE;
				RoboArm.MoveVelocity:=FALSE;	
				RoboArm.MoveAdditive:=FALSE;
			ELSE
				MainState:=PowerOn;
			END_IF
		PowerOn:
			IF RoboArm.Info.ReadyToPowerOn THEN
				RoboArm.Power := TRUE;
			END_IF
			
			IF RoboArm.PowerOn AND RoboArm.IsHomed THEN
				RoboArm.Home:=FALSE;
				MainState:=Ready;
			ELSE
				IF RoboArm.PowerOn THEN
					MainState:= Home;
				END_IF 
			END_IF
		Home:
			RoboArm.Home := TRUE;
			IF RoboArm.IsHomed THEN
				RoboArm.Home:=FALSE;
				stan:= Ready;
			END_IF 
		Ready:
			CASE ControlState OF
				ManualJog:
					
			END_CASE
	END_CASE
	
	RoboArm();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	
END_PROGRAM

