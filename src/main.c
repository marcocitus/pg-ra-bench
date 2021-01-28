/*
 * src/main.c
 *    Main entry point for the program
 *
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the PostgreSQL License.
 *
 */
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

static int
RandomInt(int min, int max)
{
	return min + (rand() % (max - min));
}

static double
RandomDouble(double min, double max)
{
	double scale = rand() / (double) RAND_MAX;
	return min + scale * ( max - min );
}

/*
 * Main entry point for the binary.
 */
int
main(int argc, char **argv)
{
	for (int i = 0; i < 100000; i++)
	{
		printf("%d,%d,%d,%d,%.3f,%.3f,%.3f\n",
				RandomInt(1,10),
				RandomInt(1,100),
				RandomInt(1,1000),
				RandomInt(1,10000),
				RandomDouble(0.1,100.),
				RandomDouble(0.1,100.),
				RandomDouble(0.1,100.));
	}

	return 0;
}
