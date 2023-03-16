ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local InGroup = "no"


RegisterNetEvent('RevelGroups:NewGroup')
AddEventHandler('RevelGroups:NewGroup', function(groupname,playername)
	local source_ = source
	local xPlayer = ESX.GetPlayerFromId(source)

	local GName = groupname
	local PName = playername
    
	if GName == '' then 
		--print('You need to write something to this works!')
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'You need to define your Group Name', length = 5000, style = {} })
		return 
	end

	if PName == '' then 
		print('Someone try create a group but dont have Player Name on database (users)')
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Please! Contact any admin on server!', length = 5000, style = {} })
		return 
	end
	MySQL.Async.fetchAll('SELECT * FROM revelgroups WHERE `group` = @group', {
		['@group'] = GName
	}, function(result)
		table = result
		CountTables = 0
			 for i = 1, #table, 1 do
				CountTables = CountTables + 1
				
			end
			local CountGroups = CountTables
		if CountGroups >= 1 then 
		
			--print('isso já existe escolhe outro')
			TriggerClientEvent('mythic_notify:client:SendAlert', source_, { type = 'error', text = 'That Group Name already exist!', length = 5000, style = {} })
		elseif CountGroups == 0 then
			MySQL.Async.execute('INSERT INTO revelgroups (`iden`, `group`, `boss`, `boss_name`, `money`) VALUES (@iden, @group, @boss, @boss_name, @money)', {
				['@iden'] = xPlayer.identifier,
				['@group'] = GName,
				['@boss'] = xPlayer.identifier,
				['@boss_name'] = PName,
				['@money'] = 0
			})
			TriggerClientEvent('mythic_notify:client:SendAlert', source_, { type = 'success', text = 'Your group has been created successfully', length = 5000, style = {} })
	 	   TriggerClientEvent('RevelGroups:GroupCreated', source_, true)
		end
    end)

		
end)







-- CALLBACKS'
ESX.RegisterServerCallback("RevelGroups:getAllData", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local database = result[1]

		local data = {
			FirstName = database.firstname,
            SecondName = database.lastname
		}
		cb(data)
	end)
end)

ESX.RegisterServerCallback("RevelGroups:getGroupsInfo", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM revelgroups WHERE iden = @iden', {
		['@iden'] = xPlayer.identifier
	}, function(result)
		local database = result[1]
        InGroup = nil
	   
        

		if database == nil then
			-- if identifier not exist on database
			return
		else
			InGroup = "yes"
			-- if identifier exist on database
		end

		local data = {
			group = database.group,
            boss = database.boss,
			money = database.money,
			bossname = database.boss_name
		}
		
		MySQL.Async.fetchAll('SELECT * FROM revelgroups WHERE boss = @boss', {
			['@boss'] = database.boss
		}, function(result2)
             table = result2
			 counted = 0
			 for i = 1, #table, 1 do
				counted = counted + 1
				
			end
			local CountMembers = counted
			local IsInGroup = InGroup
         
		cb(data, CountMembers,IsInGroup)
	end)
  end)
end)




