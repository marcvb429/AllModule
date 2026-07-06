-- This is used for Love2D

assert(love, "No LOVE module!")

local Sprite = {} -- the module
Sprite.__index = Sprite
Sprite.Sprites = {} -- all of 'em sprites.

function Sprite.new(ID) -- new Sprite object
	assert(ID, "ID missing!")
	assert((not Sprite.Sprites[ID]), "Duplicate ID!")
	
	local self = setmetatable({}, Sprite)
	self.X = 0
	self.Y = 0
	self.SizeX = 0
	self.SizeY = 0
	self.Drawable = nil -- Should be set after creation manually, like the other properties. Also should be a subtype of Drawable with getHeight and getWidth... this isn't named Texture because there are Drawable subtypes that are not Textures but have getHeight() and getWidth().
	self.ID = ID -- SHOULD NOT BE CHANGED. PLEASE. I BEG YOU. for now we don't use this property but still, might be useful, and changing this won't change the ID in the sprite table, so it will be out of sync. so that's why you DON'T change it
	self.Rotation = 0 -- should be in radians
	self.Tags = {}
	Sprite.Sprites[ID] = self
	return self
end

function Sprite.GetScaleForXAndY(Width, Height, DSizeX, DSizeY) -- this gets the scale so Drawable fits inside desired SizeX and SizeY / i was thinking of making this a non-module function but decided not to so don't mind the name and comment as long as it makes sense to me and this function will probably not need any changes unless love decides to change some crap or something idk
	local X = DSizeX / Width
	local Y = DSizeY / Height
	
	return X, Y
end

function Sprite:Draw() -- should be used in a love.draw() function since that is where the graphics crap works
	assert(self, "No \"self\"!")
	assert(self.Drawable and self.X and self.Y and self.SizeX and self.SizeY and self.Rotation, "Missing property(ies)!")
	assert(self.Drawable.getWidth and self.Drawable.getHeight, "Missing \"getWidth()\" or/and \"getHeight()\"!")
	
	local X, Y = Sprite.GetScaleForXAndY(self.Drawable:getWidth(), self.Drawable:getHeight(), self.SizeX, self.SizeY)
	
	love.graphics.draw(self.Drawable, self.X, self.Y, self.Rotation, X, Y)
end

function Sprite:AddTag(Tag)
	if not self.Tags[Tag] then
		self.Tags[Tag] = true
	end
end

function Sprite:RemoveTag(Tag)
	if self.Tags[Tag] then
		self.Tags[Tag] = nil
	end
end

function Sprite:Destroy()
	--assert(self.ID, "dude person 😭")
	assert(self.ID, "Missing property \"ID\"!")
	Sprite.Sprites[self.ID] = nil
	
	for pos in pairs(self) do
		self[pos] = nil
	end
end

return Sprite