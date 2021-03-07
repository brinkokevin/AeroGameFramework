-- https://github.com/Validark/Roblox-TS-Libraries/blob/master/signal/init.lua

--[[
	signal = Signal.new([maid])
	signal:Fire(...)
	signal:Wait()
	signal:WaitPromise()
	signal:Destroy()
	signal:DisconnectAll()
--]]

local Promise = require(script.Parent.Promise)

local Signal = {}
Signal.__index = Signal


function Signal.new(maid)
	local self = setmetatable({
		_bindable = Instance.new("BindableEvent");
	}, Signal)

	if maid then
		maid:GiveTask(self)
	end

	return self
end


function Signal.Is(obj)
	return (type(obj) == "table" and getmetatable(obj) == Signal)
end


function Signal:Connect(callback)
	return self._bindable.Event:Connect(function(getArguments)
		callback(getArguments())
	end)
end


function Signal:Fire(...)
	local Arguments = { ... }
	local n = select("#", ...)

	self._bindable:Fire(function()
		return table.unpack(Arguments, 1, n)
	end)
end


function Signal:Wait()
	return self._bindable.Event:Wait()()
end


function Signal:WaitPromise()
	return Promise.new(function(resolve)
		resolve(self:Wait())
	end)
end


function Signal:DisconnectAll()
	self._bindable:Destroy()
	self._bindable = Instance.new("BindableEvent")
end


function Signal:Destroy()
	self._bindable:Destroy()
end


return Signal