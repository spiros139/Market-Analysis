.schema.get:{[tbl]
	if[not .util.isSymbol tbl;
		'"IllegalArgumentException";
	];
	if[not tbl in .schema.listTables[];
		$