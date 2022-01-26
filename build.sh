#!/usr/bin/env bash
xcrun swift build -c release --arch arm64 --arch x86_64
ls -lh .build/apple/Products/Release/lightroom-core-ml-cli
lipo -info .build/apple/Products/Release/lightroom-core-ml-cli
