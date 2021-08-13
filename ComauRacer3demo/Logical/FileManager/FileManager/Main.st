
PROGRAM _INIT
	cmd.MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	cmd.MpFileManagerUI_0.Enable := TRUE;
	cmd.MpFileManagerUI_0();
	
	(* Additional configuration options for the HMI application.  *)
	cmd.MpFileManagerUISetupType.FileListSize := 12;
	cmd.MpFileManagerUISetupType.FileListScrollWindow := 2;
	
	
	(* Define all of the information necessary to establish a connection to the HMI application *)
	//cmd.MpFileManagerUIConnectType.
	
	
	
	
	
	cmd.MpFileManagerUI_0.UISetup := cmd.MpFileManagerUISetupType;
	cmd.MpFileManagerUI_0.UIConnect := ADR(cmd.MpFileManagerUIConnectType);
END_PROGRAM

PROGRAM _CYCLIC
	
	FOR iFile := 0 TO 49 BY 1 DO
//		 := cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Name 
		nxt_adr := brsmemcpy(ADR(tabInfo.Name[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Name), 2000 (*SIZEOF(tabInfo.Name[iFile]*));
		nxt_adr := brsmemcpy(ADR(tabInfo.Size[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Size), SIZEOF(tabInfo.Size[iFile]));
		nxt_adr := brsmemcpy(ADR(tabInfo.Type[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].ItemType), SIZEOF(tabInfo.Type[iFile]));
	END_FOR;
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	cmd.MpFileManagerUI_0.Enable := FALSE;
	cmd.MpFileManagerUI_0();
END_PROGRAM

