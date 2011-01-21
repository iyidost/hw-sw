#include <stdio.h>
#include <lc3io.h>

// Registers
#define STEER_S	  				0xfe18u
#define STEER_D	  				0xfe1au
#define VGA_CAR_Y	  			0xfe1cu
#define VGA_OBSTACLES_START_X	0xfe1eu
#define VGA_OBSTACLES_START_Y	0xfe20u
#define VIBRATOR				0xfe2cu
#define VGA_REFRESH_TICK		0xfe2au
#define ROAD_MOVE				0xfe30u

// Useful sizes
#define SCREEN_WIDTH			480
#define SCREEN_HEIGHT			640

#define SIZEOF_SIGNED_SHORT		32767
#define SIZEOF_UNSIGNED_SHORT	65535

#define GAME_STATE_IN_GAME		0x00
#define GAME_STATE_GAME_OVER	0x01

#define OBSTACLES_COUNT			3

// The car and each obstacle is defined as an OBJECT
typedef struct {
	// Defines basic properties for the object used when drawing
	short x, y, width, height;

	// Delta values are used for more precise collision detection,
	// the values are more precise locations for the collision
	// bounding boxes.
	short deltaTop, deltaRight, deltaBottom, deltaLeft;
} OBJECT;

// Define car and obstacles
OBJECT car;
OBJECT obstacles[3];

// Number of obstacles currently shown on the screen
short shown_obstacles;

// The y position of the next spawning obstacle (constantly changing)
short obstaclePos = 0;

// How many times the first obstacle has left the screen
short obstacle_spawns = 0;

// The number of ticks to wait for each iteration of the main loop
// the higher the value, the slower the obstacles move
unsigned int velocity = 1000u;

// The value of each velocity decremental when all obstacles are shown
// this value is increased until the player crashes
unsigned int velocityDelta = 4u;

// Keeps track of the points earned by the player
unsigned int points = 0;

// Function prototypes
void sleep(unsigned int ticks, unsigned int multiplier);
void steering_wheel_update();
void obstacle_update();
int does_collide(OBJECT A, OBJECT B);
void reset_game();
void set_obstacle_pos(OBJECT object, short obstacle);

// Sleep for (ticks * multiplier) VGA REFRESH ticks
void sleep(unsigned int ticks, unsigned int multiplier)
{
	unsigned short i, m;
	short data;

	for (m = 0; m < multiplier; m++)
	{
		for (i = 0; i < ticks; i++)
		{
			do
			{
				data = io_read(VGA_REFRESH_TICK);
			}
			while (data != 1);
			io_write(VGA_REFRESH_TICK, 0);
		}
	}
}

// Main method
int main()
{
	short game_state = GAME_STATE_IN_GAME; // Current game state
	short roadMove = 0; // Used for moving the white road stripes
	short i;

	// Reset game before start
	reset_game();

    // Main game loop
    while (1)
    {
    	// Find pseudo random x position to spawn obstacles
    	obstaclePos++;
    	if (obstaclePos > SCREEN_WIDTH)
    	{
    		obstaclePos = 0;
    	}

    	// Do appropriate actions according to game state
    	switch (game_state)
    	{
			case GAME_STATE_IN_GAME:
			{
				// Move road
				io_write(ROAD_MOVE, roadMove);

				if (roadMove < 192)
				{
					roadMove += 2;
				}
				else
				{
					roadMove = 0;
				}

				// Update steering wheel
				steering_wheel_update();

				// Update obstacle positions
				obstacle_update();

				// Collision detection for all obstacles
				for (i = 0; i < shown_obstacles; i++)
				{
					if (does_collide(car, obstacles[i]) == 1)
					{
						// Car collided with obstacle, game over.
						game_state = GAME_STATE_GAME_OVER;
						printf("%d\n", points);
					}
				}
				break;
			}

			case GAME_STATE_GAME_OVER:
			{
				short inputChar;

				// Vibrator on
				io_write(VIBRATOR, 1);

				// Wait 10000 * 10 ticks
				sleep(10000u, 10);

				// Vibrator off
				io_write(VIBRATOR, 0);

				// Wait until 's' (for start) is received from the high score program
				do
				{
					// Wait until data is received from STDIN
					while (io_read(STDIN_S) != IO_READY);

					inputChar = io_read(STDIN_D);
				}
				while (inputChar != 's');

				// Reset game
				reset_game();

				// Change game state
				game_state = GAME_STATE_IN_GAME;
				break;
			}
    	}

    	// Slow down game
    	sleep(velocity, 1);
    }

    return 0;
}

