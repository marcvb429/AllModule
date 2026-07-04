local CModule = {}

function CModule.RectanglesColliding(A, B)-- A and B must be tables with SizeX, SizeY, X, and Y. This only detects IF them rectangles are inside each other.
	if A.X >= (B.X + B.SizeX) then
		return false
	end
	
	if (A.X + A.SizeX) <= B.X then
		return false
	end
	
	if A.Y >= (B.Y + B.SizeY) then
		return false
	end
	
	if (A.Y + A.SizeY) <= B.Y then
		return false
	end
	
	return true
end

return CModule