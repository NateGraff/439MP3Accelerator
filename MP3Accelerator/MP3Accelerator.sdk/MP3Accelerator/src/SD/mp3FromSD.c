/*
 * mp3FromSD.c
 *
 *  Created on: Nov 8, 2017
 *      Author: chris
 */

// chris gerdom
// framework for reading mp3 files from sd cards

/***************************** Include Files SD*********************************/

//#include "xparameters.h"	/* SDK generated parameters */
//#include "xsdps.h"		/* SD device driver */
//#include "xil_printf.h"
//#include "ff.h"
//#include "xil_cache.h"
//#include "xplatform_info.h"
#include "mp3FromSD.h"
/************************** Variable Definitions SD*****************************/
FIL fil;		/* File object */
FATFS fatfs;
FRESULT Res;
TCHAR *Path = "0:/";

/* **************************************************************************
 *  sd card read
 ***************************************************************************/


FRESULT mp3Read(char *fileName, void *outputDest, UINT *fileLength){
	FRESULT Res0,Res1,Res2,Res3,Res4;

	Res0 = f_mount(&fatfs, Path, 0);
	Res1 = f_open(&fil,fileName,FA_READ);
	Res2 = f_lseek(&fil,0);
	Res3 = f_read(&fil,outputDest,fil.fsize,fileLength);
	Res4 = f_close(&fil);
	return (Res0|Res1|Res2|Res3|Res4);

}


