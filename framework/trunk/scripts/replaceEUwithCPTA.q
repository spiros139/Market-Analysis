//To run the script, load first the .util.types.q library to provide functions for unenumeration.  

hdbpath:`:C:/kdb_data/hdb;

//startTime:.z.D;
//Load the relevant library for enumeration
//\l C:/kdb/kat_framework/trunk/base/core/uti.types.q

//Create a Random table
//MD_CONSOLIDATED_TRADE:([]DATE:1000?2017.01.01 + til 5;INDEX:1000?`NBP`GASPOOL`NGX;PRICE:1000?100);
//{.Q.dpft[hdbpath;x;`INDEX;`MD_CONSOLIDATED_TRADE]}each (exec distinct DATE from MD_CONSOLIDATED_TRADE);

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
	t:update TRADING_VENUE:`CME from t;
	
	
	//At the moment it throws a 'cast' error meaning value 'FCA' not in enumeration.
	.Q.par[hdbpath;DATE;TABLE] set .Q.en[hdbpath]t;

	//Ensure that the p attrribute is reserved in SYM Columns
	$[all{`p=attr .Q.par[hdbpath;x;`MD_CONSOLIDATED_TRADE]`INDEX}each  dates;1"p attribute is reserved\n";1"p attribute is lost\n"];
	delete t from `.;
	
	//1"Saving down column to column ",(string ` sv (.Q.par[hdbpath;DATE;TABLE];`REGULATORY_AREA)),"\n";
	.Q.gc[];
	};
	
set[`sym;get ` sv hdbpath,`sym];
replaceFunc'[`MD_CONSOLIDATED_TRADE]'[dates]

//"exit 0" if you want to exit after.