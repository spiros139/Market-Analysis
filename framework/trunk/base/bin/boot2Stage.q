//Boot Stage Downloader 2
Trade:([]Sym:`A`B`C;Price:100 200 300;Volume:10 20 30);


.boot.start:{[inArgs]
    system "c 60 500";

    //To check that what it is doing
    //.boot.isEnvironmentOk[];

    cfgPath:getenv[`KATBASE],"/core/config.q";
    -1"Loading configuration manager";
    //system "l ",cfgPath;
    //.config.init[];
    };

