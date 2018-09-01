//Create the MEDECO table with M1 Reltags
//q)MEDECO:([INDEX1:100?`AECO`IBM`MS`GOOG]RELTAG:100#`M1;PRICE:100?100f)
//q)`:C:/kdbdata/hdb/MEDECO/ set .Q.en[`:C:/kdbdata/hdb] 0!MEDECO
//`:C:/kdbdata/hdb/MEDECO/


//Specify the hdb path
.hdb.cfg.path:`:C:/kdbdata/hdb;
//When import the logs
//.log.info "cd to hdb directory: ",string .hdb.path;

//Set the sym for recovery just in case everything is messed up
set[`sym;get ` sv .hdb.cfg.path,`sym];
//When import the logs
//.log.info "Loading updated prices"

//Create a table MEDECO and save it to the hdb directory in splayed format
tblData:get `:C:/kdbdata/hdb/MEDECO;
tblSource:`$(string .hdb.cfg.path),tblData;
tblTarget:`$(string .hdb.cfg.path),tblData;
tblTargetSym:.hdb.cfg.path;

medecoKeys:`INDEX1;
//.log.info "Loading Medeco Table";
existingMedeco:@[get tblSource;where not null .util.getTableAttributes tblSource;`#];

//.log.info"Applying keys to Medeco";
existingMedeco:medeco xkey .util.unenumerate existingMedeco;

//Open a handle to 5001
.var.tp.handle:hopen 5001;

//.log.info"Pushing Data to Tickerplant";
(neg .var.tp.handle)(`.u.upd;`MEDECO;0!tblData);

//Applying attributes
attributes:(`INDEX1`RELTAG)!(#[`s];#[`g]);

//.log.info "Pushing Data into full Medeco Table";
newMedeco:0!existingMedeco upsert tblData;

//.log.info "Applying attributes to data";
newMedeco:`INDEX xasc newMedeco;
newMedeco:{@[x;y;z}/[newMedeco;key attributes;attributes];
newMedeco:.Q.en[tblTargetSym;newMedeco];

//.log.info "Saving down to disk";
res:.[set;(tblTarget;newMedeco);{:(`MEDECO_SAVE_FAIL;x) }];
if[not res~tblTarget;
	//.log.error "Persist table has failed";
	};

	exit 0
