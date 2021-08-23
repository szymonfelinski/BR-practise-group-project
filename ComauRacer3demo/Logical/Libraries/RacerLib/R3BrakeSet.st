
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3BrakeSet
	//these settings are set to default values, may be changed later if needed.
	BrakePara.AutomaticControl := mcSWITCH_ON;
	BrakePara.AutomaticInductionStop := mcSWITCH_OFF;
	BrakePara.ControlMonitoring := mcSWITCH_ON;
	BrakePara.EnableSBTRequestBySMC := mcSWITCH_OFF;
	BrakePara.MovementMonitoring := mcSWITCH_ON;
	BrakePara.RestrictedBrakeControl := mcSWITCH_OFF; //changed, it's a game changer.
	BrakePara.TestAtPowerOff := mcSWITCH_OFF;
	BrakePara.TestAtPowerOn := mcSWITCH_OFF;
	BrakePara.VoltageMonitoring := mcSWITCH_ON;
	BrakePara.ControlMonitoringFilterTime := 0.5;
	BrakeSet.Parameters := BrakePara;
	
	IF CurrentAxis = 1 THEN
		BrakeSet.Axis := ADR(Axis1);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 2 THEN
		BrakeSet.Axis := ADR(Axis2);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 3 THEN
		BrakeSet.Axis := ADR(Axis3);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 4 THEN
		BrakeSet.Axis := ADR(Axis4);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 5 THEN
		BrakeSet.Axis := ADR(Axis5);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 6 THEN
		BrakeSet.Axis := ADR(Axis6);
		BrakeSet.Execute := TRUE;
		IF BrakeSet.Done THEN
			BrakeSet.Execute := FALSE;
			CurrentAxis := CurrentAxis + 1;
		END_IF
		BrakeSet();
	ELSIF CurrentAxis = 7 THEN
		Done := TRUE;
	END_IF
		
	
END_FUNCTION_BLOCK