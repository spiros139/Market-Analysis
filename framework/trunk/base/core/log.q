// Logging Framework
// kdb @ Total | IT Development | Total Gas and Power Ltd


// DOCUMENTATION: http://wiki_site/log.q

.log.stdOut:-1;
.log.stdErr:-2;

/ Logging output levels. DEBUG / INFO / WARN will be sent to stdout. ERROR / FATAL to stderr.
.log.levels:`DEBUG`INFO`WARN`ERROR`FATAL;

/ Default logging level
.log.level:`INFO;

/ Log details to print with each log line
/  @example 2013.11.28 10:08:11.036 jrajasansir wukcw-1g5yt55j 0
.log.detail:({ .z.D };{ .z.T };{ `unknown^.z.u };{ first ` vs .z.h };{ .z.w });

/ Standard color reset control sequence. Removes any color setting.
.log.colorReset:"\033[0m";

.log.colors:()!();
.log.colors[`WARN]:"\033[1;33m";
.log.colors[`ERROR]:"\033[1;31m";
.log.colors[`FATAL]:"\033[1;4;31m";


.log.init:{
    .log.msg:.log.msgNoColor;

    if[.log.colorEnabled[];
        .log.msg:.log.msgColor;
    ];

    .log.build .log.levels;
    .log.silenceLogLevels .log.level;

    unsetColors:.log.levels except key .log.colors;
    .log.colors[unsetColors]:count[unsetColors]#enlist .log.colorReset;

    .log.info "Logging framework initialised (log level: ",string[.log.level],")";

    if[.log.colorEnabled[];
        .log.debug "Log colors enabled: "," | " sv { .log.colors[x],string[x],.log.colorReset } each key .log.colors;
    ];
 };

/ Generates the necessary function (based on .log.msg) for the specified standard
/ output and the levels
/  @param out (Short) The standard output (-1 or -2)
/  @param lvls (List) A symbol list of the log levels to set
/  @see .log.msg
.log.build:{[lvls]
    logParams:(.log.stdOut,/:3#lvls),.log.stdErr,/:3_lvls;
    logNames:` sv/:``log,/:lower lvls;

    set'[logNames;.log.msg ./: logParams];
 };

/ Message printing function. No color support
/  @param out (Short) The standard output (-1 or -2)
/  @param lvl (Symbol) The output level (e.g. `info)
/  @param msg (String) The log message
.log.msgNoColor:{[out;lvl;msg]
    detail:@[;::] each .log.detail;
    out " " sv string[detail,lvl],enlist msg;
 };

/ Message printing function with color support
/  @param out (Short) The standard output (-1 or -2)
/  @param lvl (Symbol) The output level (e.g. `info)
/  @param msg (String) The log message
/  @see .log.colors
/  @see .log.colorReset
.log.msgColor:{[out;lvl;msg]
    detail:@[;::] each .log.detail;
    out " " sv string[detail],enlist[.log.colors[lvl],string[lvl],.log.colorReset],enlist msg;
 };

/ Adjusts the log functions that are not needed based on the log level to a empty function.
/  @param newLvl (Symbol) One of the log levels (from .log.levels) to set
.log.silenceLogLevels:{[newLvl]
    levelsToDelete: lower#[;.log.levels] .log.levels?newLvl;
    logNames:` sv/:``log,/:lower levelsToDelete;

    set[;::] each logNames;
 };

/ Function to set the logging level required.
/  @see .log.level
/  @throws InvalidLogLevelException If a bad log level is passed
.log.setLevel:{[newLvl]
    if[not newLvl in .log.levels;
        '"InvalidLogLevelException";
    ];

    .log.level:newLvl;
    .log.init[];
 };

/ Function to add extra log detail information to each log line.
/  @param newDetail (Function|Symbol) A function ot symbol reference to execute when wanting to log.
/ with arguments (as symbols).
/  @see .log.detail
.log.addDetail:{[newDetail]
    .util.getFunction newDetail;

    if[any .util.functionEquals[newDetail;] each .log.detail;
        :(::);
    ];

    .log.detail,:newDetail;
 };

/ Removes standard formatting characters (e.g. \n, \t, \r) and replaces them such that
/ the entire input can be printed to a single log line.
/  @param strData (String) The input to flatten down to one line
/  @returns (String) The flattened line for logging
.log.toSingleLine:{[strData]
    :.util.findAndReplace[strData;("\n";"\t";"\r");(" || ";" ";"")];
 };

/ Tests whether log color printing should be enabled or not.
/  @returns (Boolean) True if colors should be enabled, false otherwise.
.log.colorEnabled:{
    :(not ""~getenv `KAT_LOGCOLORS) | `logColors in key .config.get`input.args;
 };

/ Provides the ability to indent any output with tables to allow for better logging.
/  @param str (String) The original string output for logging
/  @param indentLevel (Integer) The ident level, number of tabs, to set the text at.
.log.indent:{[str;indentLvl]
    tabs:indentLvl#"\t";
    :"\n",tabs,ssr[str;"\n";"\n",tabs];
 };

/ Formats any number format into a more readable version for logging (or reporting if required).
/  @param num (Number) Any number to format
/  @returns (String) The number formatted and returned as string ready for printing
/  @example .log.formatNumber 1123.124 -> '1,123.124'

/ Provides the ability to indent any output with tables to allow for better logging.
/  @param str (String) The original string output for logging
/  @param indentLevel (Integer) The ident level, number of tabs, to set the text at.
.log.indent:{[str;indentLvl]
    tabs:indentLvl#"\t";
    :"\n",tabs,ssr[str;"\n";"\n",tabs];
 };

/ Formats any number format into a more readable version for logging (or reporting if required).
/  @param num (Number) Any number to format
/  @returns (String) The number formatted and returned as string ready for printing
/  @example .log.formatNumber 1123.124 -> '1,123.124'
.log.formatNumber:{[num]
    if[not .util.isNumber num;
        '"IllegalArgumentException";
    ];

    if[.util.isReal num;
        num:"F"$string num;
    ];

    :raze ({ reverse "," sv 3 cut reverse string x };{ $[0=x; ""; :1_string x; ] })@'({`long$div[x;1]};mod[;1])@\: num;
 };
                                                                                                                 
                                                                       
                                                                           