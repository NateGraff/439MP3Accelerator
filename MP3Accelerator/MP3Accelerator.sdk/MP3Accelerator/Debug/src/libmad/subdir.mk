################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/libmad/bit.c \
../src/libmad/decoder.c \
../src/libmad/fixed.c \
../src/libmad/frame.c \
../src/libmad/huffman.c \
../src/libmad/layer12.c \
../src/libmad/layer3.c \
../src/libmad/stream.c \
../src/libmad/synth.c \
../src/libmad/timer.c \
../src/libmad/version.c 

OBJS += \
./src/libmad/bit.o \
./src/libmad/decoder.o \
./src/libmad/fixed.o \
./src/libmad/frame.o \
./src/libmad/huffman.o \
./src/libmad/layer12.o \
./src/libmad/layer3.o \
./src/libmad/stream.o \
./src/libmad/synth.o \
./src/libmad/timer.o \
./src/libmad/version.o 

C_DEPS += \
./src/libmad/bit.d \
./src/libmad/decoder.d \
./src/libmad/fixed.d \
./src/libmad/frame.d \
./src/libmad/huffman.d \
./src/libmad/layer12.d \
./src/libmad/layer3.d \
./src/libmad/stream.d \
./src/libmad/synth.d \
./src/libmad/timer.d \
./src/libmad/version.d 


# Each subdirectory must supply rules for building sources it contributes
src/libmad/%.o: ../src/libmad/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -I../../standalone_bsp_2/ps7_cortexa9_0/include -I"C:\Users\nate\439MP3Accelerator\MP3Accelerator\MP3Accelerator.sdk\MP3Accelerator\src\SD" -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


