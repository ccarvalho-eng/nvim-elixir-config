local witcher_quotes = {
  {
    quote = "Evil is evil. Lesser, greater, middling... makes no difference.",
    author = "Geralt of Rivia",
  },
  {
    quote = "People like to invent monsters and monstrosities. Then they seem less monstrous themselves.",
    author = "Geralt of Rivia",
  },
  {
    quote = "To be neutral does not mean to be indifferent or insensitive. You don't have to kill your feelings.",
    author = "Geralt of Rivia",
  },
  {
    quote = "If I'm to choose between one evil and another, I'd rather not choose at all.",
    author = "Geralt of Rivia",
  },
  {
    quote = "Mistakes... are also important to me. I don't cross them out of my life, or memory.",
    author = "Geralt of Rivia",
  },
  {
    quote = "Destiny is just the embodiment of the soul's desire to grow.",
    author = "Yennefer of Vengerberg",
  },
  {
    quote = "Magic is chaos, art and science. It is a curse, a blessing and progress.",
    author = "Yennefer of Vengerberg",
  },
  {
    quote = "No one wants to suffer. But yet it is our lot. And some suffer more. Not necessarily of their own volition.",
    author = "Dandelion",
  },
  {
    quote = "Sometimes there is nothing worse than getting exactly what you wished for.",
    author = "Tissaia de Vries",
  },
  {
    quote = "The sword of destiny has two edges. You are one of them.",
    author = "Calanthe",
  },
  {
    quote = "We never get to choose. We just... adapt.",
    author = "Ciri",
  },
  {
    quote = "Fear is an illness. If you catch it and leave it untreated, it can consume you.",
    author = "Calanthe",
  },
  {
    quote = "Before a sword pierces a body, it must first pierce the soul.",
    author = "Cahir",
  },
  {
    quote = "I manage because I have to. Because I've no other way out. Because I've overcome the vanity and pride of being different.",
    author = "Geralt of Rivia",
  },
  {
    quote = "When you know about something it stops being a nightmare. When you know how to fight something, it stops being so threatening.",
    author = "Uncle Vesemir",
  },
  {
    quote = "Well, we're afeared. And what of it? Do we sit down and weep and tremble? Life must go on.",
    author = "Yurga",
  },
  {
    quote = "It is easy to kill with a bow, girl. How easy it is to release the bowstring and think, it is not I, it is the arrow.",
    author = "Geralt of Rivia",
  },
  {
    quote = "Only Evil and Greater Evil exist and beyond them, in the shadows, lurks True Evil.",
    author = "Renfri",
  },
  {
    quote = "The world is full of evil, so it's sufficient to stride ahead, and destroy the Evil encountered on the way.",
    author = "Regis",
  },
  {
    quote = "Every myth, every fable must have some roots. Most often a dream, a wish, a desire, a yearning.",
    author = "Geralt of Rivia",
  },
  {
    quote = "But do you know when stories stop being stories? The moment someone begins to believe in them.",
    author = "Codringher",
  },
  {
    quote = "There is never a second opportunity to make a first impression.",
    author = "Andrzej Sapkowski, Sword of Destiny",
  },
  {
    quote = "You've mistaken the stars reflected on the surface of the lake at night for the heavens.",
    author = "Andrzej Sapkowski, Blood of Elves",
  },
  {
    quote = "Only death can finish the fight, everything else only interrupts the fighting.",
    author = "Andrzej Sapkowski",
  },
  {
    quote = "It's better to die than to live in the knowledge that you've done something that needs forgiveness.",
    author = "Andrzej Sapkowski, Blood of Elves",
  },
  {
    quote = "I need this conversation. They say silence is golden. Maybe it is, although I'm not sure it's worth that much. It has its price certainly; you have to pay for it.",
    author = "Andrzej Sapkowski, The Last Wish",
  },
}

math.randomseed(os.time())

local function wrap_text(text, max_width)
  local words = {}
  for word in text:gmatch("%S+") do
    table.insert(words, word)
  end

  local lines = {}
  local current_line = ""

  for _, word in ipairs(words) do
    local test_line = current_line == "" and word or current_line .. " " .. word
    if #test_line <= max_width then
      current_line = test_line
    else
      if current_line ~= "" then
        table.insert(lines, current_line)
      end
      current_line = word
    end
  end

  if current_line ~= "" then
    table.insert(lines, current_line)
  end

  return lines
end

