//To run the script, load first the .util.types.q library to provide functions for unenumeration.  

hdbpath:`:C:/kdb_data/hdb;

//startTime:.z.D;


dates:"D"$string key[hdbpath] except (`sym;`COMMENTS;`MEDECO);

//Save the sym file in case everything is messed up
set[`sym;get ` sv hdbpath,`sym];





replaceFunc:{[TABLE;DATE]
	
	1"Unenumerating table: ",(raze string TABLE)," for date: ",(string DATE),"\n";
	//Locate the MD_CONSOLIDATED_TRADE in each Partition
	tabloc:.Q.par[hdbpath;DATE;TABLE];
		
	1"Table exists\n";
	
	
	1"Unenumerating Column\n";
	t:.util.unenumerate get .Q.par[hdbpath;DATE;TABLE];
	
	
	//Gives the list of the REGULATORY_AREA column enumerated against the sym
	//`sym$`EU`EU`EU`EU`US`US`EU`US`EU`US`EU`EU`EU`EU`EU`US`US`US`EU`US`EU`EU`EU`US
	// value each will unenumerate the above column and throw away the 'sym' column
	l:value each .util.unenumerate get ` sv (.Q.par[hdbpath;DATE;TABLE];`TRADING_VENUE);
	
	
	l[where l=`CME]:`FCA;
	//At the moment it throws a 'cast' error meaning value 'FCA' not in enumeration.
	(` sv (.Q.par[hdbpath;DATE;TABLE];`TRADING_VENUE)) set `sym$l;

	//Ensure that the p attrribute is reserved in SYM Columns
	$[all{`p=attr .Q.par[hdbpath;x;`MD_CONSOLIDATED_TRADE]`INDEX}each  dates;1"p attribute is reserved\n";1"p attribute is lost\n"];
	delete t from `.;
	
	//1"Saving down column to column ",(string ` sv (.Q.par[hdbpath;DATE;TABLE];`REGULATORY_AREA)),"\n";
	.Q.gc[];
	};

set[`sym;get ` sv hdbpath,`sym];

replaceFunc'[`MD_CONSOLIDATED_TRADE]'[dates]

//"exit 0" if you want to exit after.

	