local WallGuardian, super = Class(Encounter)

function WallGuardian:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* The Wall Guardian stands before\nyou."

    -- Battle music ("battle" is rude buster)
    self.music = "wallguardian"
    self.background = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("wallguardian")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")


end

return WallGuardian