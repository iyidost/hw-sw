#include <stdio.h>
#include <lc3io.h>

#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
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

		// Display fancy bar
		bar_val = (steer_val / 25) + 10;
		printf("[");
		for (i = 0; i <= 20; i++)
		{
			if (i == bar_val)
				printf("*");
			else
				printf(" ");
		}
		printf("] (%d)\n", steer_val);

		//printf("Steering Wheel Output: %d (%d,0x%x)\n\n", steer_val, steer_status, steer_status);
    }
    return 0;
}