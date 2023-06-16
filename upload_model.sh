#!/bin/sh
git clone https://huggingface.co/nikuya3/alpaca-lora-7b-german-base-51k-ggml
git lfs install
huggingface-cli lfs-enable-largefiles .
cp zicklein-conversion/zicklein-ggml-output/* alpaca-lora-7b-german-base-51k-ggml
cd alpaca-lora-7b-german-base-51k-ggml
git add .
git commit -m $1
git push
