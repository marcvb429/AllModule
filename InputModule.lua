-- This is used for Love2D

assert(love, "No LOVE module!")

local InputModule = {}
InputModule.__index = InputModule
InputModule.Inputs = {} -- 'em inputs

function InputModule.new(ID) -- new Input object
	assert(ID, "ID missing!")
	assert((not InputModule.Inputs[ID]), "Duplicate ID!")
	
	local self = setmetatable({}, InputModule)
	self.Key = nil -- Should be changed			later / Keyboard key. (string)
	self.Triggered = false -- Used for manual triggering.
	self.ID = ID -- SHOULD NOT BE CHANGED. PLEASE. I BEG YOU. for now we don't use this property but still, might be useful, and changing this won't change the ID in the inputs table, so it will be out of sync. so that's why you DON'T change it
	InputModule.Inputs[ID] = self
	return self
end

function InputModule:Activate()
	self.Triggered = true
end

function InputModule:Deactivate()
	self.Triggered = true
end

function InputModule:IsActivated()
	if self.Triggered then return true end
	if self.Key and love.keyboard.isDown(tostring(self.Key)) then return true end
	
	return false
end

function InputModule:Destroy()
	--assert(self.ID, "person dawg 😭")
	assert(self.ID, "Missing property \"ID\"!")
	InputModule.Inputs[self.ID] = nil
	
	for pos in pairs(self) do
		self[pos] = nil
	end
end

return InputModule