-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false;
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID, bOptionID = ItemManager.getIDState(nodeRecord);
	
	local sType = type.getValue();
	local bWeapon = (sType == "Weapon");
	local bArmor = (sType == "Armor");

  	
	local bSection1 = false;
	if bOptionID and Session.IsHost then
		if updateControl("nonid_name", bReadOnly, true) then bSection1 = true; end;
	else
		updateControl("nonid_name", false);
	end
	if bOptionID and (Session.IsHost or not bID) then
		if updateControl("nonidentified", bReadOnly, true) then bSection1 = true; end;
	else
		updateControl("nonidentified", false);
	end

	local bSection2 = false;
	if updateControl("type", bReadOnly, bID) then bSection2 = true; end
  if updateControl("subtype", bReadOnly, bID) then bSection2 = true; end
  if updateControl("category", bReadOnly, bID) then bSection2 = true; end
	
	local bSection3 = false;
	if updateControl("cost", bReadOnly, bID) then bSection3 = true; end
	if updateControl("availability", bReadOnly, bID) then bSection3 = true; end
  if updateControl("restricted", bReadOnly, bID) then bSection3 = true; end
	
	local bSection4 = false;
	if updateControl("damage", bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl("damagetype", bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl("reach", bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl("damagestrength", bReadOnly, bID and bWeapon) then bSection4 = true; end
  if updateControl("ap", bReadOnly, bID and bWeapon) then bSection4 = true; end
  if updateControl("recoil", bReadOnly, bID and bWeapon) then bSection4 = true; end
  if updateControl("ammo", bReadOnly, bID and bWeapon) then bSection4 = true; end
  if updateControl("ammotype", bReadOnly, bID and bWeapon) then bSection4 = true; end
  if updateControl("mode", bReadOnly, bID and bWeapon) then bSection4 = true; end
	
	if updateControl("ballisticrating", bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl("impactrating", bReadOnly, bID and bArmor) then bSection4 = true; end

	if updateControl("properties", bReadOnly, bID and (bWeapon or bArmor)) then bSection4 = true; end
	
	local bSection5 = false;
	
	local bSection6 = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);
	
	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
end
