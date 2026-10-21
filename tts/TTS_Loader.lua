--[[ Tabletop Simulator Cast Loader Script
     Written for Monumentum Cast Recruiter
     Date: Sunday, 7 June 2026
     
     INSTRUCTIONS:
     1. Right-click your scripting token in TTS and select Scripting > Scripting Editor.
     2. Paste this entire LUA code into the editor.
     3. Create one Scripting Trigger Zone (Tools > Scripting Trigger Zone) on your table and
        place it where the single Cast deck is kept. That one deck now holds all 200 cards:
        champions, companions, familiars, minions, talismans, signatures and special actions.
     4. Paste the GUID of that trigger zone below in CAST_ZONE_GUID.
     5. Click Save & Play!
--]]

-- =============== CONFIGURATION GUIDs (REQUIRED) ===============
-- Place scripting zones over your decks on the table and enter their GUIDs below.
CAST_ZONE_GUID       = "83f62b" -- Zone containing the single Cast deck (all 200 cards)
MODELS_ZONE_GUID     = "fe2114" -- Zone containing the 3D Models Bag (Task 3)

-- =============== MAP DEPLOYMENT CONFIGURATION (ONBOARDING) ===============
-- GUIDs for the Path Tiles and Font Tiles scripting zones on your table.
MAP_TILE_ZONE_GUID   = "193b90" -- Zone containing the Path/Grid tile deck
MAP_FONT_ZONE_GUID   = "547581" -- Zone containing the Font tile deck

MAP_SPACING          = 4.0      -- Physical spacing distance between tiles
MAP_START_POS        = { x = -10, y = 0.21, z = 10 } -- Top-left corner spawn coordinate


-- =============== PLAYER LAYOUT CONFIGURATION ===============
-- [Zones Option] You can specify scripting zones where each player's characters should spawn on the table!
-- Leave them as "XXXXXX" and "YYYYYY" to use the fallback raw coordinates instead.
PLAYER_CONFIG = {
    [1] = { -- Player 1 (Red / Bottom)
        cast_zone_guid      = "0b3e6a", -- Scripting zone for the character cards (row 1) and talismans (row 2)
        character_zone_guid = "e493d9", -- Old layout zone; still cleared on reload if it is on the table
        special_zone_guid   = "XXXXXX", -- Zone where Special Actions are placed (Leave as "XXXXXX" to deal to hand instead)
        table_zone = { x = -15, y = 1.5, z = -5 },   -- Fallback coordinates if zone is not set
        special_dest = { x = -25, y = 2.0, z = -15 }, -- Fallback specials hand/dest area
        color = "Red"                                 -- TTS Player Seat color
    },
    [2] = { -- Player 2 (Blue / Top)
        cast_zone_guid      = "b37844", -- Scripting zone for the character cards (row 1) and talismans (row 2)
        character_zone_guid = "7faf07", -- Old layout zone; still cleared on reload if it is on the table
        special_zone_guid   = "YYYYYY", -- Zone where Special Actions are placed
        table_zone = { x = 15, y = 1.5, z = 5 },
        special_dest = { x = 25, y = 2.0, z = 15 },
        color = "Blue"
    }
}

-- Temp spawning height offset to prevent collisions
SPAWN_HEIGHT_OFFSET = 3.0  -- Originals are lifted this far above their deck or bag while they are cloned

-- Time (in seconds) to wait between card spawns inside active layout zones
ZONE_LAYOUT_DELAY = 0.3

-- Card grid inside each cast zone. Row 1 is the row nearest the board (character cards), row 2
-- sits behind it (talismans, each behind the character it is attached to). Spacing shrinks to fit
-- if the zone is too narrow or shallow for these values.
BOARD_CENTRE        = { x = 0, z = 0 } -- The map is centred on the table origin (see MAP_START_POS)
CARD_COLUMN_SPACING = 2.6   -- Distance between card centres along a row
CARD_ROW_SPACING    = 3.6   -- Distance between row centres
CARD_LIFT           = 0.2   -- Cards spawn this far above the surface under their slot
MODEL_LIFT          = 0.4   -- Models spawn this far above their card
CARD_YAW_OFFSET     = 0     -- Set to 180 if the cards come out upside down for the player
MODEL_SPACING       = 1.8   -- Distance between copies of one model; they spread along their card
MODEL_SPREAD_MAX    = 2.4   -- Copies never spread further than this, so they stay on the card

-- =============== ONBOARDING SCENARIOS CONFIGURATION ===============
-- Pre-configured cast lists for the learning scenarios (Task 5).
-- You can modify these lists of IDs to customize the onboarding scenarios.
ONBOARDING_SCENARIOS = {
    ["Flint"] = { -- Rhavlika Dominion
        [1] = {
            championId = "",
            unitIdsRecruited = { ["01RHA-03FAM-0005"] = 1, ["01RHA-03FAM-0006"] = 1 },
            talismanIdsEquipped = {},
            specialIds = {},
            dominion = "Rhavlika",
            champion = "Flint Dross"
        },
        [2] = {
            championId = "",
            unitIdsRecruited = { ["01RHA-03FAM-0005"] = 1, ["01RHA-03FAM-0006"] = 1 },
            talismanIdsEquipped = {},
            specialIds = { "01RHA-07SPA-0023", "01RHA-07SPA-0025" },
            dominion = "Rhavlika",
            champion = "Flint Dross"
        },
        [3] = {
            championId = "01RHA-01CHP-0001",
            unitIdsRecruited = { ["01RHA-03FAM-0005"] = 1, ["01RHA-03FAM-0006"] = 1, ["01RHA-03FAM-0007"] = 2 },
            talismanIdsEquipped = {},
            specialIds = { "01RHA-07SPA-0023", "01RHA-07SPA-0025", "01RHA-07SPA-0022", "01RHA-07SPA-0030" },
            dominion = "Rhavlika",
            champion = "Flint Dross"
        },
        [4] = {
            championId = "01RHA-01CHP-0001",
            unitIdsRecruited = { ["01RHA-03FAM-0005"] = 2, ["01RHA-03FAM-0006"] = 3, ["01RHA-03FAM-0007"] = 3 },
            talismanIdsEquipped = {},
            specialIds = { "01RHA-07SPA-0023", "01RHA-07SPA-0025", "01RHA-07SPA-0022", "01RHA-07SPA-0030", "01RHA-07SPA-0019", "01RHA-07SPA-0021" },
            dominion = "Rhavlika",
            champion = "Flint Dross"
        }
    },
    ["Ripple"] = { -- Iro-Si-Khar Dominion
        [1] = {
            championId = "",
            unitIdsRecruited = { ["02IRO-03FAM-0038"] = 1, ["02IRO-03FAM-0039"] = 1 },
            talismanIdsEquipped = {},
            specialIds = {},
            dominion = "Iro-Si-Khar",
            champion = "Ripple Elshara"
        },
        [2] = {
            championId = "",
            unitIdsRecruited = { ["02IRO-03FAM-0038"] = 1, ["02IRO-03FAM-0039"] = 1 },
            talismanIdsEquipped = {},
            specialIds = { "02IRO-07SPA-0055", "02IRO-07SPA-0058" },
            dominion = "Iro-Si-Khar",
            champion = "Ripple Elshara"
        },
        [3] = {
            championId = "02IRO-01CHP-0034",
            unitIdsRecruited = { ["02IRO-03FAM-0038"] = 1, ["02IRO-03FAM-0039"] = 1, ["02IRO-03FAM-0040"] = 2 },
            talismanIdsEquipped = {},
            specialIds = { "02IRO-07SPA-0055", "02IRO-07SPA-0058", "02IRO-07SPA-0057", "02IRO-07SPA-0064"},
            dominion = "Iro-Si-Khar",
            champion = "Ripple Elshara"
        },
        [4] = {
            championId = "02IRO-01CHP-0034",
            unitIdsRecruited = { ["02IRO-03FAM-0038"] = 3, ["02IRO-03FAM-0039"] = 3, ["02IRO-03FAM-0040"] = 3 },
            talismanIdsEquipped = {},
            specialIds = { "02IRO-07SPA-0055", "02IRO-07SPA-0058", "02IRO-07SPA-0057", "02IRO-07SPA-0064", "02IRO-07SPA-0056", "02IRO-07SPA-0062" },
            dominion = "Iro-Si-Khar",
            champion = "Ripple Elshara"
        }
    },
    ["Lark"] = { -- Voisira Dominion
        [1] = {
            championId = "",
            unitIdsRecruited = { ["03VOI-03FAM-0073"] = 1, ["03VOI-03FAM-0078"] = 1 },
            talismanIdsEquipped = {},
            specialIds = {},
            dominion = "Voisira",
            champion = "Lark"
        },
        [2] = {
            championId = "",
            unitIdsRecruited = { ["03VOI-03FAM-0073"] = 1, ["03VOI-03FAM-0078"] = 1 },
            talismanIdsEquipped = {},
            specialIds = { "03VOI-07SPA-0095", "03VOI-07SPA-0090"  },
            dominion = "Voisira",
            champion = "Lark"
        },
        [3] = {
            championId = "03VOI-01CHP-0068",
            unitIdsRecruited = { ["03VOI-03FAM-0072"] = 1, ["03VOI-03FAM-0073"] = 2, ["03VOI-03FAM-0078"] = 1 },
            talismanIdsEquipped = {},
            specialIds = { "03VOI-07SPA-0095", "03VOI-07SPA-0090", "03VOI-07SPA-0087", "03VOI-07SPA-0091"  },
            dominion = "Voisira",
            champion = "Lark"
        },
        [4] = {
            championId = "03VOI-01CHP-0068",
            unitIdsRecruited = { ["03VOI-03FAM-0072"] = 3, ["03VOI-03FAM-0073"] = 3, ["03VOI-03FAM-0078"] = 3 },
            talismanIdsEquipped = {},
            specialIds = { "03VOI-07SPA-0095", "03VOI-07SPA-0090", "03VOI-07SPA-0087", "03VOI-07SPA-0091", "03VOI-07SPA-0086", "03VOI-07SPA-0089"  },
            dominion = "Voisira",
            champion = "Lark"
        }
    }
}


