/*
 * Steering Wheel moves box on screen
 * Thursday 13/1 2011 16:45:42
 * */
#include <stdio.h>
#include <lc3io.h>

#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
#define VGA_CAR_X	  			0xfe1cu
#define SCREEN_WIDTH			640
#define CAR_WIDTH				64
#define SIZEOF_SIGNED_SHORT		32767
#define SIZEOF_UNSIGNED_SHORT	65535

int main() {
    short steer_status = 0;
    short steer_val = 0;
    short bar_val = 0;
    short i = 0;

    // This line MUST be present
    printf("Steering Wheel Tester");

    while (1)
    {
		// Poll for steering wheel position update
		do
		{
			steer_status = io_read(STEER_S);
		}
		while (steer_status == IO_READY);

		// Receive steering wheel position data
		steer_val = io_read(STEER_D);

		// Normalize value
		if (steer_val < 0)
		{
			steer_val = -(SIZEOF_SIGNED_SHORT + steer_val);
		}
		else
		{
			steer_val = SIZEOF_SIGNED_SHORT - steer_val;
		}

		// The value is now containing a value around -32768 to +32768 (signed short)
		// divide by 128 to reduce the area to -255 to +255
		steer_val /= 128;

		// Change value from -255 -> +255 to pixels on the horizontal axis on the screen
		steer_val = (steer_val + 255);
		steer_val += (SCREEN_WIDTH / 2 - 510 / 2) / 2;

		printf("Steering wheel x pos: %d\n", steer_val);

		// Write x position to the VGA_CAR_X register
		io_write(VGA_CAR_X, steer_val);
    }
    return 0;
}
