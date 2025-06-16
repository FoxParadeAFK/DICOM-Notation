extends Node3D

# RenderImage(file, valueInformation)

# func RenderImage(file : String, valueInformation : Dictionary[String, Variant]) -> void:
# 	var pixelData : FileAccess = FileAccess.open("%s/%s" % [rawPath, file.replace(".dcm", ".raw")], FileAccess.READ)
# 	var bytes : PackedByteArray
# 	while pixelData.get_position() < pixelData.get_length():
# 		#TODO - double check the VR parsing for multiple values I don't particularly like the need for [0] 
# 		var byte : int = round(pixelData.get_16() / (valueInformation["Largest Image Pixel Value"][0] / 256))
# 		bytes.append(byte)

# 	#TODO - double check the VR parsing for multiple values I don't particularly like the need for [0] 
# 	Image.create_from_data(valueInformation["Columns"][0], valueInformation["Rows"][0], false, Image.FORMAT_R8, bytes).save_png("%s/%s" % [pngPath, file.replace(".dcm", ".png")])

# func _ready() -> void:
# 	var imagePaths : Array = ReadDirectory(pngPath, ".png")
# 	for index in range(len(imagePaths)):
# 		var image : Image = Image.new()
# 		var error = image.load("%s/%s" % [pngPath, imagePaths[index]])
# 		if error != OK: continue

# 		var renderer : Sprite3D = Sprite3D.new()

# 		renderer.texture = ImageTexture.create_from_image(image)
# 		renderer.modulate.a = 0.1
# 		renderer.position.z = -renderer.pixel_size * index
# 		add_child(renderer)