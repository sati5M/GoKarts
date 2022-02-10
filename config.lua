cfg = {}



cfg.gameSettings = {
    checkPointColour = {r = 255, g = 0, b = 0, a = 100}, -- A is opacity
    lapsInRace = 2,
    resetCommand = "resetrace",
    acePerm = "GoKart.resetrace", -- USED TO RESET RACE IN CASE OF ISSUES
    vehicleModel = `kart`,
    queueTimer = 5, -- SECONDS
    radiusToCheck = 200,
    radiusToCheckCheckpoints = 6,
    minPlayers = 1,
    maxPlayers = 3,
}



cfg.locations = {
    startLocation = vector3(-1023.2072143555,-3475.9172363281,13.35923412323),
    spawnLocAfterGame = vector3(-1040.4697265625,-3461.7058105469,14.32923412323),
    locToRadiusCheckFrom = vector3(-1068.8702392578,-3492.9318847656,14.143417358398),
    spawnpoints = {
        vector3(-1027.2532958984,-3490.8718261719,14.143469810486),
        vector3(-1025.2941894531,-3491.9047851563,14.143424987793),
        vector3(-1023.4270019531,-3493.0043945313,14.143459320068)
    },
    
}