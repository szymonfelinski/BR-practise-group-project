
PROGRAM _INIT
	cmd.MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	cmd.MpFileManagerUI_0.Enable := TRUE;

	cmd.MpFileManagerUI_0.UISetup := cmd.MpFileManagerUISetupType;
	cmd.MpFileManagerUI_0.UIConnect := ADR(cmd.MpFileManagerUIConnectType);

	(* define of device names *) 
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[0] := 'UserPart';
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[1] := 'USB';	
	
	cmd.MpFileManagerUI_0();
END_PROGRAM

PROGRAM _CYCLIC
	tabInfo.NumberOfElements := 0;
	aux.errorNameExists := 0;
	FOR iFile := 0 TO 49 BY 1 DO 	
		(* create arrays with file properties *)
		brsmemcpy(ADR(tabInfo.Name[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Name), SIZEOF(tabInfo.Name[iFile]));
		brsmemcpy(ADR(tabInfo.Size[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Size), SIZEOF(tabInfo.Size[iFile]));
		brsmemcpy(ADR(tabInfo.Type[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].ItemType), SIZEOF(tabInfo.Type[iFile]));
		brsmemcpy(ADR(tabInfo.LastModified[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].LastModified), SIZEOF(tabInfo.LastModified[iFile]));
		
		IF tabInfo.SelectedRow = iFile THEN
			cmd.MpFileManagerUIConnectType.File.List.Items[iFile].IsSelected := TRUE;
		END_IF
//		
//		IF tabInfo.Name[iFile] = cmd.MpFileManagerUIConnectType.File.NewName AND (cmd.MpFileManagerUIConnectType THEN
//			aux.errorNameExists := 1;
//		END_IF
		
		(* dynamic change of the array size *)
		IF tabInfo.Type[iFile] <> mpFILE_ITEM_TYPE_NONE THEN
			tabInfo.NumberOfElements := tabInfo.NumberOfElements + 1;
		END_IF
	END_FOR;

	brsitoa(tabInfo.NumberOfElements, ADR(aux.NumberOfElementsStr));
	aux.TableConfigurationStr := '{"specRows": [ {"from":0, "to":';
	aux.One := ', "visible":true}, {"from":';
	aux.Two := ', "to":49, "visible":false}]}';
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.NumberOfElementsStr));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.One));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.NumberOfElementsStr));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.Two));
	
	cmd.MpFileManagerUI_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	cmd.MpFileManagerUI_0.Enable := FALSE;
	cmd.MpFileManagerUI_0();
END_PROGRAM

