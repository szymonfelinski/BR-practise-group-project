
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3Brake
	
	Brake.Info.Done := FALSE;
	
	Brake.Parameters := Parameters;
	
	IF Brake.Parameters.ReadState THEN
		Brake.Info.BrakeOp := mcBRAKE_GET_STATUS;
		Brake.Cmds.BrakeOperation(Axis := ADR(Axis), Execute := TRUE, Command := Brake.Info.BrakeOp);
		IF Brake.Cmds.BrakeOperation.Done THEN
			Brake.Info.BrakeStatus := Brake.Cmds.BrakeOperation.BrakeStatus;
			Brake.Cmds.BrakeOperation.Execute := FALSE;
			Brake.Cmds.BrakeOperation();
			Brake.Parameters.ReadState := FALSE;
			Brake.Info.Done := TRUE;
		END_IF
	END_IF
	
	
	Info := Brake.Info;
	
END_FUNCTION_BLOCK
