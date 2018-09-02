
.boot.stdOut:-1;
.boot.stdError:-2;

.config.mapCsvFormat:("SS";enlist ",");

/In UNIX
/.config.mapCsvLocation:`$":",getenv[`KATBASE],"/config/variableMap.csv";
/In WINDOWS
.config.mapCsvLocation:`$":",

/Maintains the state of all the configuration that has been loaded into the current process
.config.loadState:([forLib:`symbol$()]loaded:`boolean$();loadTime:`timestamp$();sources:());

/The prefix of a file to be classified as configuration
.config.filePrefix:"config";

.config.init:{
 .config.variableMap:.config.loadVarMap[];
 };

/Loads the configuration file for the variable map
/@returns (Dict) The alias <-> underlying variable mapping
.config.loadVarMap:{
 varTable:.config.loadCsv[.config.mapCsvLocation;.config.mapCsvFormat];
 :varTable[`variableAlias]!varTable`variableStore;
 };


/ Will return the specified variable or alias to the caller
/ @param cVar (symbol).The variable or alias to lookup
/ @returns ().The object stored within the variable or alias
/ @throws VariableNotSetException If the underlying variable does not exit
.config.get:{[cVar]
 if[not -11h~type cVar;
    '"IllegalArgumentException";
   ];
 actualVar:.config.getUnderlyingVar cVar;
 if[not .config.isSet actualVar;
   .config.logError "Variable '",string[cVar],"' is not set.Use .config.set to set this variable.";
   '"VariableNotSetException (",string[cVar],")";
   ];

   /Should be safe here.No try/catch required
   :get actualVar;
  };


/ Resolves the alias to the underlying variable (or returns the variable without modification if provided)
/  @param cVar (Symbol) The alias to resolve
/  @returns (Symbol) The resolved alias variable or the variable as passed
/  @throws VariableAliasNotFoundException If the alias passed doesn't map to any variable
.config.getUnderlyingVar:{[cVar]
    if["."~first string cVar;
        :cVar;
    ];
     if[not cVar in key .config.variableMap;
        .config.logError "Alias '",string[cVar],"' does not exist. Unable to resolve into underlying variable";
        '"VariableAliasNotFoundException (",string[cVar],")";
    ];
     :.config.variableMap cVar;
 };


/ Sets the specified alias or variable with the data specified. NOTE: If the variable is already set, this invocation
/ will throw an exception
/  @param cVar (Symbol) The alias or variable to set
/  @param data () The data to set into the variable
/  @throws VariableOverwriteNotPermittedException If the variable is already set
/  @see .config.doSet
.config.set:{[cVar;data]
    :.config.doSet[cVar;data;0b];
 };

/ Performs the setting of the variable, overwriting if set.
/  @param cVar (Symbol) The alias or variable to set
/  @param data () The data to set into the variable
/  @param force (Boolean) If true, data will be overwritten if present. False, data will not be overwritten
/  @see .config.set
/  @see .config.forceSet
.config.doSet:{[cVar;data;force]
    if[not -11h~type cVar;
        '"IllegalArgumentException";
    ];
     actualVar:.config.getUnderlyingVar cVar;
     if[.config.isSet actualVar;
        if[not force;
            .config.logError "Variable '",string[cVar],"' is already set. Use .config.forceSet to overwrite it";
            '"VariableOverwriteNotPermittedException (",string[cVar],")";
        ];
    ];
     set[actualVar;data];
 };


/ Loads the specified CSV file with the specified format, removing any blank lines
/ or comment lines (lines beginning with '/').
/ @param file (Symbol) Symbol reference to the file to load
/ @param csvFormat (List) Standard kdb CSV format to parse with 0:
/ @returns (Table) Parsed CSV table
.config.loadCsv:{[file;csvFormat]
    :csvFormat 0: fileData where not in[;(" ";"/")] first each fileData:read0 file;
 };

/ Supports resolving variable alias before testing if they are set or not NOTE: Also scans the
/ .q namespace so you can pass `value or `system and it will return true.
/  @returns (Boolean) True if the input symbol reference exists, false otherwise.
/  @see .config.getUnderlyingVar
 .config.isSet:{[ref]
    if[ref in key `.q;
        :1b;
    ];
     res:@[get;ref;`REF_NO_EXIST];
     if[res~`REF_NO_EXIST;
        :not `REF_NO_EXIST~@[get;.config.getUnderlyingVar ref;`REF_NO_EXIST];
    ];
     :1b;
 };

/ Configuration loader, similar to require for code loading.
/  @param lib (Symbol) The library to load the configuration for
/  @throws ConfigurationNotFoundException If no configuration is found for the library specified
.config.loadFor:{[lib]
    .config.logInfo "Loading configuration for library '",string[lib],"'";
     searchFiles:(.config.filePrefix,".",string lib),/:.kat.qFileSuffixes;
    configFiles:raze .util.os.findFilePaths[searchFiles;] each .config.get`config.paths;
     if[0~count configFiles;
        .config.logError "No configuration files found for library '",string[lib],"'. Expecting at least one of: ",.Q.s1 searchFiles;
        '"ConfigurationNotFoundException (",string[lib],")";
    ];
     .config.loadConfigFile each configFiles;
     .config.loadState,:(lib;1b;.z.P;configFiles);
 };


/  Loads the specified file
/  @param file (Symbol) The configuration file path to load
/  @throws ConfigurationLoadFailureException If the loading of the file fails for any reason
.config.loadConfigFile:{[file]
    .config.logInfo " ",string file;
    @[system;"l ",string file; { .config.logError "Failed to load configuration file (",string[y],"). Error - ",x; '"ConfigurationLoadFailureException" }[;file] ];
 };
 / Converts a symbol from a lower camel form to the dot-noted lower case form that is used for the configuration map aliases.
/  @param lc (Symbol) Containing the lower camel formatted identifier to convert
/  @returns (Symbol) The symbol now with the dot-noted lower case form
.config.fromLowerCamel:{[lc]
    if[not .util.isSymbol lc;
        '"IllegalArgumentException";
    ];
     :`$raze { $[x in .Q.A; :".",lower x; :x ]  } each string lc;
 };

/.boot.log.msg must be a dictionary that maps -1 to INFO and -2 to ERROR
/.config.logInfo:.boot.log.msg[.boot.stdOut;`cfg;`INFO;];
/.config.logError:.boot.log.msg[.boot.stdErr;`cfg;`ERROR;];





