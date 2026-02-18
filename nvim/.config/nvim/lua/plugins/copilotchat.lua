return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      promts = {
        Rename = {
          promt = "You are a helpful assistant that helps to rename variables, functions, classes, and other identifiers in the code. You will be given a piece of code and a new name for the identifier. Your task is to rename all occurrences of the identifier in the code while keeping the code functional and maintaining its original structure as much as possible. Please provide the modified code with the renamed identifier.",
          selection = function(source)
            local select = require "CopilotChat.select"
            return select.visual(source)
          end,
        },
      },
    },
    keys = {
      { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Chat with Copilot" },
      {
        "<leader>ze",
        ":CopilotChatExplain<CR>",
        mode = "v",
        desc = "Explain code with Copilot",
      },
      { "<leader>zf", ":CopilotChatFix<CR>", mode = "v", desc = "Fix code with Copilot" },
      { "<leader>zo", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code with Copilot" },
      { "<leader>zd", ":CopilotChatDoc<CR>", mode = "v", desc = "Generate documentation with Copilot" },
      { "<leader>zg", ":CopilotChatGenerate<CR>", mode = "v", desc = "Generate code with Copilot" },
      { "<leader>za", ":CopilotChatAsk<CR>", mode = "v", desc = "Ask Copilot a question about the code" },
      { "<leader>zh", ":CopilotChatHistory<CR>", mode = "n", desc = "View Copilot chat history" },
      { "<leader>zl", ":CopilotChatClear<CR>", mode = "n", desc = "Clear Copilot chat history" },
      { "<leader>zs", ":CopilotChatSummarize<CR>", mode = "v", desc = "Summarize code with Copilot" },
      { "<leader>zq", ":CopilotChatQuit<CR>", mode = "n", desc = "Quit Copilot chat" },
      { "<leader>zr", ":CopilotChatRename<CR>", mode = "v", desc = "Rename identifier with Copilot" },
    },
  },
}
