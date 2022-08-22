-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local nodename = getDatabaseNode().getParent().getParent().getName();
	registerMenuItem("Add Modifier", "pointer", 8);
	-- Build our own delete item menu and Add Modifier
	toggleDetail();
end	


function toggleDetail()
	local status = activatefokusdetail.getValue();

	-- Show the power details
	fokusdescription.setVisible(status);
end


					
