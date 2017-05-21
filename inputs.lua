function CreateInputs(a_ClassName, a_FunctionName, a_Params, a_Fuzzing)
	local inputs = {}

	for _, tbParams in ipairs(a_Params) do
		table.insert(inputs, CreateValidParams(a_ClassName, a_FunctionName, tbParams))
	end

        -- Add IsStatic flag, if necessary
        for i = 1,#inputs do
                -- Add IsStatic flag
                if a_Params[i].IsStatic then
                        inputs[i].IsStatic = true
                end
	end

	-- If we are not fuzzing. Check if a param has value nil.
	if not(a_Fuzzing) then
		for i = 1,#inputs do
			for index, param in ipairs(inputs[i]) do
				if param == "nil" then
					-- Not handled for now
					if
						a_Params[i][index] == "..." or
						a_Params[i][index] == "<unknown>" or
						a_Params[i][index] == "any" or
						a_Params[i][index] == "cBlockArea" or
						a_Params[i][index] == "cClientHandle" or
						a_Params[i][index] == "cCraftingGrid" or
						a_Params[i][index] == "cEntity" or
						a_Params[i][index] == "cEntityEffect" or
						a_Params[i][index] == "cIniFile" or
						a_Params[i][index] == "cMonster" or
						a_Params[i][index] == "cPlayer" or
						a_Params[i][index] == "cTeam" or
						a_Params[i][index] == "cWindow" or
						a_Params[i][index] == "function" or
						a_Params[i][index] == "HTTPRequest"
					then
						return nil
					end
					print(a_ClassName, a_FunctionName)
					assert(false, "The param " .. a_Params[i][index] .. " has value nil.")
				end
			end
		end
		return inputs
	end

	-- Replace params from right to left with nil
	local r = #inputs[1]
	for amount = 1, #inputs[1] do
		table.insert(inputs, CopyTable(inputs[1], inputs[1].IsStatic))

		for i = r, #a_Params do
			inputs[#inputs][i] = "nil"
		end
		r = r - 1
	end

	local tmp = {}
	local hasNumber = false
	-- Add negative and positive numbers
	for i = 1, #a_Params do
		if a_Params[i] == "number" then
			hasNumber = true
			tmp[i] = -999999999999
		else
			tmp[i] = inputs[1][i]
		end
	end
	if hasNumber then
		hasNumber = false
		table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))
	end

	tmp = {}
	for i = 1, #a_Params do
		if a_Params[i] == "number" then
			hasNumber = true
			tmp[i] = 999999999999
		else
			tmp[i] = inputs[1][i]
		end
	end
	if hasNumber then
		hasNumber = false
		table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))
	end

	-- Add block types, item types
	tmp = {}
	for i = 1, #a_Params do
		if a_Params[i] == "number" then
			hasNumber = true
			tmp[i] = E_BLOCK_STONE_BRICKS
		else
			tmp[i] = inputs[1][i]
		end
	end
	if hasNumber then
		hasNumber = false
		table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))
	end

	tmp = {}
	for i = 1, #a_Params do
		if a_Params[i] == "number" then
			hasNumber = true
			tmp[i] = E_ITEM_BED
		else
			tmp[i] = inputs[1][i]
		end
	end
	if hasNumber then
		table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))
	end

	tmp = {}
	for i = 1, #a_Params do
		tmp[i] = E_ITEM_BED
	end
	table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))

       for i = 1, 10 do
               tmp = {}
               for i = 1, #a_Params do
                       tmp[i] = math.random(-100000000000, 10000000000)
               end
               table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))
       end

	tmp = {}
	for i = 1, #a_Params do
		tmp[i] = 1
	end
	table.insert(inputs, CopyTable(tmp, inputs[1].IsStatic))

	return inputs
end



