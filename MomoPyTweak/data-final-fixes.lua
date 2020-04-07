require("prototypes.final-fixed-science-pack-subgroup")
require("prototypes.final-fixed-technogies")
require("prototypes.final-fixed-military")
require("prototypes.final-fixed-electronics-subgroup")
require("prototypes.final-fixed-subgroup")
require("prototypes.final-fixed-assembler")
require("prototypes.armor")

if not (momoPyTweak.DumpOnly) then
	momoPyTweak.finalFixes.MoveSciencePackSubgroup()
	momoPyTweak.finalFixes.ElectronicsSubgroup()
	momoPyTweak.finalFixes.Technogies()
	momoPyTweak.finalFixes.Military()
	momoPyTweak.finalFixes.AddUtilitySciencePackToTechnology()
	
	-- temp fix energy cost
	momoPyTweak.finalFixes.GlassWorkEnergyCost()
	
	-- rearrangement subgroup
	momoPyTweak.finalFixes.PyanodonPleaseFixThatSubgroup()
	
	if (momoPyTweak.mods.alienTech) then
		momoPyTweak.compatibility.SchallUraniumMining()
	end
	
	momoPyTweak.ArmorInventory()
else
	momoIRTweak.DumpTechnologies()
	momoIRTweak.DumpRecipes()
end