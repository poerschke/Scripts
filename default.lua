-- to keep it up to date, config is loaded from remote server

  function ContaMonster()
  monsters = 0
  for _, spec in ipairs(getSpectators()) do
    if spec:isMonster() then
      monsters = monsters + 1
    end
  end
  return monsters
  end

-- alarm.otui
importStyle([=[
AlarmsWindow < MainWindow
  !text: tr('Alarms')
  size: 270 170
  @onEscape: self:hide()

  BotSwitch
    id: playerAttack
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Player Attack

  BotSwitch
    id: playerDetected
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 4
    text-align: center
    text: Player Detected

  CheckBox
    id: playerDetectedLogout
    anchors.top: playerDetected.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 3
    text: Logout

  BotSwitch
    id: creatureDetected
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 4
    text-align: center
    text: Creature Detected

  BotSwitch
    id: healthBelow
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 4
    text: Health < 50%

  HorizontalScrollBar
    id: healthValue
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: healthBelow.top
    margin-left: 3
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  BotSwitch
    id: manaBelow
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.horizontalCenter
    text-align: center
    margin-top: 4
    text: Mana < 50%

  HorizontalScrollBar
    id: manaValue
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: manaBelow.top
    margin-left: 3
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  BotSwitch
    id: privateMessage
    anchors.left: parent.left
    anchors.top: prev.bottom
    anchors.right: parent.right
    text-align: center
    margin-top: 4
    text: Private Message


]=])
-- example.otui
importStyle([=[
ExampleLabel2 < Label
  text: LOL
  height: 200
  width: 50
  
]=])
-- siolist.otui
importStyle([=[
SioFriendName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16

  $focus:
    background-color: #00000055

  Button
    id: remove
    !text: tr('x')
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

SioListWindow < MainWindow
  !text: tr('Sio List')
  size: 200 300
  @onEscape: self:hide()

  TextList
    id: SioList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    padding: 1
    width: 150
    height: 200
    vertical-scrollbar: SioListScrollBar

  VerticalScrollBar
    id: SioListScrollBar
    anchors.top: SioList.top
    anchors.bottom: SioList.bottom
    anchors.right: SioList.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: FriendName
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.top: SioList.bottom
    margin-top: 5

  Button
    id: close
    !text: tr('Close')
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    width: 40
    margin-left: 3

  Button
    id: AddFriend
    !text: tr('Add Friend')
    anchors.right: close.left
    anchors.left: parent.left
    anchors.top: prev.top

]=])
-- alarms.lua
alarmsPanelName = "alarms"
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Alarms')

  Button
    id: alerts
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Edit

]])
ui:setId(alarmsPanelName)

if not storage[alarmsPanelName] then
storage[alarmsPanelName] = {
  enabled = false,
  playerAttack = false,
  playerDetected = false,
  playerDetectedLogout = false,
  creatureDetected = false,
  healthBelow = false,
  healthValue = 40,
  manaBelow = false,
  manaValue = 50,
  privateMessage = false
}
end

ui.title:setOn(storage[alarmsPanelName].enabled)
ui.title.onClick = function(widget)
storage[alarmsPanelName].enabled = not storage[alarmsPanelName].enabled
widget:setOn(storage[alarmsPanelName].enabled)
end

rootWidget = g_ui.getRootWidget()
if rootWidget then
  alarmsWindow = g_ui.createWidget('AlarmsWindow', rootWidget)
  alarmsWindow:hide()

  alarmsWindow.playerAttack:setOn(storage[alarmsPanelName].playerAttack)
  alarmsWindow.playerAttack.onClick = function(widget)
    storage[alarmsPanelName].playerAttack = not storage[alarmsPanelName].playerAttack
    widget:setOn(storage[alarmsPanelName].playerAttack)
  end

  alarmsWindow.playerDetected:setOn(storage[alarmsPanelName].playerDetected)
  alarmsWindow.playerDetected.onClick = function(widget)
    storage[alarmsPanelName].playerDetected = not storage[alarmsPanelName].playerDetected
    widget:setOn(storage[alarmsPanelName].playerDetected)
  end

  alarmsWindow.playerDetectedLogout:setChecked(storage[alarmsPanelName].playerDetectedLogout)
  alarmsWindow.playerDetectedLogout.onClick = function(widget)
    storage[alarmsPanelName].playerDetectedLogout = not storage[alarmsPanelName].playerDetectedLogout
    widget:setChecked(storage[alarmsPanelName].playerDetectedLogout)
  end

  alarmsWindow.creatureDetected:setOn(storage[alarmsPanelName].creatureDetected)
  alarmsWindow.creatureDetected.onClick = function(widget)
    storage[alarmsPanelName].creatureDetected = not storage[alarmsPanelName].creatureDetected
    widget:setOn(storage[alarmsPanelName].creatureDetected)
  end

  alarmsWindow.healthBelow:setOn(storage[alarmsPanelName].healthBelow)
  alarmsWindow.healthBelow.onClick = function(widget)
    storage[alarmsPanelName].healthBelow = not storage[alarmsPanelName].healthBelow
    widget:setOn(storage[alarmsPanelName].healthBelow)
  end

  alarmsWindow.healthValue.onValueChange = function(scroll, value)
    storage[alarmsPanelName].healthValue = value
    alarmsWindow.healthBelow:setText("Health < " .. storage[alarmsPanelName].healthValue .. "%")  
  end
  alarmsWindow.healthValue:setValue(storage[alarmsPanelName].healthValue)

  alarmsWindow.manaBelow:setOn(storage[alarmsPanelName].manaBelow)
  alarmsWindow.manaBelow.onClick = function(widget)
    storage[alarmsPanelName].manaBelow = not storage[alarmsPanelName].manaBelow
    widget:setOn(storage[alarmsPanelName].manaBelow)
  end

  alarmsWindow.manaValue.onValueChange = function(scroll, value)
    storage[alarmsPanelName].manaValue = value
    alarmsWindow.manaBelow:setText("Mana < " .. storage[alarmsPanelName].manaValue .. "%")  
  end
  alarmsWindow.manaValue:setValue(storage[alarmsPanelName].manaValue)

  alarmsWindow.privateMessage:setOn(storage[alarmsPanelName].privateMessage)
  alarmsWindow.privateMessage.onClick = function(widget)
    storage[alarmsPanelName].privateMessage = not storage[alarmsPanelName].privateMessage
    widget:setOn(storage[alarmsPanelName].privateMessage)
  end

  onTextMessage(function(mode, text)
    if storage[alarmsPanelName].enabled and storage[alarmsPanelName].playerAttack and mode == 16 and string.match(text, "hitpoints due to an attack") and not string.match(text, "hitpoints due to an attack by a ") then
      playSound("/sounds/Player Attack.ogg")
    end
  end)

  macro(100, function()
    if not storage[alarmsPanelName].enabled then
      return
    end
    if storage[alarmsPanelName].playerDetected then
      for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec:getName() ~= name() then
          specPos = spec:getPosition()
          if math.max(math.abs(posx()-specPos.x), math.abs(posy()-specPos.y)) <= 8 then
            playSound("/sounds/Player Detected.ogg")
            delay(1500)
            if storage[alarmsPanelName].playerDetectedLogout then
              modules.game_interface.tryLogout(false)
            end
            return
          end
        end
      end
    end

    if storage[alarmsPanelName].creatureDetected then
      for _, spec in ipairs(getSpectators()) do
        if not spec:isPlayer()then
          specPos = spec:getPosition()
          if math.max(math.abs(posx()-specPos.x), math.abs(posy()-specPos.y)) <= 8 then
            playSound("/sounds/Creature Detected.ogg")
            delay(1500)
            return
          end
        end
      end
    end

    if storage[alarmsPanelName].healthBelow then
      if hppercent() <= storage[alarmsPanelName].healthValue then
        playSound("/sounds/Low Health.ogg")
        delay(1500)
        return
      end
    end

    if storage[alarmsPanelName].manaBelow then
      if manapercent() <= storage[alarmsPanelName].manaValue then
        playSound("/sounds/Low Mana.ogg")
        delay(1500)
        return
      end
    end
  end)

  onTalk(function(name, level, mode, text, channelId, pos)
    if mode == 4 and storage[alarmsPanelName].enabled and storage[alarmsPanelName].privateMessage then
      playSound("/sounds/Private Message.ogg")
      return
    end
  end)
