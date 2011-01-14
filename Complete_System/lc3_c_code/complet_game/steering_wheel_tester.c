/*
 * Steering Wheel moves box on screen
 * Thursday 13/1 2011 16:45:42
 * */
#include <stdio.h>
#include <lc3io.h>

#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
#define VGA_CAR_X	  			0xfe1cu
#define VGA_OBSTACLE_X			0xfe1eu
#define VGA_OBSTACLE_Y			0xfe20u

#define SCREEN_WIDTH			640
#define SCREEN_HEIGHT			480

#define CAR_WIDTH				64
#define CAR_HEIGHT				96

#define SIZEOF_SIGNED_SHORT		32767
#define SIZEOF_UNSIGNED_SHORT	65535

int main() {
    short steer_status = 0;
    short steer_val = 0;
    short bar_val = 0;
    short i = 0;
    short st, val = 0;


    unsigned short obstacle_x = 0;
    unsigned short obstacle_y = 0;
    unsigned short velocity = 900;

    unsigned short car_x = 200;

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

		io_write(VGA_CAR_X, steer_val);

		if (i > velocity)
		{
			i = 0;
			obstacle_y++;

			if (obstacle_y > (SCREEN_HEIGHT - CAR_HEIGHT))
			{
				obstacle_x = steer_val;
				obstacle_y = 0;
				if (velocity > 40)
				{
					velocity -= 40;
				}
				else
				{
					velocity = 900;
				}
			}

			io_write(VGA_OBSTACLE_X, obstacle_x);
			io_write(VGA_OBSTACLE_Y, obstacle_y);
		}

		i++;
    }
    return 0;
}
