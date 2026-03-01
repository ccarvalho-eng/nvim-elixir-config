return {
  {
    "jakobkhansen/journal.nvim",
    lazy = false,
    opts = {
      filetype = 'md',
      root = vim.env.NVIM_JOURNAL_DIR or vim.fn.expand("~/journal"),
      date_format = '%d/%m/%Y',
      autocomplete_date_modifier = "end",

      journal = {
        format = '%Y/%m-%B/daily/%d-%A',
        template = '# %A %B %d %Y\n',
        frequency = { day = 1 },

        entries = {
          day = {
            format = '%Y/%m-%B/daily/%d-%A',
            template = [[# %A %B %d %Y

## Morning Routine

- [ ] Water
- [ ] Exercise
- [ ] Meditation
- [ ] Breakfast
- [ ] Reading
- [ ] House chores

## Inbox

- [ ] Email
- [ ] Calendar
- [ ] Messages

## Tasks

- [ ]

## Meetings

## Notes

## Achievements

## Learnings

## Tomorrow Tasks

]],
            frequency = { day = 1 },
          },
          week = {
            format = '%Y/%m-%B/weekly/week-%W',
            template = [[# Week %W — %B %Y

## Habit Tracker

| Habit       | Mon | Tue | Wed | Thu | Fri | Sat | Sun | Total |
|-------------|-----|-----|-----|-----|-----|-----|-----|-------|
| Gym         |     |     |     |     |     |     |     |       |
| Meditation  |     |     |     |     |     |     |     |       |
| Reading     |     |     |     |     |     |     |     |       |

## Objectives

- [ ] Personal
  - [ ]
- [ ] Work
  - [ ]

## Achievements

## Learnings

## Next Week Objectives
]],
            frequency = { day = 7 },
            date_modifier = "monday"
          },
          month = {
            format = '%Y/%m-%B/%B',
            template = [[# %B %Y

## Objectives

- [ ] Personal
  - [ ]
- [ ] Work
  - [ ]

## Achievements

## Learnings

## Next Month Objectives
]],
            frequency = { month = 1 }
          },
          quarter = {
            format = function(date)
              local year = os.date("%Y", date)
              local month = tonumber(os.date("%m", date))
              local quarter = math.ceil(month / 3)
              return string.format("%s/Q%d", year, quarter)
            end,
            template = function(date)
              local year = os.date("%Y", date)
              local month = tonumber(os.date("%m", date))
              local quarter = math.ceil(month / 3)
              return string.format([[# Q%d %s

## OKR's

- [ ] Personal
  - [ ]
- [ ] Work
  - [ ]

## Achievements

## Learnings

## Next Quarter Focus
]], quarter, year)
            end,
            frequency = { month = 3 },
          },
          year = {
            format = '%Y/%Y',
            template = [[# %Y

## Objectives

- [ ] Personal
  - [ ]
- [ ] Work
  - [ ]

## Achievements

## Learnings

## Next Year Objectives
]],
            frequency = { year = 1 }
          },
        },
      }
    },

    config = function(_, opts)
      require("journal").setup(opts)

      local wk = require("which-key")
      wk.add({
        { "<leader>j", group = "Journal" },
        { "<leader>jj", "<cmd>Journal<cr>", desc = "Open today's journal" },
        { "<leader>jd", "<cmd>Journal day<cr>", desc = "Daily journal" },
        { "<leader>jw", "<cmd>Journal week<cr>", desc = "Weekly journal" },
        { "<leader>jm", "<cmd>Journal month<cr>", desc = "Monthly journal" },
        { "<leader>jq", "<cmd>Journal quarter<cr>", desc = "Quarterly journal" },
        { "<leader>jY", "<cmd>Journal year<cr>", desc = "Yearly journal" },
        { "<leader>jy", "<cmd>Journal day -1<cr>", desc = "Yesterday's journal" },
        { "<leader>jt", "<cmd>Journal day +1<cr>", desc = "Tomorrow's journal" },
      })
    end,
  },
}
