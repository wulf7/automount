/*
 * Copyright (c) 2015 Vladimir Kondratiev <wulf@cicgroup.ru>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that following conditions are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS 'AS IS' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <stdlib.h>

#include <libmtp.h>

int
main (int argc, char **argv)
{
	LIBMTP_raw_device_t *rawdevs;
	int nrawdevs;
	int i, ret, bus, dev;

	if (argc < 2) {
		fprintf(stderr, "usage: simple-mptfs-probe path-to-device\n");
		return 1;
	}

	if (sscanf(argv[1], "/dev/ugen%d.%d", &bus, &dev) != 2) {
		fprintf(stderr, "No valid devices found\n");
		return 1;
	}

	LIBMTP_Init();

	fclose(stderr);	/* Quiet libmtp */
	ret = 1;

	if (LIBMTP_Detect_Raw_Devices(&rawdevs, &nrawdevs) ==
	    LIBMTP_ERROR_NONE) {

		for (i = 0; i < nrawdevs; i++) {
			if (bus != rawdevs[i].bus_location ||
			    dev != rawdevs[i].devnum)
				continue;
			fprintf (stdout, "%d: %s %s\n", i+1,
			    rawdevs[i].device_entry.vendor != NULL ?
				 rawdevs[i].device_entry.vendor :
				"Unknown vendor",
			    rawdevs[i].device_entry.product != NULL ?
				rawdevs[i].device_entry.product :
				"Unknown product"
			);
			ret = 0;
		}
		free(rawdevs);
	}

	return ret;
}