end

ui.alerts.onClick = function(widget)
  alarmsWindow:show()
  alarmsWindow:raise()
  alarmsWindow:focus()
end
-- battle.lua
local batTab = addTab("Batt")

Panels.AttackSpell(batTab)
addSeparator("sep", batTab)
Panels.AttackItem(batTab)
addSeparator("sep", batTab)
Panels.AttackLeaderTarget(batTab)
addSeparator("sep", batTab)
Panels.LimitFloor(batTab)
addSeparator("sep", batTab)
Panels.AntiPush(batTab)
addSeparator("sep", batTab)
function friendHealer(parent)
  local panelName = "advancedFriendHealer"
  local ui = setupUI([[
Panel
  height: 135
  margin-top: 2

  BotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Friend Healer

  BotTextEdit
    id: spellName
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: title.bottom
    margin-top: 3

  BotButton
    id: editList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    text-align: center
    text: Edit List
    margin-top: 3

  SmallBotSwitch
    id: partyAndGuildMembers
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    text-align: center
    text: Heal Party/Guild
    margin-top: 3

  BotLabel
    id: manaInfo
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: partyAndGuildMembers.bottom
    text-align: center

  HorizontalScrollBar
    id: minMana
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: manaInfo.bottom
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1

  BotLabel
    id: friendHp
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    text-align: center

  HorizontalScrollBar
    id: minFriendHp
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: friendHp.bottom
    margin-right: 2
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1
    
  HorizontalScrollBar
    id: maxFriendHp
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 1
    maximum: 100
    step: 1    
  ]], parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {
      minMana = 60,
      minFriendHp = 40,
      maxFriendHp = 90,
      spellName = "exura sio",
      sioList = {},
      partyAndGuildMembers = true
    }
  end


  rootWidget = g_ui.getRootWidget()
  sioListWindow = g_ui.createWidget('SioListWindow', rootWidget)
  sioListWindow:hide()

  if storage[panelName].sioList and #storage[panelName].sioList > 0 then
    for _, sioName in ipairs(storage[panelName].sioList) do
      local label = g_ui.createWidget("SioFriendName", sioListWindow.SioList)
      label.remove.onClick = function(widget)
        table.removevalue(storage[panelName].sioList, label:getText())
        label:destroy()
      end
      label:setText(sioName)
    end
  end

  sioListWindow.close.onClick = function(widget)
    sioListWindow:hide()
  end

  sioListWindow.AddFriend.onClick = function(widget)
    local friendName = sioListWindow.FriendName:getText()
    if friendName:len() > 0 and not table.contains(storage[panelName].sioList, friendName, true) then
      table.insert(storage[panelName].sioList, friendName)
      local label = g_ui.createWidget("SioFriendName", sioListWindow.SioList)
      label.remove.onClick = function(widget)
        table.removevalue(storage[panelName].sioList, label:getText())
        label:destroy()
      end
      label:setText(friendName)
      sioListWindow.FriendName:setText('')
    end
  end

  ui.title:setOn(storage[panelName].enabled)
  ui.partyAndGuildMembers:setOn(storage[panelName].partyAndGuildMembers)

  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end

  ui.partyAndGuildMembers.onClick = function(widget)
    storage[panelName].partyAndGuildMembers = not storage[panelName].partyAndGuildMembers
    widget:setOn(storage[panelName].partyAndGuildMembers)
  end
  ui.editList.onClick = function(widget)
    sioListWindow:show()
    sioListWindow:raise()
    sioListWindow:focus()
  end
  ui.spellName.onTextChange = function(widget, text)
    storage[panelName].spellName = text
  end
  local updateMinManaText = function()
    ui.manaInfo:setText("Minimum Mana >= " .. storage[panelName].minMana)
  end
  local updateFriendHpText = function()
    ui.friendHp:setText("" .. storage[panelName].minFriendHp .. "% <= hp >= " .. storage[panelName].maxFriendHp .. "%")  
  end

  ui.minMana.onValueChange = function(scroll, value)
    storage[panelName].minMana = value
    updateMinManaText()
  end
  ui.minFriendHp.onValueChange = function(scroll, value)
    storage[panelName].minFriendHp = value

    updateFriendHpText()
  end
  ui.maxFriendHp.onValueChange = function(scroll, value)
    storage[panelName].maxFriendHp = value
    updateFriendHpText()
  end
  ui.spellName:setText(storage[panelName].spellName)
  ui.minMana:setValue(storage[panelName].minMana)
  ui.minFriendHp:setValue(storage[panelName].minFriendHp)
  ui.maxFriendHp:setValue(storage[panelName].maxFriendHp)

  macro(200, function()
    if storage[panelName].enabled and storage[panelName].spellName:len() > 0 and manapercent() > storage[panelName].minMana then
      for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and storage[panelName].minFriendHp >= spec:getHealthPercent() and spec:getHealthPercent() <= storage[panelName].maxFriendHp then
          if storage[panelName].partyAndGuildMembers and (spec:getShield() >= 3 or spec:getEmblem() == 1) then
              saySpell(storage[panelName].spellName .. ' "' .. spec:getName(), 100)
          end
          if table.contains(storage[panelName].sioList, spec:getName()) then
            saySpell(storage[panelName].spellName .. ' "' .. spec:getName(), 100)
          end
        end
      end
    end
  end)
end
friendHealer(batTab)
addSeparator("sep", batTab)

function autoBuffSpell(parent)
  local lastBuffSpell = 0
  macro(100, "Auto Buff spell", nil, function()
    if not hasPartyBuff() or now > lastBuffSpell + 90000 then
      if saySpell(storage.autoBuffText, 2000) then
        lastBuffSpell = now
      end
    end
  end, parent)
  addTextEdit("autoBuffText", storage.autoBuffText or "utito tempo san", function(widget, text)    
    storage.autoBuffText = text
  end, parent)
end
autoBuffSpell(batTab)

addSeparator("sep", batTab)

local mineableIds = {5636,5635,5632,3635,5732,7989,7996,8169,7994,8136,7994,5753,3661,3608,3662,8135,7995,7989,8168,5747,354,355,4475,4472,4473,4476,4470,4471,4474,4485,4473,4478,4477,3339,5623,5708,12840,11821,5622,4469}
local mineThing = nil
macro(10, "Mine", function()
  if mineThing == nil then
    tiles = g_map.getTiles(posz())
    randomTile = tiles[math.random(1,#tiles)]
    if not canStandBy(randomTile:getPosition()) or getDistanceBetween(pos(), randomTile:getPosition()) > 4 then
      return
    end
    for _, thing in ipairs(randomTile:getThings()) do
      for _,mineableId in ipairs(mineableIds) do
        if thing:getId() == mineableId then
          mineThing = thing
          return
        end
      end
    end
  else
    useWith(3456, mineThing)
  end
end)


function autoFollow(parent)
  macro(100, "Auto follow", nil, function()
    local target = g_game.getAttackingCreature()
    if target == nil and storage.autoFollowName ~= nil and storage.autoFollowName:len() > 0 and g_game.getFollowingCreature() == nil then
      for _, spec in ipairs(getSpectators()) do
        if spec:getName() == storage.autoFollowName then
          g_game.follow(spec)
        end
      end
    end
  end, parent)
  addTextEdit("autoFollowName", storage.autoFollowName, function(widget, text)    
    storage.autoFollowName = text
  end, parent)
end
autoFollow()


function runePartyAndGuildMembers(parent)
  if not parent then
    parent = panel
  end
  
  local panelName = "runePartyAndGuildMembers"
  local ui = setupUI([[
Panel
  height: 65
      
  BotItem
    id: item
    anchors.left: parent.left
    anchors.top: parent.top
    
  BotSwitch
    id: title
    anchors.left: prev.right
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    text-align: center
    margin-left: 2
    margin-top: 0

  BotLabel
    id: friendHp
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: item.bottom
    text-align: center

  HorizontalScrollBar
    id: minFriendHp
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: friendHp.bottom
    margin-right: 2
    margin-top: 2
    minimum: 1
    maximum: 100
    step: 1
    
  HorizontalScrollBar
    id: maxFriendHp
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 1
    maximum: 100
    step: 1    
  ]], parent)
  ui:setId(panelName)
  
  ui.title:setText("Rune party/guild")
  
  if not storage[panelName] then
    storage[panelName] = {
      minFriendHp = 40,
      maxFriendHp = 90,
      item = 3160
    }
  end
  
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
  
  ui.item.onItemChange = function(widget)
    storage[panelName].item = widget:getItemId()
  end
  ui.item:setItemId(storage[panelName].item)

  local updateFriendHpText = function()
    ui.friendHp:setText("" .. storage[panelName].minFriendHp .. "% <= hp >= " .. storage[panelName].maxFriendHp .. "%")  
  end
  ui.minFriendHp.onValueChange = function(scroll, value)
    storage[panelName].minFriendHp = value
    updateFriendHpText()
  end
  ui.maxFriendHp.onValueChange = function(scroll, value)
    storage[panelName].maxFriendHp = value
    updateFriendHpText()
  end
  ui.minFriendHp:setValue(storage[panelName].minFriendHp)
  ui.maxFriendHp:setValue(storage[panelName].maxFriendHp)

  macro(200, function()
    if not storage[panelName].enabled then
      return
    end
    for _, spec in ipairs(getSpectators()) do
      if spec:isPlayer() and (spec:getShield() >= 3 or spec:getEmblem() == 1) then
        if storage[panelName].minFriendHp >= spec:getHealthPercent() and spec:getHealthPercent() <= storage[panelName].maxFriendHp then
          useWith(storage[panelName].item, spec)
        end
      end
    end
  end)
end
runePartyAndGuildMembers(batTab)
addSeparator("sep", batTab)
-- cavebot.lua
local caveTab = addTab("Cave")

local waypoints = Panels.Waypoints(caveTab)
addSeparator("sep", caveTab)
local attacking = Panels.Attacking(caveTab)
addSeparator("sep", caveTab)
local looting = Panels.Looting(caveTab) 
addButton("tutorial", "Help & Tutorials", function()
  g_platform.openUrl("https://www.demolidores.com.br/?subtopic=forum")
end, caveTab)

-- hp.lua
local healTab = addTab("HP")

Panels.Haste(healTab)
addSeparator("sep", healTab)
Panels.ManaShield(healTab)
addSeparator("sep", healTab)
Panels.AntiParalyze(healTab)
addSeparator("sep", healTab)
Panels.Health(healTab)
addSeparator("sep", healTab)
Panels.Health(healTab)
addSeparator("sep", healTab)
Panels.HealthItem(healTab)
Panels.HealthItem(healTab)
Panels.ManaItem(healTab)
Panels.ManaItem(healTab)
Panels.Equip(healTab)
Panels.Equip(healTab)
Panels.Equip(healTab)
addSeparator("sep", healTab)
Panels.Eating(healTab)


-- icons.lua
local toolsTab = addTab("Tools")

function AddScrolls(panelName, parent)
  if not parent then
    parent = panel
  end
 
  local ui = setupUI([[
Panel
  height: 50
  margin-top: 2

  BotItem
    id: bpId
    anchors.left: parent.left
    anchors.top: parent.top

  BotLabel
    id: title
    anchors.left: bpId.right
    anchors.right: parent.right
    anchors.top: bpId.verticalCenter
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: bpId.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1
    
  HorizontalScrollBar
    id: scroll2
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 0
    maximum: 100
    step: 1    
  ]], parent)
  ui:setId(panelName)
  if not storage[panelName] or not storage[panelName].bpId then
    storage[panelName] = {
      min = 60,
      max = 90,
      bpId = 2854
    }
  end
  
  local updateText = function()
    ui.title:setText("" .. storage[panelName].min .. "% <= hp >= " .. storage[panelName].max .. "%")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
  ui.scroll2.onValueChange = function(scroll, value)
    storage[panelName].max = value
    updateText()
  end
  ui.bpId.onItemChange = function(widget)
    storage[panelName].bpId = widget:getItemId()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
  ui.scroll2:setValue(storage[panelName].max)
  ui.bpId:setItemId(storage[panelName].bpId)
end

local defaultAmulet = 3368
macro(100, "Demolisher SSA", function()
  if hppercent() <= storage["ssa"].min and (getNeck() == nil or getNeck():getId() ~= 11868) then
    if getNeck() ~= nil and defaultAmulet == nil then
      defaultAmulet = getNeck():getId()
    end
    for _, container in pairs(getContainers()) do
      for _, item in ipairs(container:getItems()) do
        containerItem = container:getContainerItem():getId()
        if containerItem == storage["ssa"].bpId then
          if item:getId() == 11868 then
            if container:getSize() == 0 and getNeck() ~= nil  then
              g_game.moveToParentContainer(item, item:getCount())
              delay(300)
              return
            end
            moveToSlot(item, SlotNeck)
            delay(200)
            return
          end
        end
      end
    end
    if defaultAmulet ~= nil or (getNeck() ~= nil and getNeck():getId() ~= defaultAmulet) then
      amulet = findItem(defaultAmulet)
      if amulet then
        moveToSlot(amulet, SlotNeck)
      end
    end
    isAlreadyOpen = false
    for i, container in pairs(getContainers()) do
      containerItem = container:getContainerItem():getId()
      if containerItem == storage["ssa"].bpId then
        isAlreadyOpen = true
        for _, item in ipairs(container:getItems()) do
          if item:isContainer() and item:getId() == storage["ssa"].bpId then
            g_game.open(item, container)
            delay(200)
            return
          end
        end
      end
    end
    if not isAlreadyOpen then
      for i, container in pairs(getContainers()) do
        for _, item in ipairs(container:getItems()) do
          if item:isContainer() and item:getId() == storage["ssa"].bpId then
            g_game.open(item)
            delay(400)
            return
          end
        end
      end
    end
  elseif hppercent() >= storage["ssa"].max and defaultAmulet ~= nil then
    if getNeck() == nil or (getNeck() ~= nil and getNeck():getId() ~= defaultAmulet) then
      amulet = findItem(defaultAmulet)
      if amulet then
        moveToSlot(amulet, SlotNeck)
      end
    end
  end
end, toolsTab)
AddScrolls("ssa", toolsTab)
addSeparator("sep", toolsTab)

local defaultRing = nil
macro(100, "Equip E-Ring", function()
  if hppercent() <= storage["ering"].min and (getFinger() == nil or (getFinger():getId() ~= 3051 and getFinger():getId() ~= 3088)) then
    if getFinger() ~= nil and defaultRing == nil then
      defaultRing = getFinger()
    end
    ring = findItem(3051)
    findRing = false
    if ring then
      moveToSlot(ring, SlotFinger)
      delay(20)
    end

    if ring == nil then
      if defaultRing ~= nil or (getFinger() ~= nil and getFinger():getId() ~= defaultRing:getId()) then
        ring = findItem(defaultRing:getId())
        if ring then
          moveToSlot(ring, SlotFinger)
        end
      end
      findRing = true
    end

    if findRing then
      isAlreadyOpen = false
      for i, container in pairs(getContainers()) do
        containerItem = container:getContainerItem():getId()
        if containerItem == storage["ering"].bpId then
          isAlreadyOpen = true
          for _, item in ipairs(container:getItems()) do
            if item:isContainer() and item:getId() == storage["ering"].bpId then
              g_game.open(item, container)
              delay(30)
              return
            end
          end
        end
      end
      if not isAlreadyOpen then
        for i, container in pairs(getContainers()) do
          for _, item in ipairs(container:getItems()) do
            if item:isContainer() and item:getId() == storage["ering"].bpId then
              g_game.open(item)
              delay(40)
              return
            end
          end
        end
      end
    end
  elseif hppercent() >= storage["ering"].max and defaultRing ~= nil then
    if getFinger() == nil or (getFinger():getId() ~= defaultRing:getId()) then
      ring = findItem(defaultRing:getId())
      if ring then
        moveToSlot(ring, SlotFinger)
      end
    end
  end
end, toolsTab)
AddScrolls("ering", toolsTab)
addSeparator("sep", toolsTab)

function conjuringScript(parent)
  local panelName = "conjureScript"
 
  local ui = setupUI([[
Panel
  height: 60
  margin-top: 2

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: title.left
    anchors.right: title.right
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 100
    step: 1

  BotTextEdit
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: scroll1.bottom
    margin-top: 3 
  
  ]], parent)
  ui:setId(panelName)
 
  if not storage[panelName] then
    storage[panelName] = {
      min = 5,
      text = "adori dodge"
    }
  end
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  ui.text.onTextChange = function(widget, text)
    storage[panelName].text = text
  end
  ui.text:setText(storage[panelName].text or "adori dodge")
 
  local updateText = function()
    ui.title:setText("Conjure Spell Soul > " .. storage[panelName].min)  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
 
  macro(25, function()
    if storage[panelName].enabled and storage[panelName].text:len() > 0 and soul() >= storage[panelName].min then
      if saySpell(storage[panelName].text, 500) then
        delay(200)
      end
    end
  end)
end
conjuringScript(toolsTab)
addSeparator("sep", toolsTab)

function comboScript(parent)
  if not parent then
    parent = panel
  end
 
  local panelName = "comboScriptPanel"
 
  local ui = setupUI([[
ThreeRowsItems < Panel
  height: 99
  margin-top: 2
  
  BotItem
    id: item1
    anchors.top: parent.top
    anchors.left: parent.left

  BotItem
    id: item2
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item3
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item4
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2

  BotItem
    id: item5
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item6
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2

  BotItem
    id: item7
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item8
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item9
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item10
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item11
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 2
    
  BotItem
    id: item12
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item13
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item14
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    
  BotItem
    id: item15
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    

Panel
  height: 135

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: title.left
    anchors.right: title.right
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 1
    maximum: 60
    step: 1

  ThreeRowsItems
    id: items
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom  
  ]], parent)
  ui:setId(panelName)
 
  if not storage[panelName] then
    storage[panelName] = {
      time = 31
    }
  end
 
  local updateText = function()
    ui.title:setText("Use every " .. storage[panelName].time .. " minutes")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].time = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].time)
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  if type(storage[panelName].items) ~= 'table' then
    storage[panelName].items = { 3215, 9642, 3726, 11454, 945, 10293, 10306, 10316, 11455 }
  end
 
  for i=1,15 do
    ui.items:getChildByIndex(i).onItemChange = function(widget)
      storage[panelName].items[i] = widget:getItemId()
    end
    ui.items:getChildByIndex(i):setItemId(storage[panelName].items[i])    
  end
 
  macro(1000, function()
    if not storage[panelName].enabled then
      return
    end
    storage.cavebot.enabled = false
	storage.attacking.enabled = false
    if #storage[panelName].items > 0 then
      timeOut = 5000
      for _, itemToUse in pairs(storage[panelName].items) do
        schedule(timeOut, function()
          use(itemToUse)
        end)
        timeOut = timeOut + 500
      end
    end
    schedule(timeOut + 5000, function()
      storage.cavebot.enabled = true
      storage.attacking.enabled = true
    end)
    delay((storage[panelName].time * 60000) - 1000)
  end)
