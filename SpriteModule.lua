-- This is used for Love2D

assert(love, "No LOVE module!")

local Sprite = {} -- the module
Sprite.__index = Sprite
Sprite.Sprites = {} -- all of 'em sprites.
Sprite.PrintWarns = true

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
	self.SizeProperly = true -- if false then it will scale by X and Y and not fit in
    self.Visible = true
	Sprite.Sprites[ID] = self
	return self
end

function Sprite.GetScaleForXAndY(Width, Height, DSizeX, DSizeY) -- this gets the scale so Drawable fits inside desired SizeX and SizeY / i was thinking of making this a non-module function but decided not to so don't mind the name and comment as long as it makes sense to me and this function will probably not need any changes unless love decides to change some crap or something idk damn it's three extra lines just for one comment in my text editor and each aaaaaaaa I don't think this is a normal comment anymore dude
	local X = DSizeX / Width
	local Y = DSizeY / Height
	
	return X, Y
end

function Sprite:Draw(ForceDraw) -- should be used in a love.draw() function since that is where the graphics crap works; ForceDraw doesn't bypass errors, BTW.
	assert(self, "No \"self\"!")
	assert(self.Drawable and self.X and self.Y and self.SizeX and self.SizeY and self.Rotation, "Missing properties!")
	assert(self.Drawable.getWidth and self.Drawable.getHeight, "Missing \"getWidth()\" and/or \"getHeight()\"!")
	
    if (not self.Visible) and (not ForceDraw) then
        return
    end

	local X, Y = Sprite.GetScaleForXAndY(self.Drawable:getWidth(), self.Drawable:getHeight(), self.SizeX, self.SizeY)
	
	if self.SizeProperly then
		love.graphics.draw(self.Drawable, self.X, self.Y, self.Rotation, X, Y)
	else
		love.graphics.draw(self.Drawable, self.X, self.Y, self.Rotation, self.SizeX, self.SizeY)
	end
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

function Sprite.DrawAll(IgnoreTags, ForceDraw)
	for pos in pairs(Sprite.Sprites) do
        local ThisSprite = Sprite.Sprites[pos]
		local ShouldDraw = true
		
        if not ThisSprite.Visible then
            ShouldDraw = false
        end

		if ShouldDraw and IgnoreTags then
			for _, v in ipairs(IgnoreTages) do
				if ThisSprite.Tags then
					if ThisSprite.Tags[v] then ShouldDraw = false end
				else
                    if Sprite.PrintWarns then
                        print("WARN: Sprite with ID: ".. tostring(ThisSprite.ID).. " is missing property \".Tags\"!")
                    end

					ShouldDraw = false -- frick them sprite if they deleted the .Tags
				end
			end
		end
		
		if ShouldDraw or ForceDraw then
			ThisSprite:Draw(ForceDraw)
		end
	end
end

return Sprite
