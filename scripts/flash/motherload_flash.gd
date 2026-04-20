extends Node2D
class_name MotherloadFlash

# Defining minerals
static var IRONIUM: Collectable = Collectable.new("Ironium", 30, 1, Collectable.Type.MINERAL)
static var BRONZIUM: Collectable = Collectable.new("Bronzium", 60, 1, Collectable.Type.MINERAL)
static var SILVERIUM: Collectable = Collectable.new("Silverium", 100, 1, Collectable.Type.MINERAL)
static var GOLDIUM: Collectable = Collectable.new("Goldium", 250, 2, Collectable.Type.MINERAL)
static var PLATINIUM: Collectable = Collectable.new("Platinium", 750, 3, Collectable.Type.MINERAL)
static var EINSTEINIUM: Collectable = Collectable.new("Einsteinium", 2000, 4, Collectable.Type.MINERAL)
static var EMERALD: Collectable = Collectable.new("Emerald", 5000, 6, Collectable.Type.MINERAL)
static var RUBY: Collectable = Collectable.new("Ruby", 20000, 8, Collectable.Type.MINERAL)
static var DIAMOND: Collectable = Collectable.new("Diamond", 100000, 10, Collectable.Type.MINERAL)
static var AMAZONITE: Collectable = Collectable.new("Amazonite", 500000, 12, Collectable.Type.MINERAL)
# Array for easy access
static var MINERALS: Array[Collectable] = [IRONIUM, BRONZIUM, SILVERIUM, GOLDIUM, PLATINIUM, EINSTEINIUM, EMERALD, RUBY, DIAMOND, AMAZONITE]

# Defining artifacts
static var DINOSAUR_BONES: Collectable = Collectable.new("Dinosaur Bones", 1000, 1, Collectable.Type.ARTIFACT)
static var TREASURE: Collectable = Collectable.new("Treasure", 5000, 1, Collectable.Type.ARTIFACT)
static var MARTIAN_SKELETON: Collectable = Collectable.new("Martian Skeleton", 10000, 1, Collectable.Type.ARTIFACT)
static var RELIGIOUS_ARTIFACT: Collectable = Collectable.new("Religious Artifact", 50000, 1, Collectable.Type.ARTIFACT)
# Array for easy access
static var ARTIFACTS: Array[Collectable] = [DINOSAUR_BONES, TREASURE, MARTIAN_SKELETON, RELIGIOUS_ARTIFACT]

## Gets the collectable variant of the given mineral/artifact tile. Returns null if the given tile
## is not a mineral or artifact
static func get_collectable_from_tile(tile: Vector2i) -> Collectable:
	if Tiles.is_mineral_tile(tile):
		return MINERALS[tile.y]
	elif Tiles.is_artifact_tile(tile):
		return ARTIFACTS[tile.y]
	else:
		return null





# Defining pod components (upgrades)

static var STOCK_DRILL: Drill = Drill.new("Stock Drill", 0, 2)
static var SILVIDE_DRILL: Drill = Drill.new("Silvide Drill", 750, 2.8)
static var GOLDIUM_DRILL: Drill = Drill.new("Goldium Drill", 2000, 4)
static var EMERALD_DRILL: Drill = Drill.new("Emerald Drill", 5000, 5)
static var RUBY_DRILL: Drill = Drill.new("Ruby Drill", 20000, 7)
static var DIAMOND_DRILL: Drill = Drill.new("Diamond Drill", 100000, 9.5)
static var AMAZONITE_DRILL: Drill = Drill.new("Amazonite Drill", 500000, 12)
# Array for easy access
static var DRILL_UPGRADES: Array[Drill] = [STOCK_DRILL, SILVIDE_DRILL, GOLDIUM_DRILL, EMERALD_DRILL, RUBY_DRILL, DIAMOND_DRILL, AMAZONITE_DRILL]

static var STOCK_HULL: Hull = Hull.new("Stock Hull", 0, 10)
static var IRONIUM_HULL: Hull = Hull.new("Ironium Hull", 750, 17)
static var BRONZIUM_HULL: Hull = Hull.new("Bronzium Hull", 2000, 30)
static var STEEL_HULL: Hull = Hull.new("Steel Hull", 5000, 50)
static var PLATINIUM_HULL: Hull = Hull.new("Platinium Hull", 20000, 80)
static var EINSTEINIUM_HULL: Hull = Hull.new("Einsteinium Hull", 100000, 120)
static var ENERGY_SHIELDED_HULL: Hull = Hull.new("Energy-Shielded Hull", 500000, 180)
# Array for easy access
static var HULL_UPGRADES: Array[Hull] = [STOCK_HULL, IRONIUM_HULL, BRONZIUM_HULL, STEEL_HULL, PLATINIUM_HULL, EINSTEINIUM_HULL, ENERGY_SHIELDED_HULL]

