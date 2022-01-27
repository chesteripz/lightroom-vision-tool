# #!/usr/bin/env bash
echo "Downloading package"
curl https://lrimageclassifier.chesterip.cc/bin/lrimageclassifier-full.txz -o ./lrimageclassifier-full.txz

echo "Decompressing package"
tar -xJf lrimageclassifier-full.txz
rm ./lrimageclassifier-full.txz

echo "Installing package"
sudo mv vision-tool /usr/local/bin/vision-tool
chmod +x /usr/local/bin/vision-tool

mv LRImageClassifier.lrplugin "$HOME/Library/Application Support/Adobe/Lightroom/Modules"