function CreateValidParams(a_ClassName, a_FunctionName, a_Params)
	local inputs = {}

	for index, param in ipairs(a_Params) do
		if param == "string" then
			if a_ClassName == "cEnchantments" then
				if a_FunctionName == "AddFromString" then
					inputs[index] = "'Looting = 1'"
				elseif a_FunctionName == "StringToEnchantmentID" then
					inputs[index] = "'Infinity'"
				end
			elseif a_ClassName == "cWorld" then
				if a_ClassName == "cLineBlockTracer" then
					if a_FunctionName == "FirstSolidHitTrace" then
						inputs[index] = "world"
					end
				end
			elseif a_ClassName == "cRoot" then
				if a_FunctionName == "GetWorld" then
					inputs[index] = "'world'"
				end
			elseif a_ClassName == "cJson" then
				if a_FunctionName == "Parse" then
					inputs[index] = "'{ \"amount\" : 30 }'"
				end
			end

			if inputs[index] == nil then
				-- If reached here return JustAString.
				-- If an error occurs add special handling above
				inputs[index] = "'JustAString'"
			end

		elseif param == "number" then
			if a_ClassName == "cLineBlockTracer" then
				if a_FunctionName == "FirstSolidHitTrace" then
					if index == 2 then
						inputs[index] = 1
					elseif index == 3 then
						 inputs[index] = 255
                                        elseif index == 4 then
                                                 inputs[index] = 1
                                                inputs[index] = 1
                                        elseif index == 5 then
                                                 inputs[index] = 1
                                        elseif index == 6 then
                                                 inputs[index] = 1
                                        elseif index == 7 then
                                                 inputs[index] = 1
					end
				end
				
			elseif a_ClassName == "cItems" then
				if a_FunctionName == "Delete" or a_FunctionName == "Get" then
					inputs[index] = 0
				end
			elseif a_ClassName == "ItemCategory" then
				if a_FunctionName == "IsMinecart" then
					inputs[index] = "E_ITEM_CHEST_MINECART"
				elseif a_FunctionName == "IsChestPlate" then
					inputs[index] = "E_ITEM_CHAIN_CHESTPLATE"
				elseif a_FunctionName == "IsTool" then
					inputs[index] = "E_ITEM_IRON_PICKAXE"
				elseif a_FunctionName == "IsBoots" then
					inputs[index] = "E_ITEM_DIAMOND_BOOTS"
				elseif a_FunctionName == "IsArmor" then
					inputs[index] = "E_ITEM_DIAMOND_HORSE_ARMOR"
				elseif a_FunctionName == "IsHelmet" then
					inputs[index] = "E_ITEM_LEATHER_CAP"
				elseif a_FunctionName == "IsHoe" then
					inputs[index] = "E_ITEM_WOODEN_HOE"
				elseif a_FunctionName == "IsLeggings" then
					inputs[index] = "E_ITEM_LEATHER_PANTS"
				end
			elseif a_ClassName == "cLuaWindow" then
				if index == 2 then
					inputs[index] = 9
				elseif index == 3 then
					inputs[index] = 3
				end
			elseif a_ClassName == "cBoundingBox" then
				if index == 1 then
					inputs[index] = 110
				elseif index == 2 then
					inputs[index] = 188
				elseif index == 3 then
					inputs[index] = 5
				elseif index == 4 then
					inputs[index] = 176
				elseif index == 5 then
					inputs[index] = 76
				elseif index == 6 then
					inputs[index] = 160
				end
			end
			if inputs[index] == nil then
				inputs[index] = 1
			end
		elseif param == "boolean" then
			inputs[index] = "false"
		elseif param == "cItem" then
			if a_ClassName == "cRoot" then
				if a_FunctionName == "GetBrewingRecipe" then
					if index == 1 then
						inputs[index] = "cItem(E_ITEM_POTION)"
					elseif index == 2 then
						inputs[index] = "cItem(E_ITEM_NETHER_WART)"
					end
				elseif a_FunctionName == "GetFurnaceRecipe" then
					inputs[index] = "cItem(E_ITEM_RAW_FISH)"
				end
			end

			if inputs[index] == nil then
					inputs[index] = "cItem(1, 2)"
			end
		elseif param == "function" then
			inputs[index] = "nil"
		elseif param == "cPlayer" then
			inputs[index] = "nil"
		elseif param == "cClientHandle" then
			inputs[index] = "nil"
		elseif param == "eMessageType" then
			inputs[index] = "mtCustom"
		elseif param == "eWeather" then
			inputs[index] = "wSunny"
		elseif param == "cMonster" then
			inputs[index] = "nil"
		elseif param == "cItems" then
			inputs[index] = "cItems()"
		elseif param == "EMCSBiome" then
			inputs[index] = "biSky"
		elseif param == "table" then
			if a_ClassName == "cJson" then
				if a_FunctionName == "Serialize" then
					-- Ignore optional param
					if index == 1 then
						inputs[index] = "{ ['amount'] = 30 }"
					end
				end
			end

			if inputs[index] == nil then
				inputs[index] = "{ }"
			end
		elseif param == "Vector3i" then
			inputs[index] = "Vector3i(1, 1, 1)"
		elseif param == "Vector3d" then
			if a_ClassName == "cBoundingBox" then
				if a_FunctionName == "CalcLineIntersection" then
					 if #a_Params == 2 then
						-- not is static
						if index == 1 then
							inputs[index] = "Vector3d(192, 139, 114)"
						elseif index == 2 then
							inputs[index] = "Vector3d(85, 37, 32)"
						end
					elseif #a_Params == 4 then
						-- is static
						if index == 1 then
							inputs[index] = "Vector3d(45, 17, 124)"
						elseif index == 2 then
							inputs[index] = "Vector3d(243, 229, 236)"
						elseif index == 3 then
							inputs[index] = "Vector3d(8, 83, 155)"
						elseif index == 4 then
							inputs[index] = "Vector3d(204, 14, 129)"
						end
					end
				end
			elseif a_ClassName == "cLineBlockTracer" then
				if a_FunctionName == "FirstSolidHitTrace" then
					if index == 2 then
						inputs[index] = "Vector3d(1, 255, 1)"
					elseif index == 3 then
						inputs[index] = "Vector3d(1, 1, 1)"
					end
				end
			end

			if inputs[index] == nil then
				inputs[index] = "Vector3d(1, 1, 1)"
			end
		elseif param == "Vector3f" then
			inputs[index] = "Vector3f(1, 1, 1)"
		elseif param == "cProjectileEntity#eKind" then
			inputs[index] = "pkArrow"
		elseif param == "cEntity" then
			inputs[index] = "nil"
		elseif param == "cBoundingBox" then
			if a_FunctionName == "Intersect" then
				inputs[index] = "cBoundingBox(163, 190, 19, 91, 137, 244)"
			elseif a_FunctionName == "CalcLineIntersection" then
				inputs[index] = "cBoundingBox(78, 230, 107, 254, 74, 153)"
			end

			if inputs[index] == nil then
				inputs[index] = "cBoundingBox(Vector3d(2, 1, 2), Vector3d(10, 256, 10))"
			end
		elseif param == "cCuboid" then
			inputs[index] = "cCuboid(10, 10, 10)"
		elseif param == "eExplosionSource" then
			inputs[index] = "esBed"
		elseif param == "cWorld" then
			inputs[index] = "cRoot:Get():GetWorld('world')"
		elseif param == "eDamageType" then
			inputs[index] = "dtLightning"
		elseif param == "cEnchantments" then
			inputs[index] = "cEnchantments()"
		elseif param == "cMonster#eFamily" then
			inputs[index] = "cMonster.mfPassive"
		elseif param == "Globals#eMonsterType" then
			inputs[index] = "mtBat"
		elseif param == "cEntityEffect#eType" then
			inputs[index] = "cEntityEffect.effInvisibility"
		elseif param == "Globals#eShrapnelLevel" then
			inputs[index] = "slGravityAffectedOnly"
		elseif param == "cBlockArea" then
			inputs[index] = "nil"
		elseif param == "cPluginManager#PluginHook" then
			inputs[index] = "HOOK_BLOCK_SPREAD"
		elseif param == "..." then
			inputs[index] = "nil"
		elseif param == "HTTPRequest" then
			inputs[index] = "nil"
		elseif param == "eMobHeadRotation" then
			inputs[index] = "SKULL_ROTATION_EAST"
		elseif param == "eMobHeadType" then
			inputs[index] = "SKULL_TYPE_CREEPER"
		elseif param == "cEntityEffect" then
			inputs[index] = "nil"
		elseif param == "cCraftingGrid" then
			inputs[index] = "nil"
		elseif param == "eBlockFace" then
			inputs[index] = "BLOCK_FACE_BOTTOM"
		elseif param == "cCompositeChat" then
			inputs[index] = "cCompositeChat()"
		elseif param == "cIniFile" then
			inputs[index] = "nil"
		elseif param == "eClickAction" then
			inputs[index] = "caCtrlDropKey"
		elseif param == "cWindow#WindowType" then
			inputs[index] = "cWindow.wtChest"
		elseif param == "cArrowEntity#ePickupState" then
			inputs[index] = "psNoPickup"
		elseif param == "eMonsterType" then
			inputs[index] = "mtBat"
		elseif param == "cWindow" then
			inputs[index] = "nil"
		elseif param == "eSkinPart" then
			inputs[index] = "spCape"
		elseif param == "cTeam" then
			inputs[index] = "nil"
		elseif param == "Globals#eGameMode" then
			inputs[index] = "eGameMode_Adventure"
		elseif param == "eMainHand" then
			inputs[index] = "mhLeft"
		elseif param == "any" then  -- Different source different entity
			inputs[index] = "nil"
		elseif param == "<unknown>" then  -- TODO
			inputs[index] = "nil"
		elseif param == "eDimension" then
			inputs[index] = "dimOverworld"
		end

		assert(inputs[index] ~= nil, "Param not handled: " .. param)
	end

	return inputs
end