-- =============== WEBHOOK & GAME RECORD CONFIGURATION ===============
-- Global tables for tracking match state and logged actions
loadedCasts = {}          -- Loaded cast configurations keyed by player colour
specialActionsLog = {}    -- Chronological record of Special Actions played
spawnedObjects = {}       -- GUIDs of the cards and models each load put on the table, keyed by player colour

-- Global tracking tables and JSON snapshots for map auto-deployment
deployedMapTiles = {}
deployedMapFonts = {}
savedTileDeckJSON = nil
savedFontDeckJSON = nil

-- Global parameter storage to pass arguments safely into the coroutine
local activeCoroutineParams = nil

-- Global lock to synchronize asynchronous card-cloning operations
local isCloning = false

-- Global lock preventing overlapping loadCastCoroutine runs (TTS allows only one active
-- coroutine per object, but a second click while loading fails silently without this check)
local isLoadingCast = false

function onLoad(saved_data)
    print("Monumentum Cast Loader initialised.")

    -- Restore the match record saved with the table, so a crash, rewind or reload mid-game
    -- doesn't leave End Game with no casts to submit (2026-10-08 playtest).
    restoreMatchData(saved_data)
    self.setName("Monumentum Cast Loader")
    self.setDescription("Drafts your Cast lists on the table using zones.")
    
    -- Seed random number generator
    math.randomseed(os.time())
    
    -- Setup Onboarding XML UI dynamically (Task 5)
    setupXmlUi()
    
    -- Draw classic 3D Lua buttons flat on the token surface (Matching your exact tile style!)
    drawButtons()
    
    -- Proactively cache the map decks after a brief moment to allow physics to settle
    Wait.time(function() captureMapDecks() end, 1.5)
end

function drawButtons()
    self.clearButtons()
    
    -- Load Player 1 Button (Red / Top) - Shifted forward (Z = -0.7)
    self.createButton({
        click_function = "btnLoadPlayer1",
        function_owner = self,
        label          = "Load Red Player",
        position       = {0, 0.2, -0.7},
        rotation       = {0, 0, 0},
        width          = 1600,
        height         = 350,
        font_size      = 170,
        color          = {192/255, 57/255, 43/255}, -- Red color
        font_color     = {1, 1, 1}
    })

    -- Load Player 2 Button (Blue / Middle) - Shifted backward (Z = 0)
    self.createButton({
        click_function = "btnLoadPlayer2",
        function_owner = self,
        label          = "Load Blue Player",
        position       = {0, 0.2, 0},
        rotation       = {0, 0, 0},
        width          = 1600,
        height         = 350,
        font_size      = 170,
        color          = {41/255, 128/255, 185/255}, -- Blue color
        font_color     = {1, 1, 1}
    })

    -- Launch Onboarding Menu Button (Purple / Bottom-most) - Shifted further backward (Z = 0.7)
    self.createButton({
        click_function = "btnToggleOnboarding",
        function_owner = self,
        label          = "Onboarding Menu",
        position       = {0, 0.2, 0.7},
        rotation       = {0, 0, 0},
        width          = 1600,
        height         = 350,
        font_size      = 170,
        color          = {155/255, 89/255, 182/255}, -- Purple color
        font_color     = {1, 1, 1}
    })
end

-- Load Player 1 (Red) Trigger
function btnLoadPlayer1(obj, player_color, alt_click)
    -- Native TTS Player Input Prompt Box (using Lua function callbacks)
    Player[player_color].showInputDialog("Player 1 (Red): Paste Cast JSON", "", function(text, color)
        submitCast1(text, color)
    end)
end

-- Load Player 2 (Blue) Trigger
function btnLoadPlayer2(obj, player_color, alt_click)
    Player[player_color].showInputDialog("Player 2 (Blue): Paste Cast JSON", "", function(text, color)
        submitCast2(text, color)
    end)
end

-- Native Submit Callbacks
function submitCast1(text, color)
    processPastedCast(1, Player[color], text)
end

-- Native Submit Callbacks
function submitCast2(text, color)
    processPastedCast(2, Player[color], text)
end

