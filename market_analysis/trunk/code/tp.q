//Tickerplant upd function
.u.upd:{[tbl;d]
	if[not tbl in key .tp.subscribers;
	  :.log.error "Data received for table ",string[tbl],"cannot be processed by this TP. There is no schema for this table";
	];
	if[.util.isDictionary d;
		if[all .util.isList each d;
		d:flip d;
		];
	];
	if[.util.isList d;
		if[all .util.isList each d;
			if[not all .util.isMixedList each d;
			   d:flip d;
			   ];
			  ];
			 ];
	if[not null .tp.log.handle;
		.tp.log.handle enlist (".u.upd";tbl;d);
	   ];
	tbl upsert d;
	if[.tp.cfg.stats enable;
		.tp.i.processStats[tbl;d];
	   ];
	if[not .tp.cfg.batch.enable;
		.tp.i.publish tbl;
	   ];
	 }
	
	   
	
