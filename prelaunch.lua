launch = table.concat(arg, " "):find("--launch")

if not launch then
	buttons = {}
	padding = 20

	function addButton(label, callback)
		local buttonWidth = love.graphics.getWidth() * 0.85
		local buttonHeight = love.graphics.getHeight() * 0.1

		table.insert(buttons, {
			label = label,
			x = (love.graphics.getWidth() - buttonWidth) / 2,
			y = (#buttons + 1) * (padding + buttonHeight) + 100,
			width = buttonWidth,
			height = buttonHeight,
			callback = callback
		})
	end

	function launchGame(args)
		local osName = love.system.getOS()
		local command

		if osName == "Windows" then
			command = "start beatblock.exe " .. args
		elseif osName == "OS X" then
			command = "open beatblock.app " .. args .. " &"
		else -- assume Linux
			command = "./beatblock " .. args .. " &"
		end

		love.window.close()
		os.execute(command)
		love.event.quit()
	end

	love.window.setTitle("Select a launch option")
	love.graphics.setBackgroundColor(1, 1, 1) -- white

	logo = love.graphics.newImage("assets/title/logo.png")
	logo:setFilter('nearest', 'nearest')

	love.graphics.setDefaultFilter('nearest', 'nearest')
	love.graphics.setLineStyle('rough')
	love.graphics.setLineJoin('miter')

	font = love.graphics.newFont("assets/fonts/DigitalDisco-Thin.ttf", 32)
	font:setFilter('nearest', 'nearest', 0)

	addButton("Launch Vanilla", function()
		launchGame("--launch --disable-mods")
	end)
	addButton("Launch Modded", function()
		launchGame("--launch")
	end)
	addButton("Launch Modded Without Console", function()
		launchGame("--launch --disable-console")
	end)

	function love.mousepressed(x, y)
		for _, btn in ipairs(buttons) do
			if x >= btn.x and x <= btn.x + btn.width and y >= btn.y and y <= btn.y + btn.height then
				btn.callback()
			end
		end
	end

	function love.draw()
		love.graphics.setColor(1, 1, 1)
		local scale = 1.5
		love.graphics.draw(logo, (love.graphics.getWidth() - logo:getWidth() * scale) / 2, 46, 0, scale, scale)

		for _, btn in ipairs(buttons) do
			love.graphics.setColor(0, 0, 0) -- black
			love.graphics.rectangle("line", btn.x, btn.y, btn.width, btn.height)

			love.graphics.setFont(font)
			love.graphics.printf(btn.label, btn.x, btn.y + (btn.height / 6), btn.width, "center")
		end
	end

	return
end