function processPastedCast(playerNum, player, jsonText)
    if isLoadingCast then
        broadcastToColor("A cast is already loading — please wait for it to finish.", player.color, {1, 0, 0})
        return
    end

    if jsonText == nil or jsonText == "" then
        broadcastToColor("Paste field was empty! Please copy the exported JSON from your cast builder.", player.color, {1,0,0})
        return
    end

    -- Parse JSON
    local success, castData = pcall(function() return JSON.decode(jsonText) end)
    if not success or not castData then
        broadcastToColor("Error: Invalid JSON format. Make sure you copied the entire exported text from your browser.", player.color, {1,0,0})
        return
    end

    -- Store the parsed cast data into our global tracking table
    local playerColour = PLAYER_CONFIG[playerNum].color
    loadedCasts[playerColour] = castData

    -- Store arguments in global parameter storage before running coroutine
    activeCoroutineParams = {playerNum = playerNum, clickerColor = player.color, castData = castData}

    -- Run Loader Coroutine
    isLoadingCast = true
    startLuaCoroutine(self, "loadCastCoroutine")
end

-- Clears previous cards in hand and models in zone for the given player to allow fresh redraws
function clearPlayerWorkspace(playerNum)
    local config = PLAYER_CONFIG[playerNum]
    if not config then return end
    
    local color = config.color
    
    -- 1. Clear Player's Hand
    if Player[color] then
        local handObjects = Player[color].getHandObjects()
        if handObjects then
            for _, obj in ipairs(handObjects) do
                if obj and not obj.isDestroyed() then
                    destroyObject(obj)
                end
            end
        end
    end
    
    -- 2. Clear the cards and models the last load put on the table, wherever they are now
    for _, guid in ipairs(spawnedObjects[color] or {}) do
        local obj = getObjectFromGUID(guid)
        if obj and not obj.isDestroyed() then
            destroyObject(obj)
        end
    end
    spawnedObjects[color] = {}

    -- 3. Clear the old character layout zone, if it is still on the table
    if config.character_zone_guid and config.character_zone_guid ~= "XXXXXX" and config.character_zone_guid ~= "" then
        local zone = getObjectFromGUID(config.character_zone_guid)
        if zone then
            for _, obj in ipairs(zone.getObjects()) do
                -- Prevent destroying the zone itself or other vital objects
                if obj and obj.getGUID() ~= config.character_zone_guid then
                    if obj ~= self and obj.type ~= "Table" and obj.type ~= "Zone" then
                        destroyObject(obj)
                    end
                end
            end
        end
    end
end

