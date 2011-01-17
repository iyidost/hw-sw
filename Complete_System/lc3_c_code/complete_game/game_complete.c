#include <stdio.h>
#include <lc3io.h>

#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
#define VGA_CAR_Y	  			0xfe1cu
#define VGA_OBSTACLES_START_X	0xfe1eu
#define VGA_OBSTACLES_START_Y	0xfe20u
#define VIBRATOR				0xfe2cu
#define VGA_REFRESH_TICK		0xfe2au

#define SCREEN_WIDTH			480
#define SCREEN_HEIGHT			640

#define CAR_WIDTH				64
#define CAR_HEIGHT				96

#define SIZEOF_SIGNED_SHORT		32767
#define SIZEOF_UNSIGNED_SHORT	65535

#define GAME_STATE_IN_GAME		0x00
#define GAME_STATE_GAME_OVER	0x01

#define OBSTACLES_COUNT			3

typedef struct {
   short x, y, width, height;
} OBJECT;

OBJECT car;
OBJECT obstacles[3];
short shown_obstacles;
short velocity = 0;//300;
int slowDownObstaclesCounter = 0;
short slowDownCounter = 0;

void steering_wheel_update();
void obstacle_update();
int does_collide(OBJECT A, OBJECT B);
void reset_game();
void set_obstacle_pos(OBJECT object, short obstacle);

int main()
{
	short game_state = GAME_STATE_IN_GAME;
	short clocks = 0;
	short i;

	//reset_game();

    // Main game loop
    while (1)
    {
    	do
    	{
    		i = io_read(VGA_REFRESH_TICK);
    		//printf("Received: %d 0x%x\n", i, i);
    	}
    	while (i != 1);

    	printf("Tick!\n");

    	/*switch (game_state)
    	{
			case GAME_STATE_IN_GAME:
			{
				// Update steering wheel
				steering_wheel_update();

				if (slowDownCounter > 500)
				{
					obstacle_update();
					slowDownCounter = 0;
					slowDownObstaclesCounter++;
				}
				else
				{
					slowDownCounter++;
				}

				if (slowDownObstaclesCounter > velocity)
				{
					if (shown_obstacles < OBSTACLES_COUNT)
					{
						shown_obstacles++;
					}
					slowDownObstaclesCounter = 0;

					if (velocity > 70)
					{
						velocity -= 50;
					}
					else if (velocity >= 5)
					{
						velocity -= 5;
					}
				}

				for (i = 0; i < shown_obstacles; i++)
				{
					if (does_collide(car, obstacles[i]) == 1)
					{
						// Change game state
						slowDownCounter = 0;
						game_state = GAME_STATE_GAME_OVER;
					}
				}
				break;
			}

			case GAME_STATE_GAME_OVER:
				printf("COLLISION!!\n");

				if (slowDownCounter > 1000)
				{
					for (i = 0; i < shown_obstacles; i++)
					{
						reset_game();
						slowDownCounter = 0;
					}

					io_write(VIBRATOR, 0);
					game_state = GAME_STATE_IN_GAME;
				}
				else
				{
					slowDownCounter++;
				}
				break;
    	}*/
    }
    return 0;
}

void steering_wheel_update()
{
	short steer_val, steer_status = 0;

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
	car.y = (steer_val + 255);
	//car.y += (SCREEN_WIDTH / 2 - 510 / 2) / 2;

	car.y = (255 * 2) - car.y;

	if (car.y > (SCREEN_WIDTH - CAR_WIDTH))
	{
		car.y = SCREEN_WIDTH - CAR_WIDTH;
	}

	// Reverse the value
	//printf("Car.y: %d\n", car.y);

	// Write car position to VGA
	io_write(VGA_CAR_Y, car.y);
}

void obstacle_update()
{
	short i;

	for (i = 0; i < shown_obstacles; i++)
	{
		obstacles[i].x += 5;

		if (obstacles[i].x >= SCREEN_HEIGHT)
		{
			obstacles[i].y = car.y;
			obstacles[i].x = 0;
		}

		set_obstacle_pos(obstacles[i], i);
	}
}

int does_collide(OBJECT A, OBJECT B)
{
	short leftA, leftB;
	short rightA, rightB;
	short topA, topB;
	short bottomA, bottomB;

	leftA = A.x;
	rightA = A.x + A.width;
	topA = A.y;
	bottomA = A.y + A.height;

	leftB = B.x;
	rightB = B.x + B.width;
	topB = B.y;
	bottomB = B.y + B.height;

	if (bottomA <= topB)
	{
		return 0;
	}

	if (topA >= bottomB)
	{
		return 0;
	}

	if (rightA <= leftB)
	{
		return 0;
	}

	if (leftA >= rightB)
	{
		return 0;
	}

	io_write(VIBRATOR, 1);

	return 1;
}

void reset_game()
{
	short i;

	shown_obstacles = 1;
	velocity = 350;
	slowDownObstaclesCounter = 0;
	slowDownCounter = 0;

	car.x = 530;
	car.y = 0;
	car.width = CAR_HEIGHT;
	car.height = CAR_WIDTH;

	// Write obstacle positions
	for (i = 0; i < OBSTACLES_COUNT; i++)
	{
		obstacles[i].x = (i == 0) ? 0 : SCREEN_HEIGHT + 350;
		obstacles[i].y = 0;
		obstacles[i].width = (i == 0) ? CAR_HEIGHT : 64;
		obstacles[i].height = (i == 0) ? CAR_WIDTH : 48;

		set_obstacle_pos(obstacles[i], i);
	}
}

void set_obstacle_pos(OBJECT object, short obstacle)
{
	unsigned int addr_x = 0;
	unsigned int addr_y = 0;

	switch (obstacle)
	{
		case 0:
			addr_x = VGA_OBSTACLES_START_X;
			addr_y = VGA_OBSTACLES_START_Y;
			break;

		case 1:
			addr_x = 0xFE22u;
			addr_y = 0xFE24u;
			break;

		case 2:
			addr_x = 0xFE26u;
			addr_y = 0xFE28u;
			break;
	}

	io_write(addr_x, object.x);
	io_write(addr_y, object.y);
}
