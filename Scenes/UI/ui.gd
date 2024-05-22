extends CanvasLayer

func _ready():
	Globals.ui = self


func set_money(money: int):
	$Money/MoneyText.text = "$" + str(money)
