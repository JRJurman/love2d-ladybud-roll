-- vanilla milkshake Palette
-- https://lospec.com/palette-list/vanilla-milkshake
vanillaMilkshakeColors = {
	{0.156, 0.156, 0.180},	-- 1, dark
	{0.423, 0.337, 0.443},	-- 2, dark lavender
	{0.850, 0.784, 0.749},	-- 3, light tan
	{0.976, 0.509, 0.517},	-- 4, red
	{0.690, 0.662, 0.894}, 	-- 5, lavender
	{0.674, 0.8, 0.894}, 		-- 6, blue
	{0.701, 0.890, 0.854},	-- 7, teal
	{0.996, 0.666, 0.894},	-- 8, pink
	{0.529, 0.658, 0.537},	-- 9, dark green
	{0.690, 0.921, 0.576},	-- 10, light green
	{0.913, 0.960, 0.615},	-- 11, yellow-green
	{1, 0.901, 0.776},			-- 12, sand brown
	{0.870, 0.639, 0.545},	-- 13, tumbleweed
	{1, 0.764, 0.517},			-- 14, chardonnay
	{1, 0.968, 0.627},			-- 15, bright yellow
	{1, 0.968, 0.894},			-- 16, off white
}

function newVanillaColor(index, alpha)
	love.graphics.setColor(unpack(vanillaMilkshakeColors[index],  alpha or 1))
end
