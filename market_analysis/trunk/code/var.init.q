//Create a function that will upsert entries in memory and set it on disk
//d:(`GOOG;`JPY;2.21f;`LPG)

.var.updateIndexDescription:{[d]
.var.cfg.filesLocations:`:C:/kdb/kat_var/trunk/config;
filepath: ` sv .var.cfg.filesLocations,`INDEX_DESCRIPTION.csv;
`INDEX_DESCRIPTION upsert d;

//filepath takes a list of strings and pushes them into the file handle.Each element of the list is a new line in the file
//This saves the file with the updated records into the file handle
filepath 0: "," 0:INDEX_DESCRIPTION;

//Assign INDEX_DESCRIPTION in memory to be exactly what it is on the file handle ("SSFS";enlist ",") 0:filepath
set[`INDEX_DESCRIPTION;("SSFS";enlist ",") 0:filepath];
:INDEX_DESCRIPTION
}


