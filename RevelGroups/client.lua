PlayerData                = {}
ESX                       = nil
local display = false




Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end
end)


RegisterCommand('group', function(source)
    ShowUi(true)

end)



Citizen.CreateThread(function()
     while display do
        Citizen.Wait(0)
        FreezeEntityPosition(PlayerPedId(), display)
        DisableControlAction(0, 1, display)
        DisableControlAction(0, 2, display)
        DisableControlAction(0, 142, display)
        DisableControlAction(0, 18, display)
        DisableControlAction(0, 322, display)
        DisableControlAction(0, 106, display)
     end
end)

-- callbacks


RegisterNUICallback("exit", function(data) --> close UI on ESC
   ShowUi(false)
end)

 



 
RegisterNUICallback("callback", function(data) 
   if data.action == "NewGroup" then 
      local Checkbox = data.checkbox 
      local GroupName = data.groupname
        if Checkbox == "false" then
         exports['mythic_notify']:SendAlert('error', "You need to agree with the payment")
        elseif Checkbox == "true" then
        ESX.TriggerServerCallback('RevelGroups:getAllData', function(cb)
          local playername = ''..cb.FirstName..' '..cb.SecondName..''
          TriggerServerEvent("RevelGroups:NewGroup", GroupName, playername)
        end)
      end
   end
   if data.action == "Loading" then 
      UiLoaded(true)
   end
end)

function UiLoaded(bool)
   local IsIn = CheckGroup
    ESX.TriggerServerCallback('RevelGroups:getAllData', function(data)
       display = bool 
       SetNuiFocus(bool, bool)
       
           if IsIn == "yes" then
            SendNUIMessage({
            type = "uiloaded",
            status = bool,
            playername = ''..data.FirstName..' '..data.SecondName..''
            })
          elseif IsIn ~= "yes" then
            SendNUIMessage({
            type = "NewGrouploaded",
            status = bool,
            playername = ''..data.FirstName..' '..data.SecondName..''
            })
           end
 
    ESX.TriggerServerCallback('RevelGroups:getGroupsInfo', function(data, CountMembers, IsInGroup)
        CheckGroup = IsInGroup
       SendNUIMessage({
       group = data.group,
       boss = data.boss,
       money = data.money,
       bossname = data.bossname,
       members = CountMembers
      })
     
       end)
    end)
  end


function ShowUi(bool)
  local IsIn = CheckGroup
   ESX.TriggerServerCallback('RevelGroups:getAllData', function(data)
      display = bool 
      SetNuiFocus(bool, bool)
      
          if IsIn == "yes" then
           SendNUIMessage({
           type = "ui",
           status = bool,
           playername = ''..data.FirstName..' '..data.SecondName..''
           })
         elseif IsIn ~= "yes" then
           SendNUIMessage({
           type = "NewGroup",
           status = bool,
           playername = ''..data.FirstName..' '..data.SecondName..''
           })
          end

   ESX.TriggerServerCallback('RevelGroups:getGroupsInfo', function(data, CountMembers, IsInGroup)
       CheckGroup = IsInGroup
      SendNUIMessage({
      group = data.group,
      boss = data.boss,
      money = data.money,
      bossname = data.bossname,
      members = CountMembers
     })
    
      end)
   end)
 end



RegisterNetEvent('RevelGroups:GroupCreated')
AddEventHandler('RevelGroups:GroupCreated', function(status)
   if status then 
      ESX.TriggerServerCallback('RevelGroups:getGroupsInfo', function(data, CountMembers)
         CheckGroup = IsInGroup
        SendNUIMessage({
        group = data.group,
        boss = data.boss,
        money = data.money,
        bossname = data.bossname,
        members = CountMembers,
        created = status -- make javascript knows the group has been created with sucess
       })
      end)
      end
      
end)
