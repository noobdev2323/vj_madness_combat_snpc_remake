net.Receive("vj_madness_combat.text", function()
    local npc = net.ReadEntity()
    local text = net.ReadString()
    if IsValid(npc) then
        npc.madness_ChatText = text
        npc.madness_ChatTime = CurTime() + 3
    end
end)
local maxChatDistance = 500

hook.Add("PostDrawTranslucentRenderables", "Draw_madness_NPCChat", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local plyPos = ply:EyePos()

    for _, npc in ipairs(ents.GetAll()) do
        if IsValid(npc) and npc:IsNPC() and npc.madness_ChatText and npc.madness_ChatTime and CurTime() < npc.madness_ChatTime then
            local npcPos = npc:GetPos()
            local distance = plyPos:DistToSqr(npcPos) 

            
            if distance > (maxChatDistance * maxChatDistance) then continue end

            
            local trace = util.TraceLine({
                start = plyPos,
                endpos = npcPos + Vector(0, 0, 50), 
                filter = {ply, npc}, 
                mask = MASK_VISIBLE_AND_NPCS 
            })

            
            if trace.Hit then continue end 


            local minBounds, maxBounds = npc:GetModelBounds()
            local height = maxBounds.z - minBounds.z
            if height <= 0 then height = 40 end 


            local ang = ply:EyeAngles()
            ang:RotateAroundAxis(ang:Right(), 90)
            ang:RotateAroundAxis(ang:Up(), -90)


            cam.Start3D2D(npc:GetPos() + Vector(0, 0, height + 4), ang, 0.4)
                draw.SimpleTextOutlined(npc.madness_ChatText, "DermaLarge", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0, 0, 0))
            cam.End3D2D()
        end
    end
end)