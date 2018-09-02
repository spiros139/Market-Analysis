/set KATBASE = C:\kdb\framework\trunk\base\


{	//The Load for Windows is different path	
	stage2boot:"C:/Kdb/framework/trunk/base/bin/boot2Stage.q";
	@[system;"l ",stage2boot;{show "n ERROR:The stage 2 bootloader failed to load succesfully!Error is - ",x;'x;}];
	.boot.start .z.x
	}[];
	
