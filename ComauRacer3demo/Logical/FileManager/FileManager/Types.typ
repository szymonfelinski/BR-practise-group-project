
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
<<<<<<< Updated upstream
		Name : STRING[80];
=======
		Name : ARRAY[0..49]OF STRING[80];
>>>>>>> Stashed changes
		Size : REAL;
		Type : STRING[80];
	END_STRUCT;
END_TYPE
