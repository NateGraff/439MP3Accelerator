/* Xilinx includes. */
#include "xparameters.h"
#include "xscutimer.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "FreeRTOS/timer_ps.h"

#include "FreeRTOS/FreeRTOS.h"
#include "FreeRTOS/task.h"
#include "FreeRTOS/semphr.h"

#include "SD/mp3FromSD.h"

#include "libmad/mad.h"

#include <limits.h>
#define CODEC_ADDR 0b00011010
#define IIC_SCLK_RATE 100000

static void prvSetupHardware(void);
extern void vPortInstallFreeRTOSVectorTable(void);

void vApplicationMallocFailedHook(void);
void vApplicationIdleHook(void);
void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName);
void vApplicationTickHook(void);

XScuWdt xWatchDogInstance;
XScuGic xInterruptController;

static char fileName[32] = "thehit.mp3";
uint8_t printMeme[4000000];

/*
 * libmad callbacks
 */

struct buffer {
  unsigned char const *start;
  unsigned long length;
};

static inline
signed int scale(mad_fixed_t sample)
{
  /* round */
  sample += (1L << (MAD_F_FRACBITS - 16));

  /* clip */
  if (sample >= MAD_F_ONE)
    sample = MAD_F_ONE - 1;
  else if (sample < -MAD_F_ONE)
    sample = -MAD_F_ONE;

  /* quantize */
  return sample >> (MAD_F_FRACBITS + 1 - 16);
}

static
enum mad_flow input(void *data,
		    struct mad_stream *stream)
{
  struct buffer *buffer = data;

  if (!buffer->length)
    return MAD_FLOW_STOP;

  mad_stream_buffer(stream, buffer->start, buffer->length);

  buffer->length = 0;

  return MAD_FLOW_CONTINUE;
}

static
enum mad_flow output(void *data,
		     struct mad_header const *header,
		     struct mad_pcm *pcm)
{
  unsigned int nchannels, nsamples;
  mad_fixed_t const *left_ch, *right_ch;

  /* pcm->samplerate contains the sampling frequency */

  nchannels = pcm->channels;
  nsamples  = pcm->length;
  left_ch   = pcm->samples[0];
  right_ch  = pcm->samples[1];

  while (nsamples--) {
    signed int sample;

    /* output sample(s) in 16-bit signed little-endian PCM */

    sample = scale(*left_ch++);

    // TODO: output audio somewhere

/*    putchar((sample >> 0) & 0xff);
    putchar((sample >> 8) & 0xff);

    if (nchannels == 2) {
      sample = scale(*right_ch++);
      putchar((sample >> 0) & 0xff);
      putchar((sample >> 8) & 0xff);
    }
*/
  }

  return MAD_FLOW_CONTINUE;
}

static
enum mad_flow error(void *data,
		    struct mad_stream *stream,
		    struct mad_frame *frame)
{
  /* return MAD_FLOW_BREAK here to stop decoding (and propagate an error) */

  return MAD_FLOW_CONTINUE;
}

void sample_task(void *params)
{
	/*
	 * Read in MP3
	 */
	FRESULT Res = 1; // init to fail
	UINT fileSize = 0;

	Res = mp3Read((char*)fileName,printMeme, &fileSize);
	if( !Res ){
		// Init MP3 Decoding

		struct buffer buffer;
		struct mad_decoder decoder;
		int result;

		/* initialize our private message structure */

		buffer.start  = printMeme;
		buffer.length = fileSize;

		xil_printf("Reading mp3 file with size %d\r\n", fileSize);

		/* configure input, output, and error functions */

		xil_printf("Initializing decoder\r\n");

		mad_decoder_init(&decoder, &buffer,
				input, 0 /* header */, 0 /* filter */, output,
				error, 0 /* message */);

		/* start decoding */

		xil_printf("Starting decoder\r\n");

		result = mad_decoder_run(&decoder, MAD_DECODER_MODE_SYNC);
		if(result == -1) {
			xil_printf("ERROR mad_decoder_run returned -1\r\n");
		}

		/* release the decoder */

		xil_printf("Releasing decoder\r\n");

		mad_decoder_finish(&decoder);
	}

    for (;;) {
    	xil_printf("MP3Accelerator Idle\r\n");
    	vTaskDelay(1000);
    }
}

void RunTasks()
{
    /*
     * Start the two tasks as described in the comments at the top of this
     * file.
     */
    xTaskCreate (sample_task,                        /* The function that implements the task. */
                "Sample",                        /* The text name assigned to the task - for debug only as it is not used by the kernel. */
                100000,            /* The size of the stack to allocate to the task. */
                NULL,                                /* The parameter passed to the task - not used in this case. */
                1,                                   /* The priority assigned to the task. */
                NULL);                              /* The task handle is not required, so NULL is passed. */

    /* Start the tasks and timer running. */
    vTaskStartScheduler();

    for (;;);
}

int main(void)
{

	prvSetupHardware();

    RunTasks();

    return 0;
}

