//IPC Library

//Documentation:

/Load the C Libraries for encryption and decryption --TODO
/.ipc.encryptcbc:(`$(":",(getenv`KATBASE),"/core/security/aencrypt")) 2:(`encrypt_cbc;2);
/.ipc.decryptcbc:(`$(":",(getenv`KATBASE),"/core/security/aencrypt")) 2:(`decrypt_cbc;2);

/Maximum number of times to attempt reconnection on process disconnect
/@see .ipc.cfg.outboundAutoReconnect
.ipc.cfg.reconnectRetryCount:5;

/Whether a request should be logged to file when query received on the specific handler.
/NOTE: Queries that result in an error will always be printed to log regardless of this
/setting
/@See .ipc.log.info
.ipc.cfg.log:()!();
.ipc.cfg.log[`.z.pg]:1b;
.ipc.cfg.log[`.z.ps]:1b;
.ipc.cfg.log[`.z.ph]:1b;

/Whether a request should generate `incoming`complete`failed events when query received on the specific handler
/@See .ipc.i.queryNotify
.ipc.cfg.notify:()!(); 
.ipc.cfg.notify[`.z.pg]:1b;
.ipc.cfg.notify[`.z.ps]:1b;
.ipc.cfg.notify[`.z.ph]:1b;

 /Defines how often the IPC caches should be cleared to ensure that do not contain stale data.This is currently defined as 24 hours --TODO
 //.ipc.cfg.cache.clearInterval:.util.msToTimespan 24*60*60*1000;
 
 /Stores the list of inbound connections made to the current process (via .z.po)
 .ipc.inbound:1!flip `handler`user`password`ipaddress`enckey`hostname`connectTime`lastQuery`lastQueryType`queryOk`lastQueryTime`lastQueryDuration`validity!"IS*I*SP*SBPNZ"$\:();
 
 /Stores the list of inbound allowed connections to kdb back end
 .ipc.server:([]user:`symbol$();password:();ipaddress:`int$();enckey:();validity:`datetime$());
 `.ipc.server upsert (`kdbVaR_server;"kdbtest";-1062687231;0x12589678e5f8457485eea7c00f12a5b1;.z.Z+1000);
 
 /Once a connection is listed on .ipc.server will initialize also a session here, that is valid for 1 hours
 .ipc.session:([h:`int$()];enckey:());
 
 /Function that will be used from C# in WCF Service to initialize a connection
 .ipc.createUser:{[x]
				  a:.z.z+1%1000;
				  //.log.info"[ User: ",(string x[`user],"]","[ Host: ",(string .Q.host[.z.a]),"]"," being created at [Time: ",(string .z.Z),"]";
				  `.ipc.server insert (x[`user];x[`password];256i sv x[`ipaddress];x[`enckey];.z.z+1%24);
				  };
				  