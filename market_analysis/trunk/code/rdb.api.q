//Set the MEDECO Table
//MEDECO:([]DATE:100?.z.D;START:100?(2017.01.01 2017.12.01);END:100?(2017.01.31 2017.12.31);PRICE:100?10);

//params:(`index`date!(`$"NBP_PK";.z.D));{


.rdb.medeco.api.getYearPriceAbs:{[params]

  $[any params[`index] like/: ("* PK";"*_PK");

	//l mod 7 will give the mid-week days
	
    (),exec {l:x+til 1+y-x;sum 1<l mod 7}'[START;END] wavg PRICE from MEDECO where DATE=params`date,INDEX=params`index,YEAR_ABS=params`maturity,not RELTAG in `DA`SPOT,(DATE<>START) or START<>END;

    any params[`index] like/: ("* OP";"*_OP");

    (),exec {l:x+til 1+y-x;cnt:(12*sum 1<l mod 7)+24*sum 1>=l mod 7;$[3~`mm$x;cnt-1;10~`mm$x;cnt+1;cnt]}'[START;END] wavg PRICE from MEDECO where DATE=params`date,INDEX=params`index,YEAR_ABS=params`maturity,not RELTAG in `DA`SPOT,(DATE<>START) or START<>END;

    (),exec (1+END-START) wavg PRICE from MEDECO where DATE=params`date,INDEX=params`index,YEAR_ABS=params`maturity,not RELTAG in `DA`SPOT,(DATE<>START) or START<>END]

  };
