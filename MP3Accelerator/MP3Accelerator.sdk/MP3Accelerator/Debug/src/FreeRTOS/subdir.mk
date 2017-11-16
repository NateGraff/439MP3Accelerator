################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/FreeRTOS/FreeRTOS_tick_config.c \
../src/FreeRTOS/croutine.c \
../src/FreeRTOS/event_groups.c \
../src/FreeRTOS/heap_4.c \
../src/FreeRTOS/list.c \
../src/FreeRTOS/platform.c \
../src/FreeRTOS/port.c \
../src/FreeRTOS/queue.c \
../src/FreeRTOS/tasks.c \
../src/FreeRTOS/timer_ps.c \
../src/FreeRTOS/timers.c 

S_UPPER_SRCS += \
../src/FreeRTOS/FreeRTOS_asm_vectors.S \
../src/FreeRTOS/portASM.S 

OBJS += \
./src/FreeRTOS/FreeRTOS_asm_vectors.o \
./src/FreeRTOS/FreeRTOS_tick_config.o \
./src/FreeRTOS/croutine.o \
./src/FreeRTOS/event_groups.o \
./src/FreeRTOS/heap_4.o \
./src/FreeRTOS/list.o \
./src/FreeRTOS/platform.o \
./src/FreeRTOS/port.o \
./src/FreeRTOS/portASM.o \
./src/FreeRTOS/queue.o \
./src/FreeRTOS/tasks.o \
./src/FreeRTOS/timer_ps.o \
./src/FreeRTOS/timers.o 

S_UPPER_DEPS += \
./src/FreeRTOS/FreeRTOS_asm_vectors.d \
./src/FreeRTOS/portASM.d 

C_DEPS += \
./src/FreeRTOS/FreeRTOS_tick_config.d \
./src/FreeRTOS/croutine.d \
./src/FreeRTOS/event_groups.d \
./src/FreeRTOS/heap_4.d \
./src/FreeRTOS/list.d \
./src/FreeRTOS/platform.d \
./src/FreeRTOS/port.d \
./src/FreeRTOS/queue.d \
./src/FreeRTOS/tasks.d \
./src/FreeRTOS/timer_ps.d \
./src/FreeRTOS/timers.d 


# Each subdirectory must supply rules for building sources it contributes
src/FreeRTOS/%.o: ../src/FreeRTOS/%.S
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../standalone_bsp_0/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/FreeRTOS/%.o: ../src/FreeRTOS/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -I../../standalone_bsp_0/ps7_cortexa9_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


