-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

local topWidget = nil;
local tabIndex = 1;
local tabWidgets = {};

function getIndex()
	return tabIndex;
end

function activateTab(index)
	-- Hide active tab, fade text labels
	tabWidgets[tabIndex].setColor("80ffffff");
	window[tab[tabIndex].subwindow[1]].setVisible(false);
	if tab[tabIndex].scroller then
    if tab[tabIndex].scroller[1] then
      if window[tab[tabIndex].scroller[1]] then
    		window[tab[tabIndex].scroller[1]].setVisible(false);
    	end
	 end
	end

	-- Set new index
	tabIndex = tonumber(index);

	-- Move helper graphic into position
	topWidget.setPosition("topleft", 13, 67*(tabIndex-1)+58);
	topWidget.setVisible(true);

	
	-- Activate text label and subwindow
	tabWidgets[tabIndex].setColor("ffffffff");

	window[tab[tabIndex].subwindow[1]].setVisible(true);
	if tab[tabIndex].scroller then
      if window[tab[tabIndex].scroller[1]] then
        window[tab[tabIndex].scroller[1]].setVisible(true);
      end
	end
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	local i = math.ceil((y-15)/67);
	
	-- Make sure index is in range and activate selected
	if i > 0 and i < #tab+1 and x >= 7 then
		activateTab(i);
	end
	
	return true;
end

function onDoubleClick(x, y)
	-- Emulate click
	onClickRelease(1, x, y);
end

function onInit()
	-- Create a helper graphic widget to indicate that the selected tab is on top
	topWidget = addBitmapWidget("tabtopchar");

	-- Deactivate all labels	
	for n, v in ipairs(tab) do
		tabWidgets[n] = addBitmapWidget(v.icon[1]);
		tabWidgets[n].setPosition("topleft", 12, 67*(n-1)+51);
		tabWidgets[n].setColor("80ffffff");
	end

	if activate then
		activateTab(activate[1]);
	else
		activateTab(1);
	end
end
