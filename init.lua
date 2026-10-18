--Copyright (c) 2026 crazycatlover98544

--Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

--The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--You may also read these terms at the following website: https://opensource.org/license/mit

--My GitHub account is located at https://github.com/crazycatlover98544
--My MistWarp account is located at https://mistwarp.org/users/crazycatlover98544

--Please note that this code is not written by an expert.
--I am not responsible if this harms your computer.
--(This should not harm your computer anyway)

--All images are also licensed under the MIT license.
--For more information, open up IMAGES.md.

local S = minetest.get_translator(mod_name)

minetest.register_privilege("barrier_allow", { -- Register the privilege
    description = "Permission to mine/place barrier blocks",
    give_to_singleplayer = false,
})

minetest.register_node("barrier:barrier", {
    description = S("Barrier"),
    groups = {solid = 1, not_in_creative_inventory = 1}, -- The reason why on this and the remove tool have the group "not_in_creative_inventory" is so that most people would not know these exist.
    tiles = { "black_solidcolor.png" },
    stack_max = 99,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
    if placer and placer:is_player() then
        local has, missing = minetest.check_player_privs(placer, {
            barrier_allow = true,
        })
        if not has then -- Check if the person can place the barrier
            minetest.chat_send_player(placer:get_player_name(),"You do not have the privilege \"barrier_allow\"")
            minetest.swap_node(pos, {name = "air"})
        end
    else
        minetest.swap_node(pos, {name = "air"})
        minetest.chat_send_all("Barrier misplacement: A player did not place the barrier!!!") -- If something like WorldEdit placed it.
    end
    end
})

minetest.register_tool("barrier:barrier_remove", {
    description = "Barrier Remove Tool",
    inventory_image = "barrier_remove.png",
    groups = {not_in_creative_inventory = 1},
    on_use = function(itemstack, user, pointed_thing)
        if user and user:is_player() then
            local has, missing = minetest.check_player_privs(user, {
                barrier_allow = true,
            })
            if has then -- Check if the person can mine a barrier
                pcall(function() -- This worked better; I don't know why
                    minetest.swap_node(pointed_thing.under, {name = "air"})
                end)
            else
                minetest.chat_send_player(user:get_player_name(),"You do not have the privilege \"barrier_allow\"")
            end
        end
        return itemstack
    end,
})