// Read steering wheel position and move car y position
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

	car.y = (255 * 2) - car.y;

	if (car.y > (SCREEN_WIDTH - car.height))
	{
		car.y = SCREEN_WIDTH - car.height;
	}

	// Write car position to VGA
	io_write(VGA_CAR_Y, car.y);
}

// Update position of all shown obstacles
void obstacle_update()
{
	short i;

	for (i = 0; i < shown_obstacles; i++)
	{
		// Move obstacle one pixel
		obstacles[i].x++;

		// Is obstacle outside screen?
		if (obstacles[i].x >= SCREEN_HEIGHT)
		{
			// Points is given per vehicle which has passed the screen each
			// vehicle gives a number of points according to the number of
			// the vehicle.
			points += (i + 1);

			// Count number of times first obstacle has been all the way through
			// the screen
			if (i == 0)
			{
				obstacle_spawns++;
			}

			// Set the new y position of the obstacle to be within the screen width
			// and reset the x position to zero
			obstacles[i].y = (obstaclePos > (SCREEN_WIDTH - obstacles[i].width)) ? (SCREEN_WIDTH - obstacles[i].width) : obstaclePos;
			obstacles[i].x = 0;
		}

		// Write obstacle position to the LC3 VGA
		set_obstacle_pos(obstacles[i], i);
	}

	// If the first obstacle has been spawned over 5 times and not all
	// obstacles have been shown yet (according to OBSTACLES_COUNT)
	// and the last spawned obstacle's x position is 200 (to prevent
	// collision)
	if (obstacle_spawns > 5 && shown_obstacles < OBSTACLES_COUNT && obstacles[shown_obstacles - 1].x == 200)
	{
		// Reset the number of spawns
		obstacle_spawns = 0;

		// Add one obstacle
		shown_obstacles++;
	}
	else if (obstacle_spawns >= 1 && shown_obstacles >= OBSTACLES_COUNT)
	{
		velocity -= velocityDelta;
		velocityDelta++; // Increase the intensity of the velocity increment
		obstacle_spawns = 0;
	}
}

// Check if A collides with B
// Returns 1 if there is an collision
int does_collide(OBJECT A, OBJECT B)
{
	short leftA, leftB;
	short rightA, rightB;
	short topA, topB;
	short bottomA, bottomB;

	leftA = A.x + A.deltaLeft;
	rightA = A.x + A.width - A.deltaRight;
	topA = A.y + A.deltaTop;
	bottomA = A.y + A.height - A.deltaBottom;

	leftB = B.x + B.deltaLeft;
	rightB = B.x + B.width - B.deltaRight;
	topB = B.y + B.deltaTop;
	bottomB = B.y + B.height - B.deltaBottom;

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

// Reset all variables for the game
void reset_game()
{
	short i;

	// Turn off vibrator
	io_write(VIBRATOR, 0);

	// Global game variables
	obstacle_spawns = 3;
	shown_obstacles = 1;
	velocity = 1000u;
	velocityDelta = 4u;
	points = 0;

	// Car object attributes
	car.x = 530;
	car.y = 0;
	car.width = 96;
	car.height = 64;
	car.deltaTop = 3;
	car.deltaLeft = 4;
	car.deltaRight = 3;
	car.deltaBottom = 8;

	// Obstacle object attributes
	for (i = 0; i < OBSTACLES_COUNT; i++)
	{
		if (i == 0)
		{
			obstacles[i].width = 96;
			obstacles[i].height = 48;
			obstacles[i].deltaTop = 7;
			obstacles[i].deltaLeft = 1;
			obstacles[i].deltaRight = 1;
			obstacles[i].deltaBottom = 9;

		}
		else if (i == 1)
		{
			obstacles[i].width = 96;
			obstacles[i].height = 64;
			obstacles[i].deltaTop = 2;
			obstacles[i].deltaRight = 2;
			obstacles[i].deltaBottom = 3;
			obstacles[i].deltaLeft = 2;
		}
		else
		{
			obstacles[i].width = 144;
			obstacles[i].height = 64;
			obstacles[i].deltaTop = 1;
			obstacles[i].deltaRight = 24;
			obstacles[i].deltaBottom = 0;
			obstacles[i].deltaLeft = 28;
		}

		// Hide from users view
		obstacles[i].x = SCREEN_HEIGHT;
		obstacles[i].y = SCREEN_WIDTH;

		set_obstacle_pos(obstacles[i], i);
	}
}

// Sets the obbstacle no. to the positions defined in object
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
