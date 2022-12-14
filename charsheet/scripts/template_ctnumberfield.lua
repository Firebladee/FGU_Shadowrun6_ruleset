-- 
-- Please see the readme.txt file included with this distribution for 
-- attribution and copyright information.
--

locked = false;
linknode = nil;

function onInit()
	if super.onInit then
		super.onInit();
	end

	if self.update then
		self.update();
	end
end

function onDrop(x, y, draginfo)
	if Session.IsHost then
		if draginfo.getType() ~= "number" then
			return false;
		end

		if self.handleDrop then
			self.handleDrop(draginfo);
			return true;
		end
	end
end

function onValueChanged()
	if self.update then
		self.update();
	end

	if linknode and not isReadOnly() then
		if not locked then
			locked = true;
			linknode.setValue(getValue());
			locked = false;
		end
	end

end

function onLinkUpdated(source)
	if source then
		if not locked then
			locked = true;
			setValue(source.getValue());
			locked = false;
		end
	end

	if self.update then
		self.update();
	end
end

function setLink(dbnode, readonly)
	if dbnode then
		linknode = dbnode;
		linknode.onUpdate = onLinkUpdated;

		if readonly then
			addBitmapWidget("indicator_linked").setPosition("bottomright", 0, -3);
		else
			addBitmapWidget("indicator_linked").setPosition("bottomright", -5, -5);
		end
		
		if readonly == true then
			setReadOnly(true);
		end

		onLinkUpdated(linknode);
	end
end

