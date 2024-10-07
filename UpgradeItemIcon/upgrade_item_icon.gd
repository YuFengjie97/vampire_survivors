extends MarginContainer


@onready var texture_item: TextureRect = $TextureBorder/TextureItem

var upgrade_key = 'icespear1'
var upgrade_name = 'Ice Spear'

func _ready() -> void:
	if upgrade_key != null:
		texture_item.texture = load(UpgradeDb.UPGRADES[upgrade_key].icon)