end
comboScript(toolsTab)
addSeparator("sep", toolsTab)

function staminaItems(parent)
  if not parent then
    parent = panel
  end
  local panelName = "staminaItemsUser"
  local ui = setupUI([[
Panel
  height: 65
  margin-top: 2

  SmallBotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center

  HorizontalScrollBar
    id: scroll1
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: title.bottom
    margin-right: 2
    margin-top: 2
    minimum: 0
    maximum: 42
    step: 1
    
  HorizontalScrollBar
    id: scroll2
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 2
    minimum: 0
    maximum: 42
    step: 1    

  ItemsRow
    id: items
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
  ]], parent)
  ui:setId(panelName)

  if not storage[panelName] then
    storage[panelName] = {
      min = 25,
      max = 40,
    }
  end

  local updateText = function()
    ui.title:setText("" .. storage[panelName].min .. " <= stamina >= " .. storage[panelName].max .. "")  
  end
 
  ui.scroll1.onValueChange = function(scroll, value)
    storage[panelName].min = value
    updateText()
  end
  ui.scroll2.onValueChange = function(scroll, value)
    storage[panelName].max = value
    updateText()
  end
 
  ui.scroll1:setValue(storage[panelName].min)
  ui.scroll2:setValue(storage[panelName].max)
 
  ui.title:setOn(storage[panelName].enabled)
  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
 
  if type(storage[panelName].items) ~= 'table' then
    storage[panelName].items = { 11588 }
  end
 
  for i=1,5 do
    ui.items:getChildByIndex(i).onItemChange = function(widget)
      storage[panelName].items[i] = widget:getItemId()
    end
    ui.items:getChildByIndex(i):setItemId(storage[panelName].items[i])    
  end
 
  macro(500, function()
    if not storage[panelName].enabled or stamina() / 60 < storage[panelName].min or stamina() / 60 > storage[panelName].max then
      return
    end
    local candidates = {}
    for i, item in pairs(storage[panelName].items) do
      if item >= 100 then
        table.insert(candidates, item)
      end
    end
    if #candidates == 0 then
      return
    end    
    use(candidates[math.random(1, #candidates)])
  end)
end
staminaItems(toolsTab)
addSeparator("sep", toolsTab)

-- open Backpacks when reconnect
containers = getContainers()
if #containers < 1 and containers[0] == nil then
  bpItem = getBack()
  if bpItem ~= nil then
    g_game.open(bpItem)
  end
  say("!bless")
end

macro(10000, "Anti Idle",  function()
  local oldDir = direction()
  turn((oldDir + 1) % 4)
  schedule(1000, function() -- Schedule a function after 1000 milliseconds.
    turn(oldDir)
  end)
end)






-- magebomb.lua
-- config
local channel = "uniqueandsecretchannelname" -- you need to edit this to any random string

-- script
local mageBombTab = addTab("Batt")

local panelName = "magebomb"
local ui = setupUI([[
Panel
  height: 80

  BotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: MageBomb

  OptionCheckBox
    id: mageBombLeader
    anchors.left: prev.left
    text: MageBomb Leader
    margin-top: 3

  BotLabel
    id: bombLeaderNameInfo
    anchors.left: parent.left
    anchors.top: prev.bottom
    text: Leader Name:
    margin-top: 3

  BotTextEdit
    id: bombLeaderName
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
  ]], mageBombTab)
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
    mageBombLeader = false
  }
end
storage[panelName].mageBombLeader = false
ui.title:setOn(storage[panelName].enabled)
ui.title.onClick = function(widget)
  storage[panelName].enabled = not storage[panelName].enabled
  widget:setOn(storage[panelName].enabled)
end
ui.mageBombLeader.onClick = function(widget)
  storage[panelName].mageBombLeader = not storage[panelName].mageBombLeader
  widget:setChecked(storage[panelName].mageBombLeader)
  ui.bombLeaderNameInfo:setVisible(not storage[panelName].mageBombLeader)
  ui.bombLeaderName:setVisible(not storage[panelName].mageBombLeader)
end
ui.bombLeaderName.onTextChange = function(widget, text)
  storage[panelName].bombLeaderName = text
end
ui.bombLeaderName:setText(storage[panelName].bombLeaderName)

onPlayerPositionChange(function(newPos, oldPos)
  newTile = g_map.getTile(newPos)
  if newPos.z ~= oldPos.z then
    BotServer.send("goto", {pos=oldPos})
  end
end)
onAddThing(function(tile, thing)
  if not storage[panelName].mageBombLeader or not storage[panelName].enabled then
    return
  end
  if tile:getPosition().x == posx() and tile:getPosition().y == posy() and tile:getPosition().z == posz() and thing and thing:isEffect() then
    if thing:getId() == 11 then
      BotServer.send("goto", {pos=tile:getPosition()})
    end
  end
end)
onUse(function(pos, itemId, stackPos, subType)
  if itemId == 1948 or itemId == 7771 or itemId == 435 then
    BotServer.send("useItem", {pos=pos, itemId = itemId})
  end
end)
onUseWith(function(pos, itemId, target, subType)
  if itemId == 3155 then
    BotServer.send("useItemWith", {itemId=itemId, targetId = target:getId()})
  end
end)
-- onTalk(function(name, level, mode, text, channelId, pos)
--   -- info(text .. " " .. channelId)
-- end)
macro(100, function()
  if not storage[panelName].enabled or name() == storage[panelName].bombLeaderName then
    return
  end
  local target = g_game.getAttackingCreature()
  if target == nil and storage[panelName].bombLeaderName ~= nil and storage[panelName].bombLeaderName:len() > 0 and g_game.getFollowingCreature() == nil then
    leader = getPlayerByName(storage[panelName].bombLeaderName)
    if leader then
      g_game.follow(leader)
    end
  end
end, mageBombTab)
onCreatureAppear(function(creature)
  if storage[panelName].enabled and creature:getName() == storage[panelName].bombLeaderName then
    leader = getPlayerByName(storage[panelName].bombLeaderName)
    if leader then
      g_game.follow(leader)
    end
  end
end)
BotServer.init(name(), channel)
BotServer.listen("goto", function(senderName, message)
  if storage[panelName].enabled and name() ~= senderName and senderName == storage[panelName].bombLeaderName then
    position = message["pos"]
    if position.x ~= posx() or position.y ~= posy() or position.z ~= posz() then
      distance = getDistanceBetween(position, pos())
      autoWalk(position, distance * 2, { ignoreNonPathable = true, precision = 1 })
    end
  end
end)
BotServer.listen("useItem", function(senderName, message)
  if storage[panelName].enabled and name() ~= senderName and senderName == storage[panelName].bombLeaderName then
    position = message["pos"]
    if position.x ~= posx() or position.y ~= posy() or position.z ~= posz() then
      itemTile = g_map.getTile(position)
      for _, thing in ipairs(itemTile:getThings()) do
        if thing:getId() == message["itemId"] then
          g_game.use(thing)
        end
      end
    end
  end
end)
BotServer.listen("useItemWith", function(senderName, message)
  if storage[panelName].enabled and name() ~= senderName and senderName == storage[panelName].bombLeaderName then
    target = getCreatureById(message["targetId"])
    if target then
      usewith(message["itemId"], target)
    end
  end
end)

-- main.lua
Panels.TradeMessage()
Panels.AutoStackItems()

addButton("discord", "Discord & Help", function()
  g_platform.openUrl("https://discord.me/Demolidores")
end)

addButton("forum", "Forum", function()
  g_platform.openUrl("https://www.demolidores.com.br/?subtopic=forum")
end)

addSeparator("sep")

function clickReuse(parent)
  if not parent then
    parent = panel
  end
  local ui = setupUI([[
Panel
  height: 20
  margin-top: 2

  BotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Click Reuse
    ]], parent)
  ui:setId("clickReuse")

  ui.title:setOn(storage.clickReuse)
  ui.title.onClick = function(widget)
    storage.clickReuse = not storage.clickReuse
    widget:setOn(storage.clickReuse)
  end
  onUseWith(function(pos, itemId, target, subType)
    if storage.clickReuse then
      schedule(50, function()
        item = findItem(itemId)
        if item then
          modules.game_interface.startUseWith(item)
        end
      end)
    end
  end)
end
clickReuse()

-- mwall_timer.lua
-- Magic wall & Wild growth timer
--[[
Timer for magic wall and wild growth
Set correctly config, that's all you have to do
Author: otclient@otclient.ovh
]]--

-- config
local magicWallId = 2129
local magicWallTime = 20000
local wildGrowthId = 2130
local wildGrowthTime = 45000
local superMagicWallId = 7925
local superMagicWallTime = 16000

-- script
local activeTimers = {}

onAddThing(function(tile, thing)
  if not thing:isItem() then
    return
  end
  local timer = 0
  if thing:getId() == magicWallId then
    timer = magicWallTime
  elseif thing:getId() == wildGrowthId then
    timer = wildGrowthTime
  elseif thing:getId() == superMagicWallId then
    timer = superMagicWallTime
  else
    return
  end
  
  local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
  if not activeTimers[pos] or activeTimers[pos] < now then    
    activeTimers[pos] = now + timer
  end
  tile:setTimer(activeTimers[pos] - now)
end)

onRemoveThing(function(tile, thing)
  if not thing:isItem() then
    return
  end
  if (thing:getId() == magicWallId or thing:getId() == wildGrowthId or thing:getId() == superMagicWallId) and tile:getGround() then
    local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
    activeTimers[pos] = nil
    tile:setTimer(0)
  end  
end)

-- npc.lua

-- tools.lua
local toolsTab = addTab("Tools")

function autoExiva(parent)
  if not parent then
    parent = panel
  end

  panelName = "autoExiva"
  local ui = setupUI([[
Panel
  height: 80
  margin-top: 2

  BotSwitch
    id: title
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Auto exiva every 500

  BotTextEdit
    id: spellWords
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3

  BotTextEdit
    id: playerName
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3

  HorizontalScrollBar
    id: timeout
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-right: 2
    margin-top: 3
    minimum: 1
    maximum: 200
    step: 1
  ]], parent)
  ui:setId(panelName)
  if not storage[panelName] then
    storage[panelName] = {
      spellWords = "exiva",
      playerName = "",
      timeout = 5
    }
  end

  ui.title.onClick = function(widget)
    storage[panelName].enabled = not storage[panelName].enabled
    widget:setOn(storage[panelName].enabled)
  end
  ui.spellWords.onTextChange = function(widget, text)
    storage[panelName].spellWords = text
  end
  ui.playerName.onTextChange = function(widget, text)
    storage[panelName].playerName = text
  end
  local updateText = function()
    ui.title:setText("Exiva every " .. storage[panelName].timeout .. " seconds")  
  end
  ui.timeout.onValueChange = function(scroll, value)
    storage[panelName].timeout = value
    updateText()
  end
  ui.spellWords:setText(storage[panelName].spellWords)
  ui.playerName:setText(storage[panelName].playerName)
  ui.timeout:setValue(storage[panelName].timeout)

  onTalk(function(pname, level, mode, text, channelId, pos)
    if pname == name() and string.match(text, "exiva") then
      playerName = string.match(text, '"(.+)"')
      if playerName:len() > 0 then
        storage[panelName].playerName = playerName
        ui.playerName:setText(storage[panelName].playerName)
      end
    end
  end)

  macro(100, function()
    if storage[panelName].enabled and storage[panelName].spellWords:len() > 0 and storage[panelName].playerName:len() > 0 then
      saySpell(storage[panelName].spellWords .. ' "' .. storage[panelName].playerName)
      delay(storage[panelName].timeout * 1000)
    end
  end)
end
autoExiva(toolsTab)
macro(1000, "exchange money", function()
  local containers = getContainers()
  for i, container in pairs(containers) do
    for j, item in ipairs(container:getItems()) do
      if item:isStackable() and (item:getId() == 3035 or item:getId() == 3031 or item:getId() == 3043) and item:getCount() == 100 then
        g_game.use(item)
        return
      end
    end
  end
end)

function superDash(parent)
 if not parent then
    parent = panel
  end
  local switch = g_ui.createWidget('BotSwitch', parent)
  switch:setId("superDashButton")
  switch:setText("Super Dash")
  switch:setOn(storage.superDash)
  switch.onClick = function(widget)    
    storage.superDash = not storage.superDash
    widget:setOn(storage.superDash)
  end

  onKeyPress(function(keys)
    if not storage.superDash then
      return
    end
    consoleModule = modules.game_console
    if (keys == "W" and not consoleModule:isChatEnabled()) or keys == "Up" then
      moveToTile = g_map.getTile({x = posx(), y = posy()-1, z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx(), y = posy()-6, z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "A" and not consoleModule:isChatEnabled()) or keys == "Left" then
      moveToTile = g_map.getTile({x = posx()-1, y = posy(), z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx()-6, y = posy(), z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "S" and not consoleModule:isChatEnabled()) or keys == "Down" then
      moveToTile = g_map.getTile({x = posx(), y = posy()+1, z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx(), y = posy()+6, z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    elseif (keys == "D" and not consoleModule:isChatEnabled()) or keys == "Right" then
      moveToTile = g_map.getTile({x = posx()+1, y = posy(), z = posz()})
      if moveToTile and not moveToTile:isWalkable(false) then
        moveToPos = {x = posx()+6, y = posy(), z = posz()}
        dashTile = g_map.getTile(moveToPos)
        if dashTile then
          g_game.use(dashTile:getTopThing())
        end
      end
    end
  end)
end
superDash()

macro(100, "debug pathfinding", nil, function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    tile:setText("")
  end
  local path = findEveryPath(pos(), 20, {
    ignoreNonPathable = false
  })
  local total = 0
  for i, p in pairs(path) do
    local s = i:split(",")
    local pos = {x=tonumber(s[1]), y=tonumber(s[2]), z=tonumber(s[3])}
    local tile = g_map.getTile(pos)
    if tile then
      tile:setText(p[2])
    end
     total = total + 1
  end
end)



local positionLabel = addLabel("positionLabel", "")
onPlayerPositionChange(function()
  positionLabel:setText("Pos: " .. posx() .. "," .. posy() .. "," .. posz())
end)

local s = addSwitch("sdSound", "Play sound when using sd", function(widget)
  storage.sdSound = not storage.sdSound
  widget:setOn(storage.sdSound)
end)
s:setOn(storage.sdSound)

onUseWith(function(pos, itemId)
  if storage.sdSound and itemId == 3150 then
    playSound("/sounds/magnum.ogg")
  end
end)







-- if you want add custom scripts, just add them bellow or create new lua file

macro(50, "trapa alvo MW", function()
function lanca(x,y)
	local target = g_game.getAttackingCreature()
	local tpos = target:getPosition()
	local pos = {x=tpos.x + x, y=tpos.y + y, z=tpos.z}
	local tile = g_map.getTile(pos)   
	if tile and tile:isWalkable(false) then -- if can throw magic wall
		usewith(3180, tile:getGround()) -- use wild growth, magic wall is 3180
	return true
	end
	return false
  end

local attacking = g_game.getAttackingCreature()
	if attacking then
		local target = g_game.getAttackingCreature()
		local tpos = target:getPosition()
		xx = posx()-tpos.x
		yy = posy()-tpos.y
		info("xx: ".. xx .. " yy: " .. yy)
		if yy > 0 then
			lanca(0, -1)
			lanca(-1, -1)
			lanca(1, -1)
		end
		if xx > 0 then
			lanca(-1, -1)
			lanca(-1, 0)
			lanca(-1, 1)
		end
		if yy < 0 then
			lanca(-1,1)
			lanca(0,1)
			lanca(1,1)
		end
		if xx < 0 then
			lanca(1, -1)
			lanca(1, 0)
			lanca(1, 1)
		end	
	end
end
)

macro(50, "trapa alvo", function()
function lanca(x,y)
	local target = g_game.getAttackingCreature()
	local tpos = target:getPosition()
	local pos = {x=tpos.x + x, y=tpos.y + y, z=tpos.z}
	local tile = g_map.getTile(pos)   
	if tile and tile:isWalkable(false) then -- if can throw magic wall
		usewith(3183, tile:getGround()) -- use wild growth, magic wall is 3180
	return true
	end
	return false
  end

local attacking = g_game.getAttackingCreature()
	if attacking then
	lanca(0,1)
	lanca(0,-1)
	lanca(1,-1)
	lanca(-1,1)
	lanca(1,0)
	lanca(-1,0)
	lanca(1,1)
	lanca(-1,-1)
	end

end
)


macro(100, "Muro Wildgrowth", function ()
  function lanca(x,y)
	local tpos = player:getPosition()
	local pos = {x=tpos.x + x, y=tpos.y + y, z=tpos.z}
	local tile = g_map.getTile(pos)   
	if tile and tile:isWalkable(false) then -- if can throw magic wall
		usewith(3156, tile:getGround()) -- use wild growth, magic wall is 3180
	return true
	end
	return false
  end

   lanca(3,3)
   lanca(2,3)
   lanca(1,3)
   lanca(0,3)
   lanca(-1,3)
   lanca(-2,3)
   lanca(-3,3)
   lanca(-3,2)
   lanca(-3,1)
   lanca(-3,0)
   lanca(-3,-1)
   lanca(-3,-2)
   lanca(-3,-3)
   lanca(-2,-3)
   lanca(-1,-3)
   lanca(0,-3)
   lanca(1,-3)
   lanca(2,-3)
   lanca(3,-3)
   lanca(3,-2)
   lanca(3,-1)
   lanca(3,0)
   lanca(3,1)
   lanca(3,2)
   lanca(3,3)
end, toolsTab)


macro(100, "Muro MW", function ()
  function lanca(x,y)
	local tpos = player:getPosition()
	local pos = {x=tpos.x + x, y=tpos.y + y, z=tpos.z}
	local tile = g_map.getTile(pos)   
	if tile and tile:isWalkable(false) and tile:isFullGround() then -- if can throw magic wall
		usewith(3180, tile:getGround()) -- use wild growth, magic wall is 3180
	return true
	end
	return false
  end

   lanca(3,3)
   lanca(2,3)
   lanca(1,3)
   lanca(0,3)
   lanca(-1,3)
   lanca(-2,3)
   lanca(-3,3)
   lanca(-3,2)
   lanca(-3,1)
   lanca(-3,0)
   lanca(-3,-1)
   lanca(-3,-2)
   lanca(-3,-3)
   lanca(-2,-3)
   lanca(-1,-3)
   lanca(0,-3)
   lanca(1,-3)
   lanca(2,-3)
   lanca(3,-3)
   lanca(3,-2)
   lanca(3,-1)
   lanca(3,0)
   lanca(3,1)
   lanca(3,2)
   lanca(3,3)
end, toolsTab)

  function temPlayer()
   for _, spec in ipairs(getSpectators()) do
    if spec:isPlayer() and spec:getName() ~= name() then
		info("Jogador: ".. spec:getName())
		return 1
	end
	end
	return 0
  end
  

  
function correr(xx,yy)
			local position = {x=xx, y=yy, z=posz()}
			local distance = 0
			distance = getDistanceBetween(position, player:getPosition())
			autoWalk(position, distance *2, { marginmin = 1, marginmax = 1, ignoreNonPathable = false, precision = 10 })
			--local path = getPath(player:getPosition(), position, distance *2, {marginMax = 1000, marginmin = 1, precision = 1, ignoreNonPathable = true,})
			--walk(path[1])
            return	
	end


 macro(100, "Corre", function()
 	if temPlayer() == 1 then
		storage.cavebot.enabled = false
		storage.attacking.enabled = false
		g_game.cancelAttackAndFollow() 
			correr(39173,38460)
		acionou = true
	end
	if temPlayer() == 0 and acionou == true then
		storage.attacking.enabled = true
		storage.cavebot.enabled = true
		acionou = false
	end
   end)
   
   
   
macro(100, "Mana Friend", function()
   
       local player = getPlayerByName("Nemo druid dois [16]")
 	   useWith(238, player)
	   return
end)



macro(1000, "teste", function()
	info("Lvl: " .. player:getLevel())
	storage.cavebot.gotoLabel("start")
end)


function mppc()
 return math.floor(player:getMana() * 100 / player:getMaxMana())
end

function hppc()
 return math.floor(player:getHealth() * 100 / player:getMaxHealth())
end

asafe = false

macro(100, "Cavebot Safe", function()
	if mppc() > 50 and hppc() > 90 and storage.attacking.enabled == true and asafe == true then
		storage.cavebot.enabled = true
		asafe = false
	end
	if mppc() <= 50 or hppc() <= 90 then
		storage.cavebot.enabled = false
		asafe = true
		delay(500)
	end
	end
)



function cataLoot(xx,yy,id)
	local tpos = player:getPosition()
	local sqm =  g_map.getTile({x=tpos.x + xx, y=tpos.y + yy, z=tpos.z})
	local topThing = sqm:getTopUseThing()
	for _, thing in ipairs(sqm:getThings()) do
		if topThing and topThing:getId() == id then
			info("X8 encontrada")
			for _, container in pairs(getContainers()) do
				for j, bpItem in ipairs(container:getItems()) do
					g_game.move(topThing, container:getSlotPosition(j - 1), 1)
				end
			end
		end
	end
end
 
macro(100, "Loot X8", function()
	cataLoot(-1,1, 3726)
	cataLoot(-1,0, 3726)
	cataLoot(-1,-1, 3726)
	cataLoot(0,1, 3726)
	cataLoot(0,-1, 3726)
	cataLoot(1,-1, 3726)
	cataLoot(1,0, 3726)
	cataLoot(1,1, 3726)
end
)

 macro(100, "Maker AOL", function()
	
	if getNeck() == nil then
		say("!aol")
		delay(2000)
	end
   end)
   
   
function usaSemente(xx,yy)
	local tpos = player:getPosition()
	local sqm =  g_map.getTile({x=tpos.x + xx, y=tpos.y + yy, z=tpos.z})
	local topThing = sqm:getTopUseThing()
	if topThing and topThing:getId() == 647 and topThing:getCount() == 1 then
		info("plantando x:" .. xx .. " y:" .. yy)
        return g_game.use(topThing)
	end
	if topThing and topThing:getId() == 647 and topThing:getCount() > 1 then
		cataLoot(xx,yy,647)
	end
end

function dropaSemente(xx,yy)
	local tpos = player:getPosition()
	local sqm =  g_map.getTile({x=tpos.x + xx, y=tpos.y + yy, z=tpos.z})
	local topThing = sqm:getTopUseThing()
	for _, thing in ipairs(sqm:getThings()) do
		if thing:getId() == 950 and topThing:getId() ~= 647 and topThing:getId() ~= 6215 and topThing:getId() ~= 3693 and topThing:getId() ~= 3698 and topThing:getId() ~= 3726 then
			for _, container in pairs(getContainers()) do
				for _, semente in ipairs(container:getItems()) do
					containerItem = container:getContainerItem():getId()
					if semente:getId() == 647 and semente:getCount() >= 1 then
					info("Jogando semente x:" .. xx .. " y:" .. yy)
					return g_game.move(semente, {x=tpos.x + xx, y=tpos.y + yy, z=tpos.z}, 1)
					end
				end
			end
	end
	end
	return
end

function lavra(xx,yy)
	local tpos = player:getPosition()
	local sqm =  g_map.getTile({x=tpos.x + xx, y=tpos.y + yy, z=tpos.z})
	local topThing = sqm:getTopUseThing()
	if canStandBy(sqm:getPosition()) then
		for _, thing in ipairs(sqm:getThings()) do
 		 if ( thing:getId() == 103 or thing:getId() == 3698 ) and topThing:getId() ~= 647 and topThing:getId() ~= 6215 and topThing:getId() ~= 3693 and topThing:getId() ~= 3035 and topThing:getId() ~= 3031 then
		 info("Arando x:" .. xx .. " y:" .. yy)
		 if topThing:getId() == 3698 then
			useWith(3455,topThing)
			return true
		else
			useWith(3455,thing)
			return true
		 end	
		 end
		end
	end
	return false
end

plantando = 0
 
macro(1000, "Lavrar e plantar", function()

if plantando == 0 then
plantando = 1
	lavra(-1,1)
	dropaSemente(-1,1)
    usaSemente(-1,1)
	delay(500)
	
	
	lavra(-1,0)
	dropaSemente(-1,0)
    usaSemente(-1,0)
	delay(500)
	
	lavra(-1,-1)
	dropaSemente(-1,-1)
    usaSemente(-1,-1)
	delay(500)
	
	lavra(1,1)
	dropaSemente(1,1)
	usaSemente(1,1)
	delay(500)
	
	lavra(1,0)
	dropaSemente(1,0)
	usaSemente(1,0)
	delay(500)
	
	lavra(1,-1)
	dropaSemente(1,-1)
	usaSemente(1,-1)
	delay(500)	
	
	lavra(0,-1)
	dropaSemente(0,-1)
	usaSemente(0,-1)
	delay(500)	
	
	lavra(0,1)
	dropaSemente(0,1)
	usaSemente(0,1)
	delay(500)	
plantando = 0
end
 

macro(100, "Corta mato", function()
	for x=-2,2,1 do
		for y=-2,2,1 do
			local sqm =  g_map.getTile({x=posx() + x, y=posy() + y, z=posz()})
			local topThing = sqm:getTopUseThing()
			if topThing:getId() == 2130 then
				useWith(3308,topThing)
			end
		end
	end
end)


-- config

local keyUp = "="
local keyDown = "-"


-- script

local lockedLevel = pos().z
local m = macro(1000, "Spy Level", function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if oldPos.z ~= newPos.z then
        lockedLevel = pos().z
        modules.game_interface.getMapPanel():unlockVisibleFloor()
    end
end)

onKeyPress(function(keys)
    if m.isOn() then
        if keys == keyDown then
            lockedLevel = lockedLevel + 1
            modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
        elseif keys == keyUp then
            lockedLevel = lockedLevel - 1
            modules.game_interface.getMapPanel():lockVisibleFloor(lockedLevel)
        end
    end
end)




