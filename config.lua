cfg = {}



cfg.gameSettings = {
    checkPointColour = {r = 255, g = 0, b = 0, a = 100}, -- A IS OPACITY
    lapsInRace = 2,
    resetCommand = "resetrace", -- USED TO RESET RACE IN CASE OF ISSUES
    acePerm = "GoKart.resetrace", -- PERMISSION USED TO RESET RACE IN CASE OF ISSUES
    vehicleModel = `kart`, -- CHANGE THIS TO YOUR GOKART MODEL
    queueTimer = 5, -- HOW LONG THE QUEUE IS IN SECONDS
    radiusToCheck = 200,
    radiusToCheckCheckpoints = 6,
    minPlayers = 1,
    maxPlayers = 2,
}



cfg.locations = {
    startLocation = vector3(-1023.2072143555,-3475.9172363281,13.35923412323), -- WHERE TO JOIN QUEUE
    spawnLocAfterGame = vector3(-1040.4697265625,-3461.7058105469,14.32923412323), -- SPAWN LOCATION AFTER THEY PASS FINAL CHECKPOINT
    locToRadiusCheckFrom = vector3(-1068.8702392578,-3492.9318847656,14.143417358398), -- DISTANCE TO CHECK HOW FAR THEY ARE, links to cfg.gameSettings.radiusToCheck
    heading = 60.0, -- Has to be a float
    spawnpoints = { -- VEHICLE SPAWN POINTS
        vector3(-1025.1723632813,-3488.6184082031,14.143424987793),
        vector3(-1026.4730224609,-3491.2253417969,14.143419265747)
    },
    
}