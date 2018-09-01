//util library
//until we make a generic way to load this script do it  manually -> q)\l C:\kdb\kat_framework\trunk\base\core\util.types.q

.util.unenumerate:{[input]
	data:$[.util.isTable input;flip;::] input;
	enumCols:where .util.isEnumeration each data;
	unenum:key[data]#(enumCols _ data),enumCols!get each data enumCols;
	:$[.util.isTable input;flip;::] unenum;
	};

.util.isEnumeration:{[enum]
	:abs[type enum] within 20 76h;
	};

.util.getTableAttributes:{[tbl]
	if[not any (.util.isTable;.util.isSymbol;.util.isFilePath)@\:tbl;
		'"Illegal Argument Exception";
	];
	:attr@/: .Q.v tbl;
	};
	
.util.set:{[target;source]
	set[target;source]
	};


 .util.isDictionary:{[dict]
	:(99h~type dict)&(not .util.isTable dict);
	};
	
.util.isList:{[list]
	:type[list] within 0 19h;
	};
	
.util.isMixedList:{[list]
	:type[list]=0h;
	};

.util.isSymbol:{

k).util.isTable:{$[99h=@x;(98=@!x)|98h=@. x;98h=@x]}