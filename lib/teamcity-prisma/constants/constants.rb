module TeamcityPrisma

  
  ###############################################################################################
  ##
  ##  constants/secret_constants.rb file needs to be created/updated with more constant values.
  ##
  ###############################################################################################
  
  SITE_DEV = "dev"
  SITE_TC1 = "tc1"
  SITE_TC2 = "tc2"
  SITE_TC3 = "tc3"
  
  FILE_FOUND = "found.txt"
  FILE_REPLACE = "replace.txt"
  FILE_PROCESSED = "processed.txt"
  FILE_ITEMS = "items.txt"
  FILE_ITEMS_PROCESSED = "items_processed.txt"
  
  PROPERTY_VALUE_SHOW_PS1 = "Execute .ps1 from external file"
  PROPERTY_VALUE_SHOW_STDIN = "Put script into PowerShell stdin"
  
  PROPERTY_VALUE_STDIN = "STDIN"
  PROPERTY_VALUE_PS1 = "PS1"
  
  STEP_TYPE_POWERSHELL = "jetbrains_powershell"
  PROPERTY_NAME_POWERSHELL_EXECUTION = "jetbrains_powershell_execution"
  HTML_ELEMENT_VALUE_POWERSHELL_EXECUTION_MODE = "powershell_execution_mode"
  REST_LOCATION = '/httpAuth/app/rest'
  
  STEP_TYPE_COMMAND_LINE = "simpleRunner"
  PROPERTY_NAME_COMMAND_LINE_EXECUTION = "jetbrains_powershell_execution"
  PROPERTY_NAME_SCRIPT_CONTENT = "script.content"

end