
PROGRAM _INIT
	cmd.MpFileManagerUI_0.MpLink := ADR(gFileManagerUI);
	cmd.MpFileManagerUI_0.Enable := TRUE;

	cmd.MpFileManagerUI_0.UISetup := cmd.MpFileManagerUISetupType;
	cmd.MpFileManagerUI_0.UIConnect := ADR(cmd.MpFileManagerUIConnectType);

	(* define of device names *) 
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[0] := 'CNC_PrgDir';
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[1] := 'UserPart';	
	cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[2] := 'AUDIT';		
	
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

	IF tabInfo.NumberOfElements >= 1 THEN
		
		aux.NewNamePlus := 0;
		aux.newNewName := '';
		aux.prevNewName := cmd.MpFileManagerUIConnectType.File.NewName;
		aux.newNewName := aux.prevNewName;
		FOR iFile := 0 TO aux.NumberOfElementsMinus BY 1 DO
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
		END_FOR
	END_IF
		
	//change sorting method
	CASE aux.btnSort OF
		0: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_NAME_ASC;
			aux.btnSortStr := '$$IAT/Browser/SortByNameAsc'; 
		1: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_NAME_DESC;
			aux.btnSortStr := '$$IAT/Browser/SortByNameDesc'; 
		2: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_SIZE_ASC;
			aux.btnSortStr := '$$IAT/Browser/SortBySizeAsc'; 
		3: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_SIZE_DES;
			aux.btnSortStr := '$$IAT/Browser/SortBySizeDesc'; 
		4: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_MOD_TIME_ASC;
			aux.btnSortStr := '$$IAT/Browser/SortByLastModAsc'; 
		5: 
			cmd.MpFileManagerUIConnectType.File.SortOrder := mpFILE_SORT_BY_MOD_TIME_DESC;
			aux.btnSortStr := '$$IAT/Browser/SortByLastModDesc'; 
		6:
			aux.btnSort := 0;
	END_CASE
	
	//variables used to load files
	aux.fileName := tabInfo.Name[tabInfo.SelectedRow];
	aux.NewNameTextOne := '/';
	aux.fullFilePath := '';
	brsstrcat(ADR(aux.fullFilePath), ADR(cmd.MpFileManagerUIConnectType.DeviceList.DeviceNames[cmd.MpFileManagerUIConnectType.DeviceList.SelectedIndex])); //device name
	brsstrcat(ADR(aux.fullFilePath), ADR(aux.NewNameTextOne)); // '/'
	brsstrcat(ADR(aux.fullFilePath), ADR(cmd.MpFileManagerUIConnectType.File.PathInfo.CurrentDir)); //this adds subfolder compatibility
	brsstrcat(ADR(aux.fullFilePath), ADR(aux.fileName)); // file name
	
	cmd.MpFileManagerUI_0();
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	cmd.MpFileManagerUI_0.Enable := FALSE;
	cmd.MpFileManagerUI_0();
END_PROGRAM

