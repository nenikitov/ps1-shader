SHADER_NAME="PS1"

OUTPUT="./${SHADER_NAME}.zip"

zip -r "${OUTPUT}" "./shaders"
cp -f "${OUTPUT}" "${HOME}/.minecraft/shaderpacks/"
rm "${OUTPUT}"
