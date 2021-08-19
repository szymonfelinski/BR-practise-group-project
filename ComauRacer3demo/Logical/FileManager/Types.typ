
TYPE
	FileManagerUI : 	STRUCT 
		MpFileManagerUI_0 : MpFileManagerUI;
		MpFileManagerUISetupType : MpFileManagerUISetupType;
		MpFileManagerUIConnectType : MpFileManagerUIConnectType;
		MpFileManagerUIFileListType : MpFileManagerUIFileListType;
		MpFileManagerUIFileType : MpFileManagerUIFileType;
		MpFileManagerUIItemType : MpFileManagerUIItemType;
	END_STRUCT;
	TableInfo : 	STRUCT 
		Name : ARRAY[0..49]OF STRING[255];
		Size : ARRAY[0..49]OF UDINT;
		Type : ARRAY[0..49]OF MpFileManagerUIItemTypeEnum;
		LastModified : ARRAY[0..49]OF DATE_AND_TIME;
		NumberOfElements : USINT;
		SelectedRow : USINT;
	END_STRUCT;
	Auxiliary : 	STRUCT 
		Two : STRING[160];
		One : STRING[160];
		Config1str : STRING[160];
		Config2str : STRING[160];
		Config3str : STRING[160];
		TableConfigurationStr : STRING[255];
		NumberOfElementsStr : STRING[80];
		NewNamePlus : USINT;
		NewNamePlusStr : STRING[80];
		NewNameTextOne : STRING[80];
		NewNameTextTwo : STRING[80];
		prevNewName : STRING[255];
		NumberOfElementsMinus : USINT;
		newNewName : STRING[255];
		btnSort : USINT;
		btnSortStr : STRING[80];
		fileName : STRING[260];
		fullFilePath : STRING[260];
	END_STRUCT;
END_TYPE
