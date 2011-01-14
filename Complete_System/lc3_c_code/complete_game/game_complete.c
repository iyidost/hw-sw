#include <stdio.h>
#include <lc3io.h>

#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
#define VGA_CAR_X	  			0xfe1cu
#define VGA_OBSTACLES_START_X	0xfe1eu
#define VGA_OBSTACLES_START_Y	0xfe20u

#define SCREEN_WIDTH			640
#define SCREEN_HEIGHT			480

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
	short i;

	reset_game();

    // Main game loop
    while (1)
    {
    	switch (game_state)
    	{
			case GAME_STATE_IN_GAME:
			{
				// Update steering wheel
				steering_wheel_update();

				if (slowDownCounter > 500)
				{
					// Update obstacle(s)
					/*printf("Shown obstacles: %d (Counter: %d)\n", shown_obstacles, slowDownObstaclesCounter);
					for (i = 0; i < OBSTACLES_COUNT; i++)
					{
						printf("Obstacle #%d (%d,%d %d,%d)\n", (i + 1), obstacles[i].x, obstacles[i].y, obstacles[i].width, obstacles[i].height);
					}

					printf("\n\n");*/

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

					game_state = GAME_STATE_IN_GAME;
				}
				else
				{
					slowDownCounter++;
				}
				break;
    	}
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
	car.x = (steer_val + 255);
	car.x += (SCREEN_WIDTH / 2 - 510 / 2) / 2;

	// Write car position to VGA
	io_write(VGA_CAR_X, car.x);
}

void obstacle_update()
{
	short i;

	for (i = 0; i < shown_obstacles; i++)
	{
		obstacles[i].y += 5;

		if (obstacles[i].y >= SCREEN_HEIGHT)
		{
			obstacles[i].x = car.x;
			obstacles[i].y = 0;
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

	return 1;
}

void reset_game()
{
	short i;

	shown_obstacles = 1;
	velocity = 350;
	slowDownObstaclesCounter = 0;
	slowDownCounter = 0;

	car.x = 0;
	car.y = 364;
	car.width = CAR_WIDTH;
	car.height = CAR_HEIGHT;

	// Write obstacle positions
	for (i = 0; i < OBSTACLES_COUNT; i++)
	{
		obstacles[i].x = 0;
		obstacles[i].y = (i == 0) ? 0 : SCREEN_HEIGHT + 350;
		obstacles[i].width = (i == 0) ? CAR_WIDTH : 48;
		obstacles[i].height = (i == 0) ? CAR_HEIGHT : 48;

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