local function get_random_witcher_quote()
  local selected = witcher_quotes[math.random(#witcher_quotes)]
  local lines = {}
  local max_width = 60
  local author_width = 70

  local quote_text = selected.quote
  local wrapped_lines = wrap_text(quote_text, max_width)

  for _, line in ipairs(wrapped_lines) do
    table.insert(lines, '"' .. line .. '"')
  end

  local author_line = "- " .. selected.author
  table.insert(lines, string.format("%" .. author_width .. "s", author_line))

  return lines
end

return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    priority = 999,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      -- Witcher logo
      local header = {
        [[          ⠀⠀ ⠀⠀⠀⢀⡔⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⡀⠀⠀⠀⠀⠀]],
        [[          ⠀ ⠀⠀⠀⠀⢾⢿⣄⡀⠀⠀⠀⠀⠀⠱⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⠎⠀⠀⠀⠀⠀⢀⣠⡿⡷⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠈⡳⣿⣻⣿⣶⣤⣄⡀⠀⠘⣿⣷⡼⣦⡹⣿⣿⣿⣿⣿⣿⢏⣴⢇⣾⣿⠃⠀⢀⣠⣤⣶⣿⣟⣿⢞⠁⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⢳⡠⡙⠷⣯⣻⢿⣿⣿⣶⢌⣩⣭⣭⣥⣽⣿⣿⣿⣿⣯⣮⣭⣭⣍⡡⣶⣿⣿⡿⣟⣽⠾⢋⠄⡞⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠈⢧⢻⣶⡝⠻⣿⣿⡿⣿⣿⣿⣿⣿⣿⡿⢿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⢿⣿⣿⠟⢫⣶⡟⡼⠁⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠈⢧⡛⣿⣶⡄⠙⢵⣷⣯⣻⢿⣷⣿⢿⣿⢸⡇⣿⡿⣿⣾⡿⣟⣽⣾⡮⠋⢠⣶⣿⢏⡼⠁⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠐⠒⠺⠿⢿⣦⠀⠙⢌⠛⢇⣴⣷⡌⠙⣻⢽⣾⣟⡏⣿⣿⣿⣿⢹⣻⣷⡯⣿⠏⢡⣾⣦⡸⠛⡡⠋⠀⣰⡿⠿⠗⠒⠂⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⣁⣠⣴⣜⡿⣿⣿⡼⣄⡉⠉⠈⠙⡿⣿⡟⢿⣿⢿⠋⠁⠉⢉⣠⢯⣿⣿⢿⣣⣦⣄⣈⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⣀⣠⣴⣶⣿⣿⣿⣿⣿⣿⣷⣯⣻⢿⣭⣿⣼⣿⢽⣿⣧⣼⣿⡯⣷⣧⣿⣭⡷⣟⣽⣾⣿⣿⣿⣿⣿⣿⣶⣦⣄⣀⠀⠀⠀]],
        [[           ⠐⠚⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠚⠙⢿⡻⢯⣿⣿⣿⣿⡽⢟⡿⠋⠓⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠓⠂]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⣶⣶⣶⣶⡦⠀⣯⣖⠈⠉⠉⠁⣲⣽⠀⢴⣶⣶⣶⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⢛⡿⠿⠿⠿⠿⢿⡟⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⢸⡟⡶⡤⢤⢼⢻⡇⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⠟⠋⠀⠀⠀⠀⣠⣴⡖⠀⠸⠀⠃⠀⠀⠘⠀⠇⠀⢲⣦⣄⠀⠀⠀⠀⠉⠻⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⣰⣿⣿⠟⠋⠀⠀⠀⠀⢀⣤⣾⣿⠏⠀⠀⢡⠀⡀⠀⠀⢀⠀⡌⠀⠀⠹⣿⣷⣤⡀⠀⠀⠀⠀⠙⠻⣿⣿⣆⠀⠀⠀⠀]],
        [[           ⠀⠀⢀⣼⡿⠏⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠏⠀⠀⠀⢸⡇⣿⣦⣴⣿⢸⡇⠀⠀⠀⠸⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠹⢿⣧⡀⠀⠀]],
        [[           ⠀⢀⠜⠉⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⠋⠀⠀⠀⠀⢸⡇⣿⣿⣿⣿⢸⡇⠀⠀⠀⠀⠙⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠉⠣⡀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡿⠃⠀⠀⠀⠀⠀⠸⠀⠙⠿⠿⠊⠀⠇⠀⠀⠀⠀⠀⠘⢿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠁⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⠈⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡣⠤⠤⢜⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢛⣤⣤⣤⣤⡓⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[           ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        [[                                                           ]],
        [[]],
      }

      -- Add random quote
      local quote_lines = get_random_witcher_quote()
      for _, line in ipairs(quote_lines) do
        table.insert(header, line)
      end

      dashboard.section.header.val = header
      dashboard.section.header.opts.hl = "AlphaHeader"

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
        dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = ""

      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
    end,
    keys = {
      { "<leader>ud", "<cmd>Alpha<cr>", desc = "Open dashboard" },
    },
  },
}
