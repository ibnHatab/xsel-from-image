#!/bin/bash -x

# title: Describe selected image
# license: MIT license

BIN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PATH=$PATH:$BIN_DIR

TMPFILE=$(mktemp -p /tmp)

cd $BIN_DIR/..

scrot -s  '/tmp/%F_%T_$wx$h.png' -e 'llava-cli -m models/ggml-model-q5_k.gguf --mmproj models/mmproj-model-f16.gguf -p "Describe image artistic style and scene settings" --image $f --verbose-prompt --top-p 160 --mirostat 2' 2>/dev/null | tee $TMPFILE

cat $TMPFILE | tail -12 | grep -ve 'llama_print_timing\|clip_model_load\|encode_image_with_clip' | sed '/^[[:space:]]*$/d' |xclip

rm -f $TMPFILE
echo '-----------------------------------------------------------------------------'
xsel
echo '-----------------------------------------------------------------------------'
