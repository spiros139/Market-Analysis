//Boot Stage Downloader 2

.boot.start:{[inArgs]
    system "c 60 500";

    .boot.isEnvironmentOk[];

    cfgPath:getenv[`KATBASE],"/core/config.q";
    -1 "Loading configuration manager: ",cfgPath;
    system "l ",cfgPath;
    .config.init[];
	};

/*
    inArgsDict:first each .Q.opt inArgs;
    .config.set[`input.args;inArgsDict];
    .config.set[`port;] procPort:$[()~inArgsDict`port; 0i; 0i^"I"$inArgsDict`port];

    .boot.loadEnvVariables[];
    .boot.buildDefaultPaths[];

    .boot.loadRequireAndCoreLibs[];

    bootType:.option.getInitFunction inArgsDict;

    if[null bootType;
        .log.fatal "No boot type was recognised based on the input arguments. Process will not boot!";
        .option.printUsage[];
        .util.exit 1;
    ];

    if[.util.inDebugMode[];
        .boot.enableDebugMode[];
    ];

    .listener.notify `core.boot.complete;

    .log.info "Command line arguments: ","[ ",(" ] [ " sv { string[x]," : ",.Q.s1 .config.get[`input.args] x } each key .config.get[`input.args])," ]";
    .log.info "Stage 3 boot loader function: [ ",.Q.s1[bootType]," ]";

    .util.execute[bootType;inArgsDict;{ .log.fatal "Stage 3 boot loader failed to execute successfully! Error - ",x; .util.exit 1; }];

    if[not 0=procPort;
        if[.ipc.isListening[];
            .log.warn "Process port has already been configured (",string[.ipc.getPort[]],"). -port parameter will now override this to ",string procPort;
        ];

        .util.execute[.ipc.bind;procPort;{ .log.fatal "Process was unable to bind to the specified port! Error - ",x; .util.exit 1; }];
    ];

    / Should always be the last thing to happen in .boot.start
    .listener.notify `boot.complete;//Boot Stage Downloader 2

.boot.start:{[inArgs]
    system "c 60 500";

    .boot.isEnvironmentOk[];

    cfgPath:getenv[`KATBASE],"/core/config.q";
    -1 "Loading configuration manager: ",cfgPath;
    system "l ",cfgPath;
    .config.init[];

    inArgsDict:first each .Q.opt inArgs;
    .config.set[`input.args;inArgsDict];
    .config.set[`port;] procPort:$[()~inArgsDict`port; 0i; 0i^"I"$inArgsDict`port];

    .boot.loadEnvVariables[];
    .boot.buildDefaultPaths[];

    .boot.loadRequireAndCoreLibs[];

    bootType:.option.getInitFunction inArgsDict;

    if[null bootType;
        .log.fatal "No boot type was recognised based on the input arguments. Process will not boot!";
        .option.printUsage[];
        .util.exit 1;
    ];

    if[.util.inDebugMode[];
        .boot.enableDebugMode[];
    ];

    .listener.notify `core.boot.complete;

    .log.info "Command line arguments: ","[ ",(" ] [ " sv { string[x]," : ",.Q.s1 .config.get[`input.args] x } each key .config.get[`input.args])," ]";
    .log.info "Stage 3 boot loader function: [ ",.Q.s1[bootType]," ]";

    .util.execute[bootType;inArgsDict;{ .log.fatal "Stage 3 boot loader failed to execute successfully! Error - ",x; .util.exit 1; }];

    if[not 0=procPort;
        if[.ipc.isListening[];
            .log.warn "Process port has already been configured (",string[.ipc.getPort[]],"). -port parameter will now override this to ",string procPort;
        ];

        .util.execute[.ipc.bind;procPort;{ .log.fatal "Process was unable to bind to the specified port! Error - ",x; .util.exit 1; }];
    ];

    / Should always be the last thing to happen in .boot.start
    .listener.notify `boot.complete;//Boot Stage Downloader 2

.boot.start:{[inArgs]
    system "c 60 500";

    .boot.isEnvironmentOk[];

    cfgPath:getenv[`KATBASE],"/core/config.q";
    -1 "Loading configuration manager: ",cfgPath;
    system "l ",cfgPath;
    .config.init[];

    inArgsDict:first each .Q.opt inArgs;
    .config.set[`input.args;inArgsDict];
    .config.set[`port;] procPort:$[()~inArgsDict`port; 0i; 0i^"I"$inArgsDict`port];

    .boot.loadEnvVariables[];
    .boot.buildDefaultPaths[];

    .boot.loadRequireAndCoreLibs[];

    bootType:.option.getInitFunction inArgsDict;

    if[null bootType;
        .log.fatal "No boot type was recognised based on the input arguments. Process will not boot!";
        .option.printUsage[];
        .util.exit 1;
    ];

    if[.util.inDebugMode[];
        .boot.enableDebugMode[];
    ];

    .listener.notify `core.boot.complete;

    .log.info "Command line arguments: ","[ ",(" ] [ " sv { string[x]," : ",.Q.s1 .config.get[`input.args] x } each key .config.get[`input.args])," ]";
    .log.info "Stage 3 boot loader function: [ ",.Q.s1[bootType]," ]";

    .util.execute[bootType;inArgsDict;{ .log.fatal "Stage 3 boot loader failed to execute successfully! Error - ",x; .util.exit 1; }];

    if[not 0=procPort;
        if[.ipc.isListening[];
            .log.warn "Process port has already been configured (",string[.ipc.getPort[]],"). -port parameter will now override this to ",string procPort;
        ];

        .util.execute[.ipc.bind;procPort;{ .log.fatal "Process was unable to bind to the specified port! Error - ",x; .util.exit 1; }];
    ];

    / Should always be the last thing to happen in .boot.start
    .listener.notify `boot.complete;
	
	\*