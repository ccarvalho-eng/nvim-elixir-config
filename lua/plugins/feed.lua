return {
  {
    "neo451/feed.nvim",
    cmd = "Feed",
    opts = {
      feeds = {
        tech = {
          { "https://hnrss.org/frontpage", name = "Hacker News" },
          { "https://lobste.rs/rss", name = "Lobsters" },
          { "https://www.theverge.com/rss/index.xml", name = "The Verge" },
          { "https://feeds.arstechnica.com/arstechnica/index", name = "Ars Technica" },
          { "https://simonwillison.net/atom/everything/", name = "Simon Willison" },
        },

        elixir = {
          { "https://elixir-lang.org/atom.xml", name = "Elixir Blog" },
          { "https://dashbit.co/feed", name = "Dashbit" },
          { "https://fly.io/blog/feed.xml", name = "Fly.io" },
          { "https://underjord.io/feed.xml", name = "Underjord" },
          { "https://www.erlang.org/news.xml", name = "Erlang News" },
          { "https://www.erlang.org/blog.xml", name = "Erlang Blog" },
          { "https://www.erlang-solutions.com/blog/feed/", name = "Erlang Solutions" },
        },

        fp = {
          { "https://www.tweag.io/rss.xml", name = "Tweag" },
        },

        papers = {
          { "https://rss.arxiv.org/rss/cs.PL", name = "arXiv cs.PL" },
          { "https://rss.arxiv.org/rss/cs.DC", name = "arXiv cs.DC" },
        },
      },
    },
  },
}
