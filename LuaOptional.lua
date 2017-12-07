local LuaOptional = {}
LuaOptional.__tostring = function(self)
	return self.toString()
end
LuaOptional.__eq = function(self,Other)
	if self.equals(Other) then
		return true
	else
		return false
	end
end
--Optional Constructors--
function LuaOptional.of(Value)
	if Value then
		return setmetatable(CreateOptional(Value),LuaOptional)
	else
		error("Optional - Value was nil in 'of' function")
	end
end

function LuaOptional.empty()
	return setmetatable(CreateOptional(nil),LuaOptional)
end

function LuaOptional.ofNullable(Value)
	return setmetatable(CreateOptional(Value),LuaOptional)
end
--/Optional Constructors--


function CreateOptional(Value)
	local RawValue = Value
	local LuaOptional = LuaOptional
	local Optional = {}
	Optional.isOptional = true
	
	--Custom Optional Functions--	
	function Optional.rawGet()
		return RawValue
	end
	--/Custom Optional Functions--
	
	--Java 8 Optional Functions--
	function Optional.isPresent()
		if RawValue then
			return true
		else
			return false
		end
	end
	
	function Optional.ifPresent(PresentAction)
		if RawValue then
			return PresentAction(RawValue)
		else
			return false
		end
	end
	
	function Optional.orElse(Other)
		if RawValue then
			return RawValue
		else
			return Other
		end
	end
	
	function Optional.orElseGet(Other)
		if RawValue then
			return RawValue
		else
			return Other.get()
		end
	end
	
	function Optional.orElseThrow(ErrorMsg)
		if RawValue then
			return RawValue
		else
			error(ErrorMsg)
		end
	end
	
	function Optional.get()
		if RawValue then
			return RawValue
		else
			error("Optional - NoSuchElementException")
		end
	end
	
	function Optional.equals(Other)
		if Optional.isOptional and Other.isOptional then
			if Optional.isPresent() and Other.isPresent() then
				return Optional.get() == Other.get() and true or false
			elseif not Optional.isPresent() and not Other.isPresent() then
				return true
			end
		end
		return false
	end
	
	function Optional.filter(Filter)
		if RawValue then
			if Filter(RawValue) then
				return LuaOptional.of(RawValue)
			end
		end
		return LuaOptional.empty()
	end
	
	function Optional.map(Map)
		if RawValue then
			local Result = Map(RawValue)
			if Result then
				return LuaOptional.of(Result)
			end
		end
		return LuaOptional.empty()
	end
	
	function Optional.flatMap(flatMap)
		if RawValue then
			local Result = flatMap(RawValue)
			if Result then
				return Result
			end
		end
		return LuaOptional.empty()
	end
	
	function Optional.toString()
		if RawValue then
			return "Optional["..RawValue.."]"
		else
			return "Optional.empty"
		end
	end
	--/Java 8 Optional Functions--
	
	--Java 9 Optional Functions--
	function Optional.either(OtherOptional)
		if RawValue then
			return LuaOptional.of(RawValue)
		end
		return OtherOptional
	end
	
	function Optional.ifPresentOrElse(PresentAction,NilAction)
		if RawValue then
			PresentAction(RawValue)
		else
			NilAction()
		end
	end
--/Java 9 Optional Functions--
	return Optional
end


return LuaOptional
