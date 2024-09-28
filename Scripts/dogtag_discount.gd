extends Dogtag


func apply_upgrade():
	super.apply_upgrade()
	for option in Globals.upgrade_menu.options:
		option.calculate_price()
