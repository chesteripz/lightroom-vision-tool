#!/usr/bin/env bash
echo Building Binary
./build.sh

echo Copying Lightroom plugin
cp -R LRImageClassifier/LRImageClassifier.lrdevplugin LRImageClassifier.lrplugin

echo Packing archive
cp .build/apple/Products/Release/lightroom-core-ml-cli ./vision-tool
tar -cJf lrimageclassifier.txz LRImageClassifier.lrplugin ./vision-tool

echo Cleaning up
rm -rf ./LRImageClassifier.lrplugin
rm ./vision-tool

echo Complete
echo output: `pwd`/lrimageclassifier.txz
