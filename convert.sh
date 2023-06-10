mkdir zicklein-conversion && cd zicklein-conversion
python -m venv venv
source venv/bin/activate
pip install -r ../requirements.txt

git clone https://huggingface.co/decapoda-research/llama-7b-hf
git clone https://github.com/avocardio/Zicklein
cd Zicklein
git checkout 6a15e1314300089dd934ba18e0f2339c3a6f4cdb

# load LLaMA with alpaca-lora-7b-german-base-52k lora locally and export the consolidated model
git apply ../../export_state_dict_checkpoint.py.patch
python export_state_dict_checkpoint.py
cd ..

# prepare output model dir (copy config and tokenizer)
mkdir zicklein-ggml-output
cp Zicklein/ckpt/params.json llama-7b-hf/*.json llama-7b-hf/tokenizer.model zicklein-ggml-output
rm zicklein-ggml-models/pytorch_model.bin.index.json

git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
git checkout 4de0334f5cabf4696eced2e5d6e279fdfaa6c0f2
pip install requirements.txt
# convert the consolidated hf model into a ggml model
python convert.py ../Zicklein/ckpt/ --vocab-dir ../llama-7b-hf --outfile ../zicklein-ggml-output/ggml-model-f16.bin
