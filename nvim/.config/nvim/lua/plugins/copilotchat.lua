return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      prompts = {
        Rename = {
          prompt = "You are a helpful assistant that helps to rename variables, functions, classes, and other identifiers in the code. You will be given a piece of code and a new name for the identifier. Your task is to rename all occurrences of the identifier in the code while keeping the code functional and maintaining its original structure as much as possible. Please provide the modified code with the renamed identifier.",
          selection = function(source)
            local select = require "CopilotChat.select"
            return select.visual(source)
          end,
        },
        Docs = {
          prompt = [[
Please generate a comprehensive documentation block for the selected code.

Strict Guidelines:
1. Detect the programming language of the snippet.
2. Use the standard documentation convention for that language (e.g., JSDoc, Python Docstrings, Rustdoc, Javadoc).
3. Include:
   - A concise summary of functionality.
   - Parameters: Name, Type, and Description.
   - Return Value: Type and Description.
   - Exceptions/Errors: If applicable.
4. Output ONLY the documentation comment block. Do not include the original code or conversational filler.
]],
          system_prompt = "You are a Senior Technical Writer. You excel at writing clear, standard-compliant API documentation for software libraries.",
          description = "Generate standard code documentation (JSDoc, Docstrings, etc.)",
        },
        NoComments = {
          prompt = "Please remove all comments (single-line and multi-line) from the provided code. Maintain the original code logic, indentation, and formatting. Do not change any functional code or string literals. Output ONLY the cleaned code without any conversational filler.",
          system_prompt = "You are a code refactoring assistant specialized in cleaning and minifying source code by removing non-functional documentation and comments.",
          description = "Remove all comments from the selected code",
          selection = function(source)
            local select = require "CopilotChat.select"
            return select.buffer(source)
          end,
        },
        Optimize = {
          prompt = [[
Please optimize the selected code for performance, readability, and best practices.

Strict Guidelines:
1. Detect the programming language of the snippet.
2. Improve time and space complexity where possible.
3. Refactor for clean, idiomatic style of the detected language.
4. Remove redundant or dead code.
5. Preserve original functionality and behavior.
6. Add brief inline comments only where necessary for clarity.
7. Output ONLY the optimized code. Do not include explanations or conversational text.
]],
          system_prompt = "You are a Senior Software Engineer specializing in code optimization and clean architecture.",
          description = "Optimize selected code for performance and readability",
        },
      },
    },
    keys = {
      { "<leader>zc", ":CopilotChat<CR>", mode = "n", desc = "Open Copilot Chat" },
      { "<leader>zo", ":CopilotChatOpen<CR>", mode = "n", desc = "Open Copilot Chat window" },
      { "<leader>zx", ":CopilotChatClose<CR>", mode = "n", desc = "Close Copilot Chat window" },
      { "<leader>zt", ":CopilotChatToggle<CR>", mode = "n", desc = "Toggle Copilot Chat window" },
      { "<leader>zs", ":CopilotChatStop<CR>", mode = "n", desc = "Stop Copilot Chat output" },
      { "<leader>zr", ":CopilotChatReset<CR>", mode = "n", desc = "Reset Copilot Chat window" },
      { "<leader>zS", ":CopilotChatSave<CR>", mode = "n", desc = "Save Copilot Chat history" },
      { "<leader>zL", ":CopilotChatLoad<CR>", mode = "n", desc = "Load Copilot Chat history" },
      { "<leader>zp", ":CopilotChatPrompts<CR>", mode = "n", desc = "View Copilot Chat prompts" },
      { "<leader>zm", ":CopilotChatModels<CR>", mode = "n", desc = "View Copilot Chat models" },
      { "<leader>ze", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain code with Copilot" },
      { "<leader>zr", ":CopilotChatRename<CR>", mode = "v", desc = "Rename identifier with Copilot" },
      { "<leader>zd", ":CopilotChatDocs<CR>", mode = "v", desc = "Generate documentation with Copilot" },
      { "<leader>zu", ":CopilotChatNoComments<CR>", mode = "v", desc = "Remove comments with Copilot" },
      { "<leader>zg", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize code with Copilot" },
    },
  },
}
