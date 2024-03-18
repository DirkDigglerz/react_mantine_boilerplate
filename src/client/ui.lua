UI = {
  mainButtons = {
    unlock = function(vehicle)
      if GetVehicleDoorLockStatus(vehicle) == 1 then
        SetVehicleDoorsLocked(vehicle, 2)
      else
        SetVehicleDoorsLocked(vehicle, 1)
      end
    end,

    lock = function(vehicle)
      SetVehicleDoorsLocked(vehicle, 2)
    end,

    alarm = function(vehicle)
      if IsVehicleAlarmSet(vehicle) then
        StartVehicleAlarm(vehicle)
      else
        StopVehicleAlarm(vehicle)
      end
    end,

    trunk = function(vehicle)
      if GetVehicleDoorAngleRatio(vehicle, 5) > 0.0 then
        SetVehicleDoorShut(vehicle, 5, false)
      else
        SetVehicleDoorOpen(vehicle, 5, false, false)
      end
    end,
  },

  extraButtons = {
    {
      action_id = 'REMOTE_START',  
      text     = 'Remote Start',
      icon      = 'fas fa-car',
      action    = function(vehicle)
        if GetIsVehicleEngineRunning(vehicle) then
          SetVehicleEngineOn(vehicle, false, true, true)
        else
          SetVehicleEngineOn(vehicle, true, true, true)
        end
      end,      
    },
  }
}

openFob = function(plate, buttons)
  local our_buttons = {}
  for k,v in pairs(buttons) do 
    local this_button = getButtonById(v)
    if this_button then 
      table.insert(our_buttons, {
        text = this_button.text,
        icon  = this_button.icon,
        action_id = this_button.action_id,
      })
    end
  end

  print(json.encode(our_buttons, {indent = true}))


  local vehicle = getEntityByPlate(plate)
  if not vehicle then return false, print('Vehicle not found') end

  local veh_health = GetVehicleBodyHealth(vehicle) / 10
  local veh_fuel = GetVehicleFuelLevel(vehicle) 
  print(veh_health, veh_fuel)


  SetNuiFocus(true, true)
  SendNUIMessage({
    module = "Fob",
    action = "FOB_STATE",
    data = {
      action = "OPEN",
      plate  = plate,
      buttons = our_buttons,
      health = veh_health,
      fuel   = veh_fuel,

    },
  })
end





-- YOU SHOULDNT NEED TO TOUCH BELOW BUT :SHRUG:

getEntityByPlate = function(plate)
  local pool = GetGamePool('CVehicle')
  for i=1, #pool do
    local vehicle = pool[i]
    if GetVehicleNumberPlateText(vehicle) == plate then
      return vehicle
    end
  end
  return nil
end 

getButtonById = function(action_id)
  for k,v in pairs(UI.extraButtons) do 
    if v.action_id == action_id then
      return v
    end
  end
  return nil
end

RegisterNuiCallback('EXTRA_BUTTON', function(data,cb)
  print('TRIGGERING EXTRA BUTTON ON ', data.plate)
  local vehicle = getEntityByPlate(data.plate)
  if not vehicle then return false, print('Vehicle not found') end
  local extraButton = getButtonById(data.action_id)
  if not extraButton then return false, print('Button not found') end
  extraButton.action(vehicle)
  cb('ok')
end)


RegisterNuiCallback('FOB_BUTTON', function(data,cb)
  print('TRIGGERING MAIN BUTTON ON ', data.plate, data.action_id)
  local vehicle = getEntityByPlate(data.plate)
  if not vehicle then return false, print('Vehicle not found') end
  if not UI.mainButtons[data.action_id] then return false, print('Button not found') end
  UI.mainButtons[data.action_id](vehicle)
  cb('ok')
end)

RegisterNuiCallback('LOSE_FOCUS', function(data,cb)
  SetNuiFocus(false, false)
end)

closeFob = function()
  SetNuiFocus(false, false)
  SendNUIMessage({
    module = "Fob",
    action = "FOB_STATE",
    data = {
      action = "CLOSE",
    },
  })
end

-- Useage 
-- exports['newb_keys']:openFob('plate', {'REMOTE_START'})
exports('openFob', openFob)
-- Useage
-- exports['newb_keys']:closeFob()
exports('closeFob', closeFob)