-- Coroutine to handle step-by-step take, clone, and return operations smoothly
function loadCastCoroutine()
    -- Safely retrieve parameters from global storage (TTS coroutines do not accept arguments)
    local params = activeCoroutineParams
    activeCoroutineParams = nil -- Clear immediately
    
    if not params then isLoadingCast = false; return 1 end
    
    local playerNum = params.playerNum
    local clickerColor = params.clickerColor
    local castData = params.castData
    
    local config = PLAYER_CONFIG[playerNum]
    local spawnPos = config.special_dest -- Safe temporary spawn coordinates before dealing to hand
    local targetModelRot = (config.color == "Red") and {0, 270, 0} or {0, 90, 0}
    
    -- Clear previous cards in hand and models in zone for a clean fresh redraw (Tweak 1)
    clearPlayerWorkspace(playerNum)
    yieldSeconds(0.4) -- Wait a brief moment for the physics engine to register removals
    
    -- If Player 1 (Red / Bottom) loads their cast, automatically handle map deployment in parallel
    if playerNum == 1 then
        local scenarioNum = castData.scenarioNum or 4 -- Default to Scenario 4 (Full standard game)
        deployScenarioMap(scenarioNum, clickerColor)
    end
    
    broadcastToAll("Loading Cast for Player " .. playerNum .. " (" .. (castData.dominion or "Unknown") .. " - " .. (castData.champion or "Unknown") .. ")...", {0.1, 0.8, 0.1})
    
    -- Initial verification: Verify decks are strictly present in trigger zones before loading
    local initialCastDeck = findCastDeck()
    if not initialCastDeck then
        broadcastToColor("Error: Could not find any Deck/Card in the Cast Trigger Zone. Check your CAST_ZONE_GUID.", clickerColor, {1,0,0})
        isLoadingCast = false
        return 1
    end
    
    -- Reduced onboarding scenarios (Scenarios 1 & 2) should not load the Champion card/standee, or minion tokens (Tweak 2)
    local isReducedScenario = (castData.scenarioNum ~= nil and (castData.scenarioNum == 1 or castData.scenarioNum == 2))
    local hasAutoMinion = (castData.dominion == "Iro-Si-Khar" or castData.dominion == "Ahèserec") and not isReducedScenario

    -- Plan the cast zone grid: one column per character card in row 1 (champion, familiars, auto-summon
    -- minion). Row 2 holds what belongs to a row-1 character: loyal companions behind their champion,
    -- then each talisman behind the character it is attached to.
    local unitIds = {}
    for unitId, _ in pairs(castData.unitIdsRecruited or {}) do table.insert(unitIds, unitId) end
    table.sort(unitIds) -- pairs() order is not stable; ID order groups each class together

    local champInRowOne = castData.championId and castData.championId ~= "" and not isReducedScenario
    local rowOneIds, rowTwoEntries = {}, {}
    if champInRowOne then table.insert(rowOneIds, castData.championId) end
    for _, unitId in ipairs(unitIds) do
        -- Loyal companions (class code 02COM in the ID) sit behind their champion, like a talisman for them
        if champInRowOne and unitId:find("%-02COM%-") then
            table.insert(rowTwoEntries, { id = unitId, attachedId = castData.championId })
        else
            table.insert(rowOneIds, unitId)
        end
    end
    if hasAutoMinion then
        table.insert(rowOneIds, (castData.dominion == "Iro-Si-Khar") and "02IRO-04MIN-0048" or "05AHE-04MIN-0148")
    end
    local columnOf = {}
    for i, id in ipairs(rowOneIds) do columnOf[id] = i end

    local talIds = {}
    for talId, _ in pairs(castData.talismanIdsEquipped or {}) do table.insert(talIds, talId) end
    table.sort(talIds)
    for _, talId in ipairs(talIds) do
        local attachment = castData.talismanIdsEquipped[talId] or ""
        table.insert(rowTwoEntries, { id = talId, attachedId = attachment:match("Attached to:%s*(.-)%s*$"), isTalisman = true })
    end

    local rowTwoPlacements, columnCount = planRowTwoColumns(rowTwoEntries, columnOf, #rowOneIds)

    -- Every card's slot, so a unit's card and models go to the same place whichever row it is in
    local slotOf = {}
    for id, column in pairs(columnOf) do slotOf[id] = { row = 1, column = column } end
    for _, p in ipairs(rowTwoPlacements) do slotOf[p.id] = { row = 2, column = p.column } end

    local castZone = nil
    if config.cast_zone_guid and config.cast_zone_guid ~= "" then
        castZone = getObjectFromGUID(config.cast_zone_guid)
    end
    local grid = castZone and getCastZoneGrid(castZone, columnCount) or nil
    if not grid then
        broadcastToColor("Warning: cast zone " .. tostring(config.cast_zone_guid) .. " not found, so character and talisman cards go to your hand instead.", clickerColor, {1, 0.5, 0})
    end

    -- Places a card in its grid slot, or deals it to hand if there is no cast zone
    local function placeCard(cardName, cardId, row, column)
        local castDeck = findCastDeck()
        if not castDeck then
            print("Error: Cast deck vanished or was moved during loading.")
            return
        end
        local target, rotation, toHand = spawnPos, {0, 180, 180}, true
        if grid then
            target, rotation, toHand = grid.slot(row, column), grid.rotation, false
        end
        isCloning = true
        local success = cloneCardFromDeck(castDeck, cardName or "", cardId, target, rotation, config.color, toHand)
        if success then
            -- Wait only until the original is back in the deck; no fixed pause, so cards come down in one quick pass
            while isCloning do
                coroutine.yield(0)
            end
        else
            isCloning = false
            print("Warning: card not found: " .. tostring(cardName or "") .. " (" .. tostring(cardId) .. ")")
        end
    end

    -- Where a character's models go: centred on its card, copies spread along the card's length.
    -- Without a cast zone, the old side-of-table column (one row per character) is used.
    local function modelPlacement(slot, qty, sideIndex)
        if grid and slot then
            local centre = grid.slot(slot.row, slot.column)
            local spacing = 0
            if qty > 1 then spacing = math.min(MODEL_SPACING, MODEL_SPREAD_MAX / (qty - 1)) end
            local back = spacing * (qty - 1) / 2
            return {
                x = centre.x - grid.depth.x * back,
                y = surfaceHeightAt(centre.x, centre.z, centre.y) + MODEL_LIFT, -- the card's top, once it has landed
                z = centre.z - grid.depth.z * back
            }, { x = grid.depth.x * spacing, z = grid.depth.z * spacing }
        end
        local spawnTarget = getSpawnPositionForModels(config)
        local xDirection = (config.color == "Red") and 1 or -1
        local zDirection = (config.color == "Red") and -1 or 1
        return {
            x = (config.color == "Red") and -23.5 or 23.5,
            y = spawnTarget.y,
            z = ((config.color == "Red") and -5.0 or 5.0) + (sideIndex * 2.5 * zDirection)
        }, { x = 1.8 * xDirection, z = 0 }
    end

    -- 2. Place every card first, in one pass: row 1 left to right, then row 2. The models follow once
    -- the cards have landed, so each model lands on its card and no character arrives ahead of the rest.
    local minionId = (castData.dominion == "Iro-Si-Khar") and "02IRO-04MIN-0048" or "05AHE-04MIN-0148"
    local cardNames = {}
    if castData.championId then cardNames[castData.championId] = castData.champion end
    if hasAutoMinion then cardNames[minionId] = (castData.dominion == "Iro-Si-Khar") and "Driplet" or "Huskling" end

    for column, id in ipairs(rowOneIds) do
        placeCard(cardNames[id] or "", id, 1, column)
    end
    table.sort(rowTwoPlacements, function(a, b) return a.column < b.column end)
    for _, entry in ipairs(rowTwoPlacements) do
        placeCard("", entry.id, 2, entry.column) -- loyal companions and talismans
    end
    yieldSeconds(0.4) -- let the cards land before the models drop onto them

    -- 3. Spawn each character's models onto its card
    local modelsBag = getBagFromZone(MODELS_ZONE_GUID)
    if not modelsBag then
        print("Warning: Models Bag not found in trigger zone " .. MODELS_ZONE_GUID .. ". Models will not be spawned.")
    end

    local unitIndex = 0 -- row in the side-of-table fallback layout
    local function spawnModels(id, qty, isStacked, label)
        unitIndex = unitIndex + 1
        local position, step = modelPlacement(slotOf[id], qty, unitIndex)
        isCloning = true
        -- Rotate standees around Y so they face the players directly
        local modelSuccess = cloneModelFromBag(modelsBag, id, qty, position, targetModelRot, step, isStacked, config.color)
        if modelSuccess then
            while isCloning do
                coroutine.yield(0)
            end
        else
            isCloning = false
            print("Warning: " .. label .. " model not found in bag for ID: " .. id .. " (has the bag been re-run through Model_ID_Injector since the ID format changed?)")
        end
    end

    if modelsBag then
        -- 3a. Champion standee (Task 3 Improvement - Champion as Character 1)
        if champInRowOne then
            spawnModels(castData.championId, 1, false, "Champion")
        end
        -- 3b. Recruited unit standees, loyal companions included
        for _, unitId in ipairs(unitIds) do
            local qty = castData.unitIdsRecruited[unitId]
            if qty and qty > 0 then
                spawnModels(unitId, qty, false, "Unit")
            end
        end
        -- 3c. 12 stacked minions on the minion card (Driplet / Huskling Lot for Iro-Si-Khar & Ahèserec) (Tweak 2)
        if hasAutoMinion then
            spawnModels(minionId, 12, true, "Minion")
        end
    end

    -- 5. Extract and deal Special Action cards to player's Hand (Task 4)
    if castData.specialIds and #castData.specialIds > 0 then
        for i, specId in ipairs(castData.specialIds) do
            local castDeck = findCastDeck()
            if not castDeck then
                print("Error: Cast deck vanished during specials loop.")
                break
            end

            isCloning = true
            local success = cloneCardFromDeck(castDeck, "", specId, spawnPos, {0, 180, 180}, config.color, true)
            if success then
                while isCloning do
                    coroutine.yield(0)
                end
                yieldSeconds(0.2)
            else
                isCloning = false
                print("Warning: Special card ID not found: " .. specId)
            end
        end
    end
    
    broadcastToAll("Cast for Player " .. playerNum .. " loaded successfully!", {0.1, 0.9, 0.1})
    isLoadingCast = false
    return 1
end

-- Retrieve Deck/Card from Scripting Zone
function getDeckFromZone(zoneGuid)
    if zoneGuid == "XXXXXX" or zoneGuid == "" or zoneGuid == nil then return nil end
    local zone = getObjectFromGUID(zoneGuid)
    if not zone then return nil end
    
    for _, obj in ipairs(zone.getObjects()) do
        if obj.type == "Deck" or obj.type == "Card" then
            return obj
        end
    end
    return nil
end

-- Find the single Cast deck strictly from the designated Scripting Zone
function findCastDeck()
    local castDeck = getDeckFromZone(CAST_ZONE_GUID)
    
    if not castDeck then
        print("Error: Could not find any Deck or Card inside the Cast Trigger Zone (" .. CAST_ZONE_GUID .. ").")
    end
    
    return castDeck
end

-- Core Function: Clones a specific card by name OR unique ID (GM Notes) from a deck, and drops original back
-- toHand = true deals the clone to the player's hand; false leaves it where it spawned (a cast zone slot)
function cloneCardFromDeck(deck, cardName, cardId, targetPos, targetRot, playerColor, toHand)
    -- Handle single Card container vs Deck container
    if deck.type == "Card" then
        local matched = false
        local objId = deck.getGMNotes()
        if cardId ~= nil and cardId ~= "" and objId == cardId then
            matched = true
        else
            local objName = deck.getName()
            if objName == "" or objName == nil then objName = deck.getDescription() end
            if objName:lower() == cardName:lower() then
                matched = true
            end
        end
        
        if matched then
            local clonedObj = deck.clone({
                position = {x = targetPos.x, y = targetPos.y, z = targetPos.z},
                rotation = targetRot
            })
            if toHand then
                Wait.frames(function()
                    if clonedObj ~= nil and not clonedObj.isDestroyed() then
                        clonedObj.deal(1, playerColor)
                    end
                end, 2)
            end
            if not toHand then trackSpawned(playerColor, clonedObj) end -- hand cards are cleared with the hand
            -- Release coroutine immediately for single cards
            isCloning = false
            return true
        end
        isCloning = false
        return false
    end

    -- Standard Deck search
    for _, objInfo in ipairs(deck.getObjects()) do
        local matched = false
        local objId = objInfo.gm_notes
        
        if cardId ~= nil and cardId ~= "" and objId == cardId then
            matched = true
        else
            local objName = objInfo.nickname
            if objName == "" or objName == nil then objName = objInfo.name end
            if objName:lower() == cardName:lower() then
                matched = true
            end
        end
        
        if matched then
            -- Take original card out briefly
            local spawnedCard = deck.takeObject({
                index = objInfo.index,
                -- Lift the original above its own deck, not over the slot, while it is cloned
                position = {x = deck.getPosition().x, y = deck.getPosition().y + SPAWN_HEIGHT_OFFSET, z = deck.getPosition().z},
                rotation = targetRot,
                smooth = false,
                callback_function = function(cardObj)
                    -- Clone it to its exact destination
                    local clonedObj = cardObj.clone({
                        position = {x = targetPos.x, y = targetPos.y, z = targetPos.z},
                        rotation = targetRot
                    })
                    
                    if not toHand then trackSpawned(playerColor, clonedObj) end -- hand cards are cleared with the hand

                    -- Deal the clone into the player's Hand after a small frame delay, unless it was placed in a zone
                    if toHand then
                        Wait.frames(function()
                            if clonedObj ~= nil and not clonedObj.isDestroyed() then
                                clonedObj.deal(1, playerColor)
                            end
                        end, 2)
                    end
                    
                    -- Return original card to the deck after a 3-frame delay to let clone spawn safely first
                    Wait.frames(function()
                        local ok, err = pcall(function()
                            if cardObj ~= nil and not cardObj.isDestroyed() and deck ~= nil and not deck.isDestroyed() then
                                -- Instant teleport back to the deck's physical position to prevent physical drift/clashing across the table!
                                cardObj.setPosition(deck.getPosition())
                                deck.putObject(cardObj)
                            end
                        end)
                        if not ok then
                            print("Error returning card to deck: " .. tostring(err))
                        end
                        -- ALWAYS release the coroutine thread lock, even if putObject failed!
                        isCloning = false
                    end, 3)
                end
            })
            return true
        end
    end
    isCloning = false
    return false
end

-- Helper function to yield coroutine execution for TTS
function yieldSeconds(seconds)
    local start = os.clock()
    while os.clock() - start < seconds do
        coroutine.yield(0)
    end
end

-- ================= END GAME API & WEBHOOK SUPPORT =================

-- Global function to record a Special Action played during the game
-- This can be called from individual card scripts, trigger zones, or manual inputs
function logSpecialAction(playerColour, cardName, cardId)
    local entry = {
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), -- UTC timestamp in ISO 8601 format
        player = playerColour,
        name = cardName,
        id = cardId
    }
    table.insert(specialActionsLog, entry)
    print("Logged Special Action: " .. tostring(cardName) .. " (" .. tostring(cardId) .. ") played by " .. tostring(playerColour))
