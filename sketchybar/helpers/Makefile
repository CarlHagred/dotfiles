# Builds the native helper used by the SketchyBar scripts (needs the Xcode Command Line Tools).
#   make          build bin/sbhelper (rebuilt only when the source changes)
#   make clean    remove the build output

.PHONY: all clean

all: bin/sbhelper

bin/sbhelper: sbhelper.swift
	mkdir -p bin
	swiftc -O sbhelper.swift -o bin/sbhelper

clean:
	rm -rf bin
