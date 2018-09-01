tables[]


/
End of Day Process to write the intraday trading data 
down to disk

.cfg.persist.config tbl should be a matrix including attributes to be applied when saving down to disk
\

.u.eod:{[ed;tbl]
    config:.pdb.cfg.persist.config tbl;


    if[not config`multiDayPersist;
        :.pdb.eod.i.persistErrorHandler["Not Multi Day"]

    //Group the input table as date first
    tableByDate:`date xgroup get tbl;

    //Get back the dates as a list
    dates:key[tableByDate]`date;
    .log.info "Starting multi-day EoD persist [ Table:",string[tbl]," ] [ Date:",string[dt],"[ Count:",string[count tbl];

    //Check for the input ed to be within the range
    if[not ed in dates;
    .log.info "Ensuring empty table persisted for Eod process";
    tableByDate[ed]:flip enlist[`date] _ .schema.get tbl;
    ]

    

}

select from trade where Volume>10
?[
?[(exec distinct Sym from trade) in `MS`AB;"True";"False"]