static void prvSetupHardware(void)
{
    BaseType_t xStatus;
    XScuGic_Config *pxGICConfig;

    /*
     * Ensure no interrupts execute while the scheduler is in an inconsistent
     * state.  Interrupts are automatically enabled when the scheduler is
     * started.
     */
    portDISABLE_INTERRUPTS();

    /* Obtain the configuration of the GIC. */
    pxGICConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);

    /*
     * Sanity check the FreeRTOSConfig.h settings are correct for the
     * hardware.
     */
    configASSERT(pxGICConfig);
    configASSERT(pxGICConfig->CpuBaseAddress == (configINTERRUPT_CONTROLLER_BASE_ADDRESS + configINTERRUPT_CONTROLLER_CPU_INTERFACE_OFFSET));
    configASSERT(pxGICConfig->DistBaseAddress == configINTERRUPT_CONTROLLER_BASE_ADDRESS);

    /* Install a default handler for each GIC interrupt. */
    xStatus = XScuGic_CfgInitialize(&xInterruptController, pxGICConfig, pxGICConfig->CpuBaseAddress);
    configASSERT(xStatus == XST_SUCCESS);

    /* Remove compiler warning if configASSERT() is not defined. */
    (void) xStatus;

    /*
     * The Xilinx projects use a BSP that do not allow the start up code to be
     * altered easily.  Therefore the vector table used by FreeRTOS is defined
     * in FreeRTOS_asm_vectors.S, which is part of this project. Switch to use
     * the FreeRTOS vector table.
     */
    vPortInstallFreeRTOSVectorTable();
}

void vApplicationMallocFailedHook(void)
{
    /*
     * Called if a call to pvPortMalloc() fails because there is insufficient
     * free memory available in the FreeRTOS heap.  pvPortMalloc() is called
     * internally by FreeRTOS API functions that create tasks, queues, software
     * timers, and semaphores.  The size of the FreeRTOS heap is set by the
     * configTOTAL_HEAP_SIZE configuration constant in FreeRTOSConfig.h.
     */
    taskDISABLE_INTERRUPTS();
    for(;;);
}

void vApplicationStackOverflowHook(TaskHandle_t pxTask, char *pcTaskName)
{
    (void) pcTaskName;
    (void) pxTask;

    /*
     * Run time stack overflow checking is performed if
     * configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
     * function is called if a stack overflow is detected.
     */
    taskDISABLE_INTERRUPTS();
    for(;;);
}

void vApplicationIdleHook(void)
{
    volatile size_t xFreeHeapSpace;

    /*
     * This is just a trivial example of an idle hook. It is called on each
     * cycle of the idle task. It must *NOT* attempt to block. In this case
     * the idle task just queries the amount of FreeRTOS heap that remains. See
     * the memory management section on the http://www.FreeRTOS.org web site for
     * memory management options. If there is a lot of heap memory free then the
     * configTOTAL_HEAP_SIZE value in FreeRTOSConfig.h can be reduced to free up
     * RAM.
     */
    xFreeHeapSpace = xPortGetFreeHeapSize();

    /* Remove compiler warning about xFreeHeapSpace being set but never used. */
    (void) xFreeHeapSpace;
}

void vAssertCalled(const char *pcFile, unsigned long ulLine)
{
    volatile unsigned long ul = 0;

    (void) pcFile;
    (void) ulLine;

    taskENTER_CRITICAL();
    {
        /*
         * Set ul to a non-zero value using the debugger to step out of this
         * function.
         */
        while (ul == 0)
        {
            portNOP();
        }
    }
    taskEXIT_CRITICAL();
}

void vApplicationTickHook(void)
{ }

void *memcpy(void *pvDest, const void *pvSource, size_t xBytes)
{
    /*
     * The compiler used during development seems to err unless these volatiles
     * are included at -O3 optimisation.
     */
    volatile unsigned char *pcDest = (volatile unsigned char *) pvDest, *pcSource = (volatile unsigned char *) pvSource;
    size_t x;

    /*
     * Extremely crude standard library implementations in lieu of having a C
     * library.
     */
    if (pvDest != pvSource) {
        for (x = 0; x < xBytes; x++) {
            pcDest[x] = pcSource[x];
        }
    }

    return pvDest;
}

void *memset(void *pvDest, int iValue, size_t xBytes)
{
    /*
     * The compiler used during development seems to err unless these volatiles
     * are included at -O3 optimisation.
     */
    volatile unsigned char * volatile pcDest = (volatile unsigned char * volatile) pvDest;
    volatile size_t x;

    /*
     * Extremely crude standard library implementations in lieu of having a C
     * library.
     */
    for (x = 0; x < xBytes; x++) {
        pcDest[x] = (unsigned char)iValue;
    }

    return pvDest;
}

int memcmp (const void *pvMem1, const void *pvMem2, size_t xBytes)
{
    const volatile unsigned char *pucMem1 = pvMem1, *pucMem2 = pvMem2;
    volatile size_t x;

    /*
     * Extremely crude standard library implementations in lieu of having a C
     * library.
     */
    for (x = 0; x < xBytes; x++) {
        if (pucMem1[x] != pucMem2[x]) {
            break;
        }
    }

    return xBytes - x;
}

void vInitialiseTimerForRunTimeStats(void)
{
    XScuWdt_Config *pxWatchDogInstance;
    uint32_t ulValue;
    const uint32_t ulMaxDivisor = 0xff, ulDivisorShift = 0x08;

    pxWatchDogInstance = XScuWdt_LookupConfig(XPAR_SCUWDT_0_DEVICE_ID);
    XScuWdt_CfgInitialize(&xWatchDogInstance, pxWatchDogInstance, pxWatchDogInstance->BaseAddr);

    ulValue = XScuWdt_GetControlReg(&xWatchDogInstance);
    ulValue |= ulMaxDivisor << ulDivisorShift;
    XScuWdt_SetControlReg(&xWatchDogInstance, ulValue);

    XScuWdt_LoadWdt(&xWatchDogInstance, UINT_MAX);
    XScuWdt_SetTimerMode(&xWatchDogInstance);
    XScuWdt_Start(&xWatchDogInstance);
}

