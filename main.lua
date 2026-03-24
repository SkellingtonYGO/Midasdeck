SMODS.Atlas {
    key = 'Jokers',      --atlas key
    path = 'Jokers.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71,             --width of one card
    py = 95              -- height of one card
}
SMODS.Atlas({
    key = "decks",
    path = "decks.png",
    px = 71,
    py = 95,
})
SMODS.Atlas {
    key = 'modicon',
    path = 'modicon.png',
    px = 32,
    py = 32,
}

SMODS.Back {
    key = "midasdeck",
    loc_txt = {
        name = "Midas Deck",
        text = {
            'Start run with a',
            '{C:purple}Eternal{} {C:attention}Midas Mask{}',
            '{C:attention}Midas Mask{} now effects',
            'all scored cards'
        }
    },
    atlas = "md_decks",
    pos = { x = 0, y = 0 },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card({ key = 'j_md_deckmidasmask', stickers = { 'eternal' }, force_stickers = true })
                return true
            end
        }))
    end,
}

SMODS.Joker {
    key = "deckmidasmask",
    rarity = 2,
    cost = 7,
    atlas = 'Jokers',          --atlas' key
    unlocked = true,           --where it is unlocked or not: if true,
    discovered = true,         --whether or not it starts discovered
    blueprint_compat = false,  --can it be blueprinted/brainstormed/other
    eternal_compat = true,     --can it be eternal
    perishable_compat = false, --can it be perishable
    allow_duplicates = false,
    in_pool = false,
    no_collection = true,
    pos = { x = 4, y = 2 },
    soul_pos = {
        x = 4, y = 3,
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
    end,
    loc_txt = {
        name = "Midas Mask",
        text = {
            'All played cards',
            'become {C:attention}Gold{} cards',
            'when scored'
        }
    },
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local cards = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                cards = cards + 1
                scored_card:set_ability('m_gold', nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:juice_up()
                        return true
                    end
                }))
            end
            if cards > 0 then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY
                }
            end
        end
    end
}