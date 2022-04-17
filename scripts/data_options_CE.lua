-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	OptionsManager.registerOption2("CE_RTET", true, "option_header_ce", "option_label_CE_RTET", "option_entry_cycler", 
			{ labels = "option_val_yes", values = "on", baselabel = "option_val_no", baseval = "off", default = "on" });
end