static var STOCK_ENGINE: PodEngine = PodEngine.new("Stock Engine", 0, 150)
static var V4_1600_cc: PodEngine = PodEngine.new("V4 1600 cc", 750, 160)
static var V4_20_LTR_TURBO: PodEngine = PodEngine.new("V4 2.0 Ltr Turbo", 2000, 170)
static var V6_38_LTR: PodEngine = PodEngine.new("V6 3.8 Ltr", 5000, 180)
static var V8_SUPERCHARGED_50_LTR: PodEngine = PodEngine.new("V8 Supercharged 5.0 Ltr", 20000, 190)
static var V12_60_LTR: PodEngine = PodEngine.new("V12 6.0 Ltr", 100000, 200)
static var V16_JAG_ENGINE: PodEngine = PodEngine.new("V16 Jag Engine", 500000, 210)
# Array for easy access
static var ENGINE_UPGRADES: Array[PodEngine] = [STOCK_ENGINE, V4_1600_cc, V4_20_LTR_TURBO, V6_38_LTR, V8_SUPERCHARGED_50_LTR, V12_60_LTR, V16_JAG_ENGINE]

static var MICRO_TANK: FuelTank = FuelTank.new("Micro Tank", 0, 10)
static var MEDIUM_TANK: FuelTank = FuelTank.new("Medium Tank", 750, 15)
static var HUGE_TANK: FuelTank = FuelTank.new("Huge Tank", 2000, 25)
static var GIGANTIC_TANK: FuelTank = FuelTank.new("Gigantic Tank", 5000, 40)
static var TITANIC_TANK: FuelTank = FuelTank.new("Titanic Tank", 20000, 60)
static var LEVIATHAN_TANK: FuelTank = FuelTank.new("Leviathan Tank", 100000, 100)
static var LIQUID_COMPRESSION_TANK: FuelTank = FuelTank.new("Liquid Compression Tank", 500000, 150)
# Array for easy access
static var FUEL_TANK_UPGRADES: Array[FuelTank] = [MICRO_TANK, MEDIUM_TANK, HUGE_TANK, GIGANTIC_TANK, TITANIC_TANK, LEVIATHAN_TANK, LIQUID_COMPRESSION_TANK]

static var STOCK_FAN: Radiator = Radiator.new("Stock Fan", 0, 1)
static var DUAL_FANS: Radiator = Radiator.new("Dual Fans", 2000, 0.9)
static var SINGLE_TURBINE: Radiator = Radiator.new("Single Turbine", 5000, 0.75)
static var DUAL_TURBINES: Radiator = Radiator.new("Dual Turbines", 20000, 0.6)
static var PURON_COOLING: Radiator = Radiator.new("Puron Cooling", 100000, 0.4)
static var TRI_TURBINE_FREON_ARRAY: Radiator = Radiator.new("Tri-Turbine Freon Array", 500000, 0.2)
# Array for easy access
static var RADIATOR_UPGRADES: Array[Radiator] = [STOCK_FAN, DUAL_FANS, SINGLE_TURBINE, DUAL_TURBINES, PURON_COOLING, TRI_TURBINE_FREON_ARRAY]

static var MICRO_BAY: Bay = Bay.new("Micro Bay", 0, 7)
static var MEDIUM_BAY: Bay = Bay.new("Medium Bay", 750, 15)
static var HUGE_BAY: Bay = Bay.new("Huge Bay", 2000, 25)
static var GIGANTIC_BAY: Bay = Bay.new("Gigantic Bay", 5000, 40)
static var TITANIC_BAY: Bay = Bay.new("Titanic Bay", 20000, 70)
static var LEVIATHAN_BAY: Bay = Bay.new("Leviathan Bay", 100000, 120)
# Array for easy access
static var BAY_UPGRADES: Array[Bay] = [MICRO_BAY, MEDIUM_BAY, HUGE_BAY, GIGANTIC_BAY, TITANIC_BAY, LEVIATHAN_BAY]





# Defining Items 

static var RESERVE_TANK_FUEL: Item = Item.new("Reserve Tank Fuel", 2000)
static var HULL_REPAIR_NANOBOTS: Item = Item.new("Hull Repair Nanobots", 7500)
static var DYNAMITE: Item = Item.new("Dynamite", 2000)
static var PLASTIC_EXPLOSIVES: Item = Item.new("Plastic Explosives", 5000)
static var QUANTUM_TELEPORTER: Item = Item.new("Quantum Teleporter", 2000)
static var MATTER_TRANSMITTER: Item = Item.new("Matter Transmitter", 10000)



@onready var player: PlayerFlash = $PlayerFlash
@onready var earth: EarthFlash = $EarthFlash



func _ready() -> void:
	Engine.max_fps = 60
	
	player.drill = STOCK_DRILL
	player.hull = STOCK_HULL
	player.engine = STOCK_ENGINE
	player.fuel_tank = MICRO_TANK
	player.radiator = STOCK_FAN
	player.bay = MICRO_BAY
	
