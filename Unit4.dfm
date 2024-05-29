object DataModule4: TDataModule4
  OnCreate = DataModuleCreate
  Height = 319
  Width = 242
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 104
    Top = 64
  end
  object FDTable1: TFDTable
    Filtered = True
    IndexFieldNames = 'ID;TITLE_ID;PAGE_ID'
    Connection = FDConnection1
    FetchOptions.AssignedValues = [evMode, evLiveWindowFastFirst]
    FetchOptions.Mode = fmManual
    ResourceOptions.AssignedValues = [rvEscapeExpand, rvCmdExecMode]
    ResourceOptions.CmdExecMode = amCancelDialog
    TableName = 'pdfdatabase'
    Left = 104
    Top = 120
    object FDTable1ID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object FDTable1PAGE_ID: TIntegerField
      FieldName = 'PAGE_ID'
      Origin = 'PAGE_ID'
      Required = True
    end
    object FDTable1IMAGE: TBlobField
      FieldName = 'IMAGE'
      Origin = 'IMAGE'
    end
    object FDTable1TITLE_ID: TIntegerField
      FieldName = 'TITLE_ID'
      Origin = 'TITLE_ID'
      Required = True
    end
    object FDTable1TITLE: TStringField
      FieldName = 'TITLE'
      Origin = 'TITLE'
      Required = True
      Size = 50
    end
    object FDTable1SUBIMAGE: TIntegerField
      FieldName = 'SUBIMAGE'
      Origin = 'SUBIMAGE'
      Required = True
    end
  end
  object FDTable2: TFDTable
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'settings'
    Left = 104
    Top = 184
    object FDTable2pass: TStringField
      FieldName = 'pass'
      Origin = 'pass'
    end
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'CREATE TABLE pdfdatabase '
      '('
      '        ID'#9'INTEGER NOT NULL,'
      '        PAGE_ID'#9'INTEGER NOT NULL,'
      '        IMAGE'#9'BLOB ,'
      '        TITLE_ID'#9'INTEGER NOT NULL,'
      '        TITLE'#9'VARCHAR(50) NOT NULL,'
      '        SUBIMAGE'#9'integer NOT NULL,'
      ' PRIMARY KEY (ID)'
      ');'
      'create table settings(pass VARCHAR(20));'
      '')
    Left = 29
    Top = 184
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 101
    Top = 248
  end
  object FDMemTable1: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'PAGE_ID'
    FetchOptions.AssignedValues = [evMode, evRowsetSize, evUnidirectional]
    FetchOptions.Mode = fmAll
    FetchOptions.RowsetSize = 300
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 1073741823
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 176
    Top = 32
  end
  object FDGUIxAsyncExecuteDialog1: TFDGUIxAsyncExecuteDialog
    Provider = 'Forms'
    Left = 56
    Top = 8
  end
end
