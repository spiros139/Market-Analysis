//Value at Risk
//l:(2017.03.17;`$"GEORGE2";`MO_REPORTING)

getVarMO:{[l]
	t:getVar[l[0];l[1];l[2];260;1;`relative;2.5];
	t,getVar[l[0];l[1];l[2];520;1;`relative;2.5]]
	};
	
getVar:{[d1;d2;x;y;n;p;rt;k]
	t:raze getVarByDate[;x;y;n;p;rt;k]each d1+til(d2-d1)+1;
	};
	
getVarByDate:{[d;x;y;n;p;rt]
	t:getDistribution[d;x;y;n;p;rt];
	getVarByDateByCompound[t;d;y;;rt;n;k]each asc exec distinct COMPOUND from t
	};

getDistribution:{
