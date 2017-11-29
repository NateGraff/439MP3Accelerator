/*
 * mp3FromSD.h
 *
 *  Created on: Nov 9, 2017
 *      Author: chris
 */

#ifndef SRC_MP3FROMSD_H_
#define SRC_MP3FROMSD_H_

/***************************** Include Files SD*********************************/

#include "xparameters.h"	/* SDK generated parameters */
#include "xsdps.h"		/* SD device driver */
#include "xil_printf.h"
#include "ff.h"
#include "xil_cache.h"
#include "xplatform_info.h"
FRESULT mp3Read(char *fileName, void *outputDest, UINT *fileLength);

#endif /* SRC_MP3FROMSD_H_ */
