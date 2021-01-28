# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the PostgreSQL License.

PG_RA_BENCH = ./pg_ra_bench

SRC_DIR := src/

DEPDIR = $(SRC_DIR)/.deps

INCLUDES  = $(patsubst ${SRC_DIR}%.h,%.h,$(wildcard ${SRC_DIR}*.h))

SRC   = $(patsubst ${SRC_DIR}%.c,%.c,$(wildcard ${SRC_DIR}*.c))
OBJS  = $(patsubst %.c,%.o,$(SRC))

PG_CONFIG ?= pg_config
BINDIR    ?= $(shell $(PG_CONFIG) --bindir)

CC = $(shell $(PG_CONFIG) --cc)

DEFAULT_CFLAGS = -std=c99 -D_GNU_SOURCE -g
DEFAULT_CFLAGS += -I $(shell $(PG_CONFIG) --includedir)
DEFAULT_CFLAGS += -I $(shell $(PG_CONFIG) --includedir-server)
DEFAULT_CFLAGS += -I $(shell $(PG_CONFIG) --pkgincludedir)/internal
DEFAULT_CFLAGS += $(shell $(PG_CONFIG) --cflags)
DEFAULT_CFLAGS += -Wformat
DEFAULT_CFLAGS += -Wall
DEFAULT_CFLAGS += -Werror=implicit-int
DEFAULT_CFLAGS += -Werror=implicit-function-declaration
DEFAULT_CFLAGS += -Werror=return-type
DEFAULT_CFLAGS += -Wno-declaration-after-statement

# Needed for OSX
DEFAULT_CFLAGS += -Wno-missing-braces
DEFAULT_CFLAGS += $(COMMON_LIBS)

override CFLAGS := $(DEFAULT_CFLAGS) $(CFLAGS)

LIBS  = -L $(shell $(PG_CONFIG) --pkglibdir)
LIBS += $(shell $(PG_CONFIG) --ldflags)
LIBS += $(shell $(PG_CONFIG) --libs)
LIBS += -lpq

all: $(PG_RA_BENCH) ;

%.o : ${SRC_DIR}%.c
	@if test ! -d $(DEPDIR); then mkdir -p $(DEPDIR); fi
	$(CC) $(CFLAGS) -c -MMD -MP -MF$(DEPDIR)/$(*F).Po -o $@ $<

Po_files := $(wildcard $(DEPDIR)/*.Po)
ifneq (,$(Po_files))
include $(Po_files)
endif


$(PG_RA_BENCH): $(OBJS) $(INCLUDES)
	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) $(LIBS) -o $@

clean:
	rm -f $(OBJS) $(PG_RA_BENCH)
	rm -rf $(DEPDIR)

install: $(PG_RA_BENCH)
	install -d $(DESTDIR)$(BINDIR)
	install -m 0755 $(PG_RA_BENCH) $(DESTDIR)$(BINDIR)

.PHONY: all clean
