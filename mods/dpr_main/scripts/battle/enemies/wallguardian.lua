local WallGuardian, super = Class(EnemyBattler)

function WallGuardian:init()
    super.init(self)

    -- Enemy name
    self.name = "Wall Guardian"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("wall")

    -- Enemy health
    self.max_health = 3000
    self.health = 3000
    -- Enemy attack (determines bullet damage)
    self.attack = 10
    -- Enemy defense (usually 0)
    self.defense = 20
    -- Enemy reward
    self.money = 5000

    self.experience = 1150

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = 0
    self.tired_percentage = 0.1
    self.low_health_percentage = 0.18

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {
        "..."
    }

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT 10 DF 20\n* The Wall Guardian, guardian\nof the walls."

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* The Wall Guardian looks through\nyou.",
        "* People begin to gather around\nto watch the battle.[wait:5]\n* Sans is selling tickets.",
        "* Smells like wall.",
    }

    if Game:hasPartyMember("susie") then
        table.insert(self.text, "* The Wall Guardian accosts Susie\nwith his cool shades.")
    end
    if Game:hasPartyMember("berdly") then
        table.insert(self.text, "* Berdly scans the Wall Guardian\nwith his scouter...\n* It's over 9000!")
    end
    if Game:hasPartyMember("mario") then
        table.insert(self.text, "* Mario readies his hammer...\n* The Wall Guardian starts\nsweating.")
    end


    -- Text displayed at the bottom of the screen when the enemy has low health
    self.low_health_text = "* The Wall Guardian begins\nto crumble."

    -- Register act called "Smile"
    self:registerAct("Smile")
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty)
    self:registerAct("Tell Story", "", {"ralsei"})

    self.killable = true
end

function WallGuardian:getAttackDamage(damage, battler, points)
    if damage > 0 then
        return damage
    end
    local mario = Game.battle:getPartyBattler("mario")
    if mario == battler then
        points = points * 4
    end
    return ((battler.chara:getStat("attack") * points) / 20) - (self.defense * 3)
end

function WallGuardian:onAct(battler, name)
    if name == "Smile" then
        -- Give the enemy 100% mercy
        self:addMercy(100)
        -- Change this enemy's dialogue for 1 turn
        self.dialogue_override = "... ^^"
        -- Act text (since it's a list, multiple textboxes)
        return {
            "* You smile.[wait:5]\n* The dummy smiles back.",
            "* It seems the dummy just wanted\nto see you happy."
        }

    elseif name == "Tell Story" then
        -- Loop through all enemies
        for _, enemy in ipairs(Game.battle.enemies) do
            -- Make the enemy tired
            enemy:setTired(true)
        end
        return "* You and Ralsei told the dummy\na bedtime story.\n* The enemies became [color:blue]TIRED[color:reset]..."

    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

return WallGuardian