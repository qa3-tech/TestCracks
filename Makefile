NAME     := testcracks
VERSION  ?= 0.0.0

CC       := gcc
CFLAGS   := -std=c99 -Wall -Wextra -pedantic -Wno-missing-field-initializers -g
LDFLAGS  := -lm

SRC_DIR  := src
INC_DIR  := include
EX_DIR   := examples
BUILD    := build

SRCS     := $(wildcard $(SRC_DIR)/*.c)
OBJS     := $(SRCS:$(SRC_DIR)/%.c=$(BUILD)/%.o)
EXAMPLES := $(wildcard $(EX_DIR)/*.c)
BINS     := $(EXAMPLES:$(EX_DIR)/%.c=$(BUILD)/%)

DIST_NAME := $(NAME)-$(VERSION)
DIST_FILES := $(INC_DIR) $(SRC_DIR) $(EX_DIR) Makefile README.adoc LICENSE

.PHONY: all clean test dist

all: $(BINS)

$(BUILD):
	mkdir -p $(BUILD)

$(BUILD)/%.o: $(SRC_DIR)/%.c | $(BUILD)
	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@

$(BUILD)/%: $(EX_DIR)/%.c $(OBJS) | $(BUILD)
	$(CC) $(CFLAGS) -I$(INC_DIR) $< $(OBJS) $(LDFLAGS) -o $@

test: $(BUILD)/sample_tests
	@echo "=== Running tests ==="
	@$(BUILD)/sample_tests

clean:
	rm -rf $(BUILD) $(DIST_NAME) $(DIST_NAME).tar.xz

dist: clean
	mkdir -p $(DIST_NAME)
	cp -r $(DIST_FILES) $(DIST_NAME)/
	tar -cJf $(DIST_NAME).tar.xz $(DIST_NAME)
	rm -rf $(DIST_NAME)
	@echo "Created $(DIST_NAME).tar.xz"
