
(* TODO: Add your comment here *)
FUNCTION_BLOCK R3Workspace
	(*Para.Para.ModalDataBehaviour := mcAGFMDB_USE_AX_GRP_SET
	Para.Para.SelfCollisionDetection := mcAGFWSCD_EN;
	Para.Para.WorkspaceReference.Name := 'R3WorkSpace';*)
	
	
	Para.Cmd.Name := 'Feature_WorkspaceMonitoring';
	Para.Cmd.DataType := mcCFG_AXGRP_FEAT_WSM;
	Para.Cmd.DataAddress := ADR(Para.Para);
	Para.Cmd.Execute := TRUE;
	Para.Cmd();
	
	IF Para.Cmd.Done THEN
		Para.Done := TRUE;
		Para.Cmd.Execute := FALSE;
		Para.Cmd();
	END_IF
	
		
END_FUNCTION_BLOCK
