RegisterServerEvent('core_bodyperms')
AddEventHandler('core_bodyperms', function(model)
	allowed = false
	if IsPlayerAceAllowed(source, Config.ace) then
		return true
	else
		return false
	end
end)