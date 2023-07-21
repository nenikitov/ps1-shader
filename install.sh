SHADER_NAME="PS1"

OUTPUT="./${SHADER_NAME}.zip"

zip "${OUTPUT}" "./shaders"
cp "${OUTPUT}" "${HOME}/.minecraft/shaderpacks/"
rm "${OUTPUT}"
