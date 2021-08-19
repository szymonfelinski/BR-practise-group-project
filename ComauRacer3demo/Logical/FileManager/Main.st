
PROGRAM _INIT
	cmd.MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	cmd.MpFileManagerUI_0.Enable := TRUE;

	cmd.MpFileManagerUI_0.UISetup := cmd.MpFileManagerUISetupType;
	cmd.MpFileManagerUI_0.UIConnect := ADR(cmd.MpFileManagerUIConnectType);

	(* define of device names *) 
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[0] := 'UserPart';
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[1] := 'AUDIT';	
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[2] := 'CNC_PrgDir';		
	
	cmd.MpFileManagerUIConnectType.File.NewName := '';
	
	cmd.MpFileManagerUI_0();
END_PROGRAM

PROGRAM _CYCLIC
	tabInfo.NumberOfElements := 0;
	FOR iFile := 0 TO 49 BY 1 DO 	
		(* create arrays with file properties *)
		brsmemcpy(ADR(tabInfo.Name[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Name), SIZEOF(tabInfo.Name[iFile]));
		brsmemcpy(ADR(tabInfo.Size[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].Size), SIZEOF(tabInfo.Size[iFile]));
		brsmemcpy(ADR(tabInfo.Type[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].ItemType), SIZEOF(tabInfo.Type[iFile]));
		brsmemcpy(ADR(tabInfo.LastModified[iFile]), ADR(cmd.MpFileManagerUIConnectType.File.List.Items[iFile].LastModified), SIZEOF(tabInfo.LastModified[iFile]));
		
		IF tabInfo.SelectedRow = iFile THEN
			cmd.MpFileManagerUIConnectType.File.List.Items[iFile].IsSelected := TRUE;
		END_IF
		
		(* dynamic change of the array size *)
		IF tabInfo.Type[iFile] <> mpFILE_ITEM_TYPE_NONE THEN
			tabInfo.NumberOfElements := tabInfo.NumberOfElements + 1;
		END_IF
	END_FOR
	
	brsitoa(tabInfo.NumberOfElements, ADR(aux.NumberOfElementsStr));
	aux.TableConfigurationStr := '{"specRows": [ {"from":0, "to":';
	aux.One := ', "visible":true}, {"from":';
	aux.Two := ', "to":49, "visible":false}]}';
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.NumberOfElementsStr));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.One));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.NumberOfElementsStr));
	brsstrcat(ADR(aux.TableConfigurationStr), ADR(aux.Two));
	
	(* dynamic change of the existing name *)
	aux.NumberOfElementsMinus := tabInfo.NumberOfElements - 1;
	aux.NewNamePlus := 0;
	aux.newNewName := '';
	aux.prevNewName := cmd.MpFileManagerUIConnectType.File.NewName;
	aux.newNewName := aux.prevNewName;
	(*FOR iFile := 0 TO aux.NumberOfElementsMinus BY 1 DO
		IF tabInfo.Name[iFile] = aux.newNewName THEN
			aux.newNewName := aux.prevNewName;
			aux.NewNamePlus := aux.NewNamePlus + 1;
			brsitoa(aux.NewNamePlus, ADR(aux.NewNamePlusStr));
			aux.NewNameTextOne := '(';
			aux.NewNameTextTwo := ')';
			brsstrcat(ADR(aux.newNewName), ADR(aux.NewNameTextOne));
			brsstrcat(ADR(aux.newNewName), ADR(aux.NewNamePlusStr));
			brsstrcat(ADR(aux.newNewName), ADR(aux.NewNameTextTwo));
			//iFile := 0;	
		ELSE
			cmd.MpFileManagerUIConnectType.File.NewName := aux.newNewName;
		END_IF
	END_FOR*)
	
	//zmiana metody sortowania 
	CASE aux.btnSort OF
		0: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_NAME_ASC;
			//	aux.btnSortStr := 'SortByNameUp'; jak bindowaæ adres tekstu lokalizowanego?
		1: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_NAME_DESC;
		2: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_SIZE_ASC;
		3: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_SIZE_DES;
		4: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_MOD_TIME_ASC;
		5: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_MOD_TIME_DESC;
		6:
			aux.btnSort := 0;
	END_CASE
	
	cmd.MpFileManagerUI_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	cmd.MpFileManagerUI_0.Enable := FALSE;
	cmd.MpFileManagerUI_0();
END_PROGRAM

