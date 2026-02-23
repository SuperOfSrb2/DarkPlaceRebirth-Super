return {
    -- The inclusion of the below line tells the language server that the first parameter of the cutscene is `BattleCutscene`.
    -- This allows it to fetch us useful documentation that shows all of the available cutscene functions while writing our cutscenes!

    ---@param cutscene BattleCutscene
    susie_punch = function(cutscene, battler, enemy)
        -- Open textbox and wait for completion
        cutscene:text("* Susie threw a punch at\nthe dummy.")

        -- Hurt the target enemy for 1 damage
        Assets.playSound("damage")
        enemy:hurt(1, battler)
        -- Wait 1 second
        cutscene:wait(1)

        -- Susie text
        cutscene:text("* You,[wait:5] uh,[wait:5] look like a weenie.[wait:5]\n* I don't like beating up\npeople like that.", "nervous_side", "susie")

        if cutscene:getCharacter("ralsei") then
            -- Ralsei text, if he's in the party
            cutscene:text("* Aww,[wait:5] Susie!", "blush_pleased", "ralsei")
        end
    end,
    tattle = function(cutscene, battler, enemy)
        local tex = "!"
        if Game:hasPartyMember("hero") then tex = ", Hero!" end
        cutscene:text("* That's the Wall Guardian" ..tex, "face", "suzy")
        cutscene:text("* It's made out of pure stone,\nso its defense is towering!", "face", "suzy")
        cutscene:text("* Though, I hear it's weak to\n[color:yellow]HAMMER[color:reset] attacks!", "neutral", "suzy")
        cutscene:text("* Now let's shatter this thing!", "smile", "suzy")

    end
}