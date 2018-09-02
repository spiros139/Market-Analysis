// Logging Framework

.log.stdOut:-1;
.log.stdErr:-2;

/ Logging output levels.DEBUG/INFO/WARN will be sent to stdout.ERROR/FATAL to stderr
.log.levels:`DEBUG`INFO`WARN`ERROR`FATAL;

/ Default logging Level
.log.level:`INFO;

/ Log Details to print each log line
/ @ example 2018.09.02 11:37:00.036 spolitis wukcw-16thgr 0
.log.detail:({.z.D};{.z.T};{`unknown^.z.u};{first `vs .z.h};{.z.w});


/ Standard color reset control sequence. Removes any color setting.
.log.colorReset:"\033[0m";

.log.colors:()!();
.log.colors[`WARN]:"\033[1;33m";
.log.colors[`ERROR]:"\033[1;31m";
.log.colors[`FATAL]:"\033[1;4;31m";

.log.init:{
  .log.msg:.log.msgColor;
  if[.log.colorEnabled[];
     .log.msg:.log.msgColor;
    ];

   .log.build .log.levels;
   .log.silenceLogLevels .log.level;

   unsetColors:.log.levels except key .log.colors;
   .log.colors[unsetColors]:count[unsetColors]#enlist .log.colorReset;

   .log.info "Logging Framework initialized (log level: ",string[.log.level],")";

   if[.log.colorEnabled[];
   .log.debug "Log Colors enabled: "," | sv {.log.colors[x],string[x],.log.colorReset }each key .log.colors;
   ];
  };
