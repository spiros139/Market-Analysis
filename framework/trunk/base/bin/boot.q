set KATBASE = C:\kdb\framework\trunk\base\


{
	coreenvVar:`KATBASE
	if[""~katbase:getenv coreenvVar;
	-2!"ERROR:Critical Enviromental Variable ($",string[coreenvVar],") 
	is not set!System cannot boot";
	exit 1;
	];
	stage2boot:katbase,"\bin\bootStage2.q";
	@[system;"l ",stage2boot;{-2 "\n ERROR:The stage 2 bootloader failed to load 
	succesfully!Error is - ",x,"\n";'x;}];
	.boot.start .z.x
	}[];
	