end

-- Saves the match record with the table. TTS calls this on every save, autosave and rewind point.
function onSave()
    return JSON.encode({
        loadedCasts = loadedCasts,
        specialActionsLog = specialActionsLog,
        spawnedObjects = spawnedObjects
    })
end

-- Reads back what onSave stored. An empty or unreadable save leaves a fresh, empty record.
function restoreMatchData(saved_data)
    if saved_data == nil or saved_data == "" then return end
    local success, saved = pcall(function() return JSON.decode(saved_data) end)
    if not success or type(saved) ~= "table" then
        print("Warning: could not read the saved match record; starting with no casts loaded.")
        return
    end
    loadedCasts = saved.loadedCasts or {}
    specialActionsLog = saved.specialActionsLog or {}
    spawnedObjects = saved.spawnedObjects or {}

    local colours = {}
    for colour, _ in pairs(loadedCasts) do table.insert(colours, colour) end
    if #colours > 0 then
        table.sort(colours)
        print("Restored the loaded casts for " .. table.concat(colours, " and ") .. ", and " .. #specialActionsLog .. " logged Special Action(s).")
    end
end

-- Empties the match record once a game has been submitted, so the next game starts clean.
-- Called by the End Game Controller after a successful submission.
function clearMatchData()
    loadedCasts = {}
    specialActionsLog = {}
    print("Match record cleared for the next game.")
end

-- Exposes match data as a JSON string to avoid Tabletop Simulator cross-script sandboxing/ownership errors
function getMatchDataJson()
    local matchData = {
        loadedCasts = loadedCasts,
        specialActionsLog = specialActionsLog
    }
    return JSON.encode(matchData)
end

-- ================= TASK 3 MODEL SPAWNING HELPERS =================

-- Retrieve Bag from Scripting Zone
function getBagFromZone(zoneGuid)
    if zoneGuid == "XXXXXX" or zoneGuid == "" or zoneGuid == nil then return nil end
    local zone = getObjectFromGUID(zoneGuid)
    if not zone then return nil end
    
    for _, obj in ipairs(zone.getObjects()) do
        if obj.type == "Bag" or obj.type == "Infinite" then
            return obj
        end
    end
    return nil
end

-- Records a card or model this load put on the table, so the next load for that player can clear it
function trackSpawned(playerColor, obj)
    if playerColor == nil or obj == nil then return end
    spawnedObjects[playerColor] = spawnedObjects[playerColor] or {}
    table.insert(spawnedObjects[playerColor], obj.getGUID())
end

-- Works out each row-2 card's column: behind the row-1 character it belongs to (entry.attachedId), or
-- else the next column nothing in row 2 uses yet. Entries are placed in order, so earlier ones (loyal
-- companions) claim their slot first. Returns the placements and the number of columns needed.
function planRowTwoColumns(entries, columnOf, rowOneCount)
    local placements, used, loose = {}, {}, {}
    for _, entry in ipairs(entries) do
        local column = entry.attachedId and columnOf[entry.attachedId]
        if column and not used[column] then
            used[column] = true
            table.insert(placements, { id = entry.id, column = column, isTalisman = entry.isTalisman })
        else
            table.insert(loose, entry)
        end
    end

    local columnCount = math.max(rowOneCount, 1)
    local nextColumn = 1
    for _, entry in ipairs(loose) do
        while used[nextColumn] do nextColumn = nextColumn + 1 end
        used[nextColumn] = true
        table.insert(placements, { id = entry.id, column = nextColumn, isTalisman = entry.isTalisman })
        columnCount = math.max(columnCount, nextColumn)
    end
    return placements, columnCount
end

-- Zones are invisible, so a downward ray must look straight through them
NON_SURFACE_TAGS = { ScriptingTrigger = true, HandTrigger = true, FogOfWarTrigger = true, LayoutZone = true, RandomizeTrigger = true }
NON_SURFACE_TYPES = { Scripting = true, Hand = true, Fog = true, Layout = true, Randomize = true }

-- Height of the highest solid thing at (x, z): the table, or a card already lying there.
-- Falls back to fallbackY if the ray hits nothing.
function surfaceHeightAt(x, z, fallbackY)
    local hits = Physics.cast({ origin = { x, 40, z }, direction = { 0, -1, 0 }, type = 1, max_distance = 80 })
    local best = nil
    for _, hit in ipairs(hits or {}) do
        local obj = hit.hit_object
        if obj and obj ~= self and not NON_SURFACE_TAGS[obj.tag] and not NON_SURFACE_TYPES[obj.type] then
            if best == nil or hit.point.y > best then best = hit.point.y end
        end
    end
    return best or fallbackY
end

-- Lays a grid of card slots over a cast zone. "Depth" runs from the back of the zone towards the
-- board (BOARD_CENTRE), so row 1 is the row nearest the board whichever way the zone faces, and
-- column 1 is on the player's left as they face the board.
function getCastZoneGrid(zone, columnCount)
    local centre = zone.getPosition()
    local size = zone.getScale() -- a scripting zone's scale is its size
    local right = zone.getTransformRight()
    local forward = zone.getTransformForward()

    local toBoardX, toBoardZ = BOARD_CENTRE.x - centre.x, BOARD_CENTRE.z - centre.z
    local dotRight = right.x * toBoardX + right.z * toBoardZ
    local dotForward = forward.x * toBoardX + forward.z * toBoardZ

    -- Use whichever zone axis points most towards the board as the depth axis
    local depth, depthLength, widthLength
    if math.abs(dotForward) >= math.abs(dotRight) then
        depth = (dotForward >= 0) and { x = forward.x, z = forward.z } or { x = -forward.x, z = -forward.z }
        depthLength, widthLength = size.z, size.x
    else
        depth = (dotRight >= 0) and { x = right.x, z = right.z } or { x = -right.x, z = -right.z }
        depthLength, widthLength = size.x, size.z
    end
    -- The player's right as they face the board
    local across = { x = depth.z, z = -depth.x }

    local columnSpacing = math.min(CARD_COLUMN_SPACING, widthLength / math.max(columnCount, 1))
    local rowSpacing = math.min(CARD_ROW_SPACING, depthLength / 2)

    -- Card tops point at the board: a card at yaw 180 reads upright with its top towards +z
    local yaw = math.deg(math.atan2(-depth.x, -depth.z)) + CARD_YAW_OFFSET

    return {
        rotation = { 0, yaw, 0 },
        depth = depth, -- unit vector from the back of the zone towards the board
        slot = function(row, column)
            local acrossOffset = (column - (columnCount + 1) / 2) * columnSpacing
            local depthOffset = depthLength / 2 - rowSpacing * (row - 0.5)
            local x = centre.x + across.x * acrossOffset + depth.x * depthOffset
            local z = centre.z + across.z * acrossOffset + depth.z * depthOffset
            return { x = x, y = surfaceHeightAt(x, z, centre.y) + CARD_LIFT, z = z }
        end
    }
end

-- Get central physical spawn position for models
function getSpawnPositionForModels(config)
    if config.character_zone_guid and config.character_zone_guid ~= "XXXXXX" and config.character_zone_guid ~= "" then
        local zone = getObjectFromGUID(config.character_zone_guid)
        if zone then
            return zone.getPosition()
        end
    end
    return config.table_zone
end

-- Core Function: Clones a specific model by ID from a bag N times, each copy one step on from the last
-- (step = {x, z}), and returns the original to the bag
function cloneModelFromBag(bag, modelId, qty, targetPos, targetRot, step, isStacked, playerColor)
    if not bag then return false end
    
    for _, objInfo in ipairs(bag.getObjects()) do
        if objInfo.gm_notes == modelId then
            -- Take original model out briefly
            local spawnedModel = bag.takeObject({
                guid = objInfo.guid,
                -- Lift the original above its own bag, not over the card, while it is cloned
                position = {x = bag.getPosition().x, y = bag.getPosition().y + SPAWN_HEIGHT_OFFSET, z = bag.getPosition().z},
                rotation = targetRot,
                smooth = false,
                callback_function = function(modelObj)
                    -- Clone it qty times
                    for q = 1, qty do
                        local modelPos
                        if isStacked then
                            -- Stack vertically: same X and Z, increased Y height per copy
                            modelPos = {
                                x = targetPos.x,
                                y = targetPos.y + ((q - 1) * 0.4), -- perfect vertical stack height spacing
                                z = targetPos.z
                            }
                        else
                            -- Place models: first copy at targetPos, each later copy one step on
                            modelPos = {
                                x = targetPos.x + ((q - 1) * step.x),
                                y = targetPos.y,
                                z = targetPos.z + ((q - 1) * step.z)
                            }
                        end
                        
                        local clonedObj = modelObj.clone({
                            position = modelPos,
                            rotation = targetRot
                        })
                        
                        if playerColor and clonedObj ~= nil then
                            clonedObj.setColorTint(playerColor)
                        end
                        trackSpawned(playerColor, clonedObj)
                    end
                    
                    -- Return original model to the bag after a small frame delay to let clones spawn safely first
                    Wait.frames(function()
                        local ok, err = pcall(function()
                            if modelObj ~= nil and not modelObj.isDestroyed() and bag ~= nil and not bag.isDestroyed() then
                                modelObj.setPosition(bag.getPosition())
                                bag.putObject(modelObj)
                            end
                        end)
                        if not ok then
                            print("Error returning model to bag: " .. tostring(err))
                        end
                        isCloning = false
                    end, 3)
                end
            })
            return true
        end
    end
    isCloning = false
    return false
end

-- ================= TASK 5 NATIVE ONBOARDING FEATURES =================

-- Onboarding XML UI State
selectedChamp = "Flint"
selectedScenario = 1
selectedPlayer = 1

-- Global tracking of the active End Game Controller GUID for cross-script callbacks
activeControllerGuid = nil

-- Build the screen-space XML panels dynamically on load (Task 5 Improvements - Global Screen Space)
function setupXmlUi()
    local myGuid = self.getGUID()
    local xml = string.format([[
<Defaults>
    <Button class="start-btn" width="180" height="40" fontSize="16" color="#2ecc71" textColor="#ffffff" fontStyle="Bold" />
    <Button class="close-btn" width="100" height="40" fontSize="16" color="#95a5a6" textColor="#ffffff" />
    <Text class="header" fontSize="18" fontStyle="Bold" color="#ffffff" alignment="Inferred" />
    
    <Button class="menu-btn" width="220" height="42" fontSize="16" textColor="#ffffff" fontStyle="Bold" />
    <Button class="cancel-btn" width="120" height="40" fontSize="15" color="#7f8c8d" textColor="#ffffff" />
    <Text class="header-game" fontSize="20" fontStyle="Bold" color="#ffffff" alignment="MiddleCenter" />
</Defaults>

<!-- Onboarding Panel -->
<Panel id="onboardPanel" active="false" width="450" height="300" color="#2c3e50" rectAlignment="MiddleCenter" padding="20" showAnimation="SlideIn_Bottom" hideAnimation="SlideOut_Bottom">
    <VerticalLayout spacing="15">
        <Text class="header" alignment="MiddleCenter">Monumentum Onboarding Setup</Text>
        
        <HorizontalLayout spacing="10" height="35">
            <Text color="#ffffff" fontSize="15" alignment="MiddleLeft">Champion:</Text>
            <Dropdown id="ddChamp" onValueChanged="%s/onChampSelected" width="220" height="30">
                <option selected="true">Flint</option>
                <option>Ripple</option>
                <option>Lark</option>
            </Dropdown>
        </HorizontalLayout>
        
        <HorizontalLayout spacing="10" height="35">
            <Text color="#ffffff" fontSize="15" alignment="MiddleLeft">Scenario:</Text>
            <Dropdown id="ddScenario" onValueChanged="%s/onScenarioSelected" width="220" height="30">
                <option selected="true">Scenario 1</option>
                <option>Scenario 2</option>
                <option>Scenario 3</option>
                <option>Scenario 4</option>
            </Dropdown>
        </HorizontalLayout>

        <HorizontalLayout spacing="10" height="35">
            <Text color="#ffffff" fontSize="15" alignment="MiddleLeft">Load For:</Text>
            <Dropdown id="ddPlayer" onValueChanged="%s/onPlayerSelected" width="220" height="30">
                <option selected="true">Red Player</option>
                <option>Blue Player</option>
            </Dropdown>
        </HorizontalLayout>
        
        <HorizontalLayout spacing="20" height="50" alignment="MiddleCenter">
            <Button class="start-btn" onClick="%s/btnSpawnOnboarding">LOAD SCENARIO</Button>
            <Button class="close-btn" onClick="%s/btnHideOnboard">CLOSE</Button>
        </HorizontalLayout>
    </VerticalLayout>
</Panel>

<!-- Screen-Space End Game Winner Selection Modal -->
<Panel id="endGamePanel" active="false" width="400" height="280" color="#2c3e50" rectAlignment="MiddleCenter" padding="20" showAnimation="SlideIn_Bottom" hideAnimation="SlideOut_Bottom">
    <VerticalLayout spacing="15">
        <Text class="header-game">Declare Game Winner</Text>
        
        <VerticalLayout spacing="10" alignment="MiddleCenter">
            <Button class="menu-btn" onClick="%s/btnSelectRedXml" color="#e74c3c">Red Won</Button>
            <Button class="menu-btn" onClick="%s/btnSelectBlueXml" color="#3498db">Blue Won</Button>
            <Button class="menu-btn" onClick="%s/btnSelectDrawXml" color="#95a5a6">Draw</Button>
        </VerticalLayout>
        
        <HorizontalLayout alignment="MiddleCenter" height="40">
            <Button class="cancel-btn" onClick="%s/btnCancelXml">Cancel</Button>
        </HorizontalLayout>
    </VerticalLayout>
</Panel>
]], myGuid, myGuid, myGuid, myGuid, myGuid, myGuid, myGuid, myGuid, myGuid)
    UI.setXml(xml)
end

-- API function called by End Game Controller to trigger the screen-space picker panel
function showScreenSpaceEndGamePanel(params)
    if params and params.controller_guid then
        activeControllerGuid = params.controller_guid
    end
    UI.setAttribute("endGamePanel", "active", "true")
end

-- Screen Space End Game Callback Event Handlers
function btnCancelXml(player, value, id)
    if not player.host then
        broadcastToColor("Only the Host can cancel.", player.color, {1, 0, 0})
        return
    end
    UI.setAttribute("endGamePanel", "active", "false")
    activeControllerGuid = nil
end

function btnSelectRedXml(player, value, id)
    if not player.host then
        broadcastToColor("Only the Host can declare the winner.", player.color, {1, 0, 0})
        return
    end
    UI.setAttribute("endGamePanel", "active", "false")
    if activeControllerGuid then
        local controller = getObjectFromGUID(activeControllerGuid)
        if controller then
            controller.call("declareWinnerAndSubmit", { winner = "Red", player_color = player.color })
        end
    end
end

function btnSelectBlueXml(player, value, id)
    if not player.host then
        broadcastToColor("Only the Host can declare the winner.", player.color, {1, 0, 0})
        return
    end
    UI.setAttribute("endGamePanel", "active", "false")
    if activeControllerGuid then
        local controller = getObjectFromGUID(activeControllerGuid)
        if controller then
            controller.call("declareWinnerAndSubmit", { winner = "Blue", player_color = player.color })
        end
    end
end

function btnSelectDrawXml(player, value, id)
    if not player.host then
        broadcastToColor("Only the Host can declare the winner.", player.color, {1, 0, 0})
        return
    end
    UI.setAttribute("endGamePanel", "active", "false")
    if activeControllerGuid then
        local controller = getObjectFromGUID(activeControllerGuid)
        if controller then
            controller.call("declareWinnerAndSubmit", { winner = "Draw", player_color = player.color })
        end
    end
end

-- Toggles Onboarding UI visibility (using global UI)
function btnToggleOnboarding(obj, player_color, alt_click)
    local active = UI.getAttribute("onboardPanel", "active")
    if active == "true" then
        UI.setAttribute("onboardPanel", "active", "false")
    else
        UI.setAttribute("onboardPanel", "active", "true")
    end
end

-- Closes Onboarding UI
function btnHideOnboard(player, value, id)
    UI.setAttribute("onboardPanel", "active", "false")
end

-- Dropdown Selection Callbacks
function onChampSelected(player, value, id)
    selectedChamp = value
end

function onScenarioSelected(player, value, id)
    local num = value:match("%d+")
    selectedScenario = tonumber(num) or 1
end

function onPlayerSelected(player, value, id)
    if value == "Red Player" then
        selectedPlayer = 1
    else
        selectedPlayer = 2
    end
end

-- Helper function to deep copy tables to prevent side-effects from mutating shared configs
function deepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Submits selected onboarding configurations to the main coroutine loader
function btnSpawnOnboarding(player, value, id)
    if not player.host then
        broadcastToColor("Only the Host can load onboarding scenarios.", player.color, {1, 0, 0})
        return
    end
    
    local scenarioDataRaw = ONBOARDING_SCENARIOS[selectedChamp][selectedScenario]
    if not scenarioDataRaw then
        broadcastToColor("Error: Scenario not configured yet.", player.color, {1, 0, 0})
        return
    end
    
    -- Hide Onboarding Menu
    UI.setAttribute("onboardPanel", "active", "false")
    
    -- Create a deep copy to avoid mutating the original configuration table
    local scenarioData = deepCopy(scenarioDataRaw)
    
    -- Dynamically inject scenarioNum so the loader knows which scenario is active (Tweak 2)
    scenarioData.scenarioNum = selectedScenario
    
    -- Pass scenario serialized configuration directly into our robust loading pipeline!
    processPastedCast(selectedPlayer, player, JSON.encode(scenarioData))
end

-- ================= MAP AUTO-DEPLOYMENT NATIVE SUPPORT =================

-- Pre-configured grid sizes, offsets, and relative font coordinates for each scenario.
-- Scenario 4 represents the full standard game (6x6 grid with manual font deployment).
MAP_SCENARIOS = {
    [1] = {
        gridCols = 2,
        gridRows = 2,
        startCol = 3, -- Starts at column 3 to centralise the 2x2 grid in a 6x6 area
        startRow = 3, -- Starts at row 3 to centralise the 2x2 grid in a 6x6 area
        fonts = { {0.5, 0.5} }
    },
    [2] = {
        gridCols = 2,
        gridRows = 2,
        startCol = 3,
        startRow = 3,
        fonts = { {0.5, 0.5} }
    },
    [3] = {
        gridCols = 4,
        gridRows = 4,
        startCol = 2, -- Starts at column 2 to centralise the 4x4 grid in a 6x6 area
        startRow = 2, -- Starts at row 2 to centralise the 4x4 grid in a 6x6 area
        fonts = { {2.5, 0.5}, {1.5, 1.5}, {0.5, 2.5} }
    },
    [4] = {
        gridCols = 6,
        gridRows = 6,
        startCol = 1,
        startRow = 1,
        fonts = {} -- Scenario 4 does not auto-deploy fonts; players use Font Controller
    }
}

-- Natively deploys the appropriate scenario grid and fonts on the table
function deployScenarioMap(scenarioNum, clickerColor)
    -- Determine scenario configuration
    local scenario = MAP_SCENARIOS[scenarioNum]
    if not scenario then
        print("Warning: Scenario " .. tostring(scenarioNum) .. " has no map configuration. Defaulting to Scenario 4.")
        scenario = MAP_SCENARIOS[4]
        scenarioNum = 4
    end

    -- 1. Recall any currently active map elements to start fresh
    recallMapDeployed()
    
    -- 2. Capture pristine decks if not done already
    captureMapDecks()

    local tileDeck = findDeckInMapZone(MAP_TILE_ZONE_GUID)
    local fontDeck = findDeckInMapZone(MAP_FONT_ZONE_GUID)

    if tileDeck == nil then
        broadcastToColor("Warning: Map Path Deck missing from zone " .. MAP_TILE_ZONE_GUID .. ". Board cannot be auto-constructed.", clickerColor, {1, 0.5, 0})
        return
    end

    -- 3. Deploy Path Tiles
    local tilesNeeded = scenario.gridCols * scenario.gridRows
    if #tileDeck.getObjects() < tilesNeeded then
        broadcastToColor("Warning: Not enough tiles in deck (" .. #tileDeck.getObjects() .. " / " .. tilesNeeded .. ") to deploy Scenario " .. scenarioNum, clickerColor, {1, 0.5, 0})
        return
    end

    broadcastToAll("Auto-Deploying Scenario " .. scenarioNum .. " Board (" .. scenario.gridCols .. "x" .. scenario.gridRows .. ")...", {0.1, 0.8, 0.1})

    for row = 0, scenario.gridRows - 1 do
        for col = 0, scenario.gridCols - 1 do
            -- Apply the centralising offset (-1 translates 1-based config to 0-based math)
            local actualCol = (scenario.startCol - 1) + col
            local actualRow = (scenario.startRow - 1) + row

            local targetPos = {
                x = MAP_START_POS.x + (actualCol * MAP_SPACING),
                y = MAP_START_POS.y,
                z = MAP_START_POS.z - (actualRow * MAP_SPACING)
            }

            -- Randomize tile orientation (0, 90, 180, 270 degrees)
            local randomMultiplier = math.random(0, 3)
            local currentRot = tileDeck.getRotation()
            local targetRot = {x = currentRot.x, y = randomMultiplier * 90, z = currentRot.z}

            tileDeck.takeObject({
                position = targetPos,
                rotation = targetRot,
                smooth   = true,
                callback_function = function(obj)
                    if obj ~= nil and not obj.isDestroyed() then
                        obj.setLock(true)
                        table.insert(deployedMapTiles, obj)
                    end
                end
            })
        end
    end

    -- 4. Deploy Font Tiles (If required for this scenario)
    local fontsNeeded = #scenario.fonts
    if fontsNeeded > 0 then
        if fontDeck == nil then
            broadcastToColor("Warning: Font Deck missing from zone " .. MAP_FONT_ZONE_GUID .. ". Scenario Fonts cannot be auto-deployed.", clickerColor, {1, 0.5, 0})
            return
        end

        if #fontDeck.getObjects() < fontsNeeded then
            broadcastToColor("Warning: Not enough font tiles in deck to deploy Scenario " .. scenarioNum, clickerColor, {1, 0.5, 0})
            return
        end

        for i = 1, fontsNeeded do
            local coord = scenario.fonts[i]
            
            -- Shift font coordinates by the exact same centralized offset as the tile grid
            local actualX = (scenario.startCol - 1) + coord[1]
            local actualZ = (scenario.startRow - 1) + coord[2]

            local targetPos = {
                x = MAP_START_POS.x + (actualX * MAP_SPACING),
                y = MAP_START_POS.y + 0.05,
                z = MAP_START_POS.z - (actualZ * MAP_SPACING)
            }

            local currentRot = fontDeck.getRotation()

            fontDeck.takeObject({
                position = targetPos,
                rotation = currentRot,
                smooth   = true,
                callback_function = function(obj)
                    if obj ~= nil and not obj.isDestroyed() then
                        obj.setLock(true)
                        table.insert(deployedMapFonts, obj)
                    end
                end
            })
        end
    end
end

-- Helper: Locates a Deck container inside a Scripting Zone GUID
function findDeckInMapZone(zoneGuid)
    local zone = getObjectFromGUID(zoneGuid)
    if zone == nil then return nil end
    for _, obj in ipairs(zone.getObjects()) do
        if obj.type == "Deck" then return obj end
    end
    return nil
end

-- Helper: Deletes any Decks/Cards inside a Scripting Zone GUID
function clearMapZone(zoneGuid)
    local zone = getObjectFromGUID(zoneGuid)
    if zone == nil then return end
    for _, obj in ipairs(zone.getObjects()) do
        if obj.type == "Deck" or obj.type == "Card" then
            destroyObject(obj)
        end
    end
end

-- Captures pristine snapshots of the map and font decks if present in their zones
function captureMapDecks()
    if savedTileDeckJSON == nil then
        local tDeck = findDeckInMapZone(MAP_TILE_ZONE_GUID)
        if tDeck then savedTileDeckJSON = tDeck.getJSON() end
    end

    if savedFontDeckJSON == nil then
        local fDeck = findDeckInMapZone(MAP_FONT_ZONE_GUID)
        if fDeck then savedFontDeckJSON = fDeck.getJSON() end
    end
end

-- Clears any deployed map elements and restores decks in their scripting zones
function recallMapDeployed()
    -- 1. Destroy all deployed tiles
    for _, obj in ipairs(deployedMapTiles) do
        if obj ~= nil and not obj.isDestroyed() then destroyObject(obj) end
    end
    deployedMapTiles = {}

    -- 2. Destroy all deployed fonts
    for _, obj in ipairs(deployedMapFonts) do
        if obj ~= nil and not obj.isDestroyed() then destroyObject(obj) end
    end
    deployedMapFonts = {}

    -- 3. Clear trigger zones of leftover singles
    clearMapZone(MAP_TILE_ZONE_GUID)
    clearMapZone(MAP_FONT_ZONE_GUID)

    -- 4. Respawn pristine decks slightly above the table surface
    local tZone = getObjectFromGUID(MAP_TILE_ZONE_GUID)
    if savedTileDeckJSON and tZone then
        local pos = tZone.getPosition()
        spawnObjectJSON({
            json = savedTileDeckJSON,
            position = {pos.x, MAP_START_POS.y + 0.2, pos.z}
        })
    end

    local fZone = getObjectFromGUID(MAP_FONT_ZONE_GUID)
    if savedFontDeckJSON and fZone then
        local pos = fZone.getPosition()
        spawnObjectJSON({
            json = savedFontDeckJSON,
            position = {pos.x, MAP_START_POS.y + 0.2, pos.z}
        })
    end
end
