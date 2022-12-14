--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

local topWidget = nil;
local tabIndex = 1;
local tabWidgets = {};
local count = 0;

local aTabs = {};

local aTabOffset = { 7, 41 };
local aHelperOffset = { 8, 7 };
local nTabWidth = 67;
local nMargins = 25;

function onInit()
	-- Create a helper graphic widget to indicate that the selected tab is on top
	topWidget = addBitmapWidget("tabtop");
	topWidget.setVisible(false);

	-- Deactivate all labels
	if tab and type(tab) == "table" then
		for n, v in ipairs(tab) do
			if type(v) == "table" then
				setTab(n, v.subwindow[1], v.text[1], v.target[1]);
			end
		end
	end

	if activate then
		activateTab(activate[1]);
	else
		activateTab(1);
	end
end

function hideControls(index)
	if aTabs[index] then
		for _,v in ipairs(aTabs[index].controls) do
			window[v].setVisible(false);
			if window[v].onTabVisChanged then
				window[v].onTabVisChanged(false);
			end
		end
	end
end

function showControls(index)
	if aTabs[index] then
		for _,v in ipairs(aTabs[index].controls) do
			window[v].setVisible(true);
			if window[v].onTabVisChanged then
				window[v].onTabVisChanged(true);
			end
		end
	end
end

function activateTab(index)
	if tabIndex == index then
		return;
	end

	if tabIndex >= 1 and tabIndex <= #aTabs then
		-- Hide active tab, fade text labels
		tabWidgets[tabIndex].setFont("sheetlabelsmall")
		aTabs[tabIndex].widget.setColor("80ffffff");
		hideControls(tabIndex);
	end

	-- Set new index
	tabIndex = tonumber(index);

	-- Move helper graphic into position
	topWidget.setPosition("topleft", (nTabWidth * (tabIndex - 1)) + aHelperOffset[2], aHelperOffset[1] );
	if tabIndex == 1 then
		topWidget.setVisible(false);
	else
		topWidget.setVisible(true);
	end

	if tabIndex >= 1 and tabIndex <= #aTabs then
		-- Activate text label and subwindow
		aTabs[tabIndex].widget.setColor("ffffffff");
		showControls(tabIndex);
	end

	if self.onTabChanged then
		self.onTabChanged(tabIndex);
	end
end

function setTab(index, sSub, sText, sTarget)
	if aTabs[index] then
		if sSub and sGraphic then
			if sSub == aTabs[index].sub and sGraphic == aTabs[index].icon then
				return;
			end
			if index == tabIndex then
				hideControls(tabIndex);
				aTabs[index].sub = sSub;
				aTabs[index].controls = StringManager.split(sSub, ",", true);
			else
				aTabs[index].sub = sSub;
				aTabs[index].controls = StringManager.split(sSub, ",", true);
			end

			aTabs[index].widget.destroy();
			aTabs[index].icon = sGraphic;
			aTabs[index].widget = addBitmapWidget(sGraphic);
			aTabs[index].widget.setPosition("topleft", (nTabWidth * (index - 1)) + aTabOffset[2], aTabOffset[1] );

			if index == tabIndex then
				aTabs[index].widget.setColor("ffffffff");
				showControls(tabIndex);
			else
				aTabs[index].widget.setColor("80ffffff");
			end
		else
			if index == tabIndex then
				hideControls(index);
			end
			aTabs[index].widget.destroy();
			aTabs[index] = nil;
		end
	else
		if sSub and sGraphic then
			local rTab = {};

			rTab.sub = sSub;
			rTab.controls = StringManager.split(sSub, ",", true);

			rTab.icon = sGraphic;
			rTab.widget = addBitmapWidget(sGraphic);
			rTab.widget.setPosition("topleft", (nTabWidth * (index - 1)) + aTabOffset[2], aTabOffset[1]);
			if index == tabIndex then
				rTab.widget.setColor("ffffffff");
			else
				rTab.widget.setColor("80ffffff");
			end

			aTabs[index] = rTab;

			if index == tabIndex then
				showControls(tabIndex);
			end
		end
	end

	local nMax = 0;
	for k,_ in pairs(aTabs) do
		nMax = math.max(k, nMax);
	end
	setAnchoredWidth(nMargins + (nTabWidth * nMax));

	if tabIndex > nMax then
		activateTab(nMax);
	end
end

function getIndex()
	return tabIndex;
end

function onClickDown(button, x, y)
	return true;
end

function onClickRelease(button, x, y)
	local i = math.ceil(y / nTabWidth);

	if i >= 1 and i <= #aTabs then
		activateTab(i);
	end

	return true;
end

function onDoubleClick(x, y)
	-- Emulate click
	onClickRelease(1, x, y);
end
