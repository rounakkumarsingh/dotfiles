vim.keymap.set("n", "R", function()
  vim.notify("Custom R mapping triggered", vim.log.levels.INFO)
  
  -- Prevent errors if Snacks is not loaded
  local Snacks = require("snacks")
  if not Snacks or not Snacks.rename then
    vim.notify("Snacks.rename is not available", vim.log.levels.WARN)
    return
  end

  local original_file_path = vim.b.netrw_curdir .. "/" .. vim.fn["netrw#Call"]("NetrwGetWord")

  vim.ui.input({ prompt = "Move/rename to:", default = original_file_path }, function(target_file_path)
    if target_file_path and target_file_path ~= "" then
      local file_exists = vim.uv.fs_access(target_file_path, "W")

      if not file_exists then
        vim.uv.fs_rename(original_file_path, target_file_path)

        -- Prompt user whether to update imports
        vim.ui.select({ "Yes", "No" }, { prompt = "Update imports across project?" }, function(choice)
          if choice == "Yes" then
            Snacks.rename.on_rename_file(original_file_path, target_file_path)
          end
          -- Refresh netrw after the whole process (including prompt)
          vim.cmd(":Ex " .. vim.b.netrw_curdir)
        end)
      else
        vim.notify("File '" .. target_file_path .. "' already exists! Skipping...", vim.log.levels.ERROR)
        -- Refresh netrw
        vim.cmd(":Ex " .. vim.b.netrw_curdir)
      end
    end
  end)
end, { remap = false, buffer = true, desc = "Rename file and update imports" })