-- Unreal Engine development integration for Neovim (launcher version)
--
-- Commands:  UEGenerateLSP, UEBuild, UERebuild, UEClean, UELaunch, UELiveCoding
-- Keymaps:   <leader>ul  Generate LSP
--            <leader>ub  Build
--            <leader>ur  Rebuild
--            <leader>uc  Clean
--            <leader>ue  Launch Editor
--            <leader>uL  Live Coding compile
--            <leader>us  Switch .h <-> .cpp
--
-- Tip: set vim.g.ue_engine_path in a project-local .nvim.lua to skip the engine path prompt.
--      Requires vim.o.exrc = true in init.lua.

local function find_uproject()
  local matches = vim.fn.glob(vim.fn.getcwd() .. '/*.uproject', false, true)
  return matches[1]
end

local function find_editor_target(uproject)
  local project_dir = vim.fn.fnamemodify(uproject, ':h')
  local targets = vim.fn.glob(project_dir .. '/Source/*Editor.Target.cs', false, true)
  if #targets > 0 then
    return vim.fn.fnamemodify(targets[1], ':t:r:r') -- strip .Target.cs → e.g. InvisionaryRugbyEditor
  end
  -- fallback: derive from uproject name
  return vim.fn.fnamemodify(uproject, ':t:r') .. 'Editor'
end

local function get_engine_path()
  if vim.g.ue_engine_path and vim.g.ue_engine_path ~= '' then
    return vim.g.ue_engine_path
  end
  local versions = vim.fn.glob('C:/Program Files/Epic Games/UE_*', false, true)
  local default = #versions > 0 and versions[#versions] or 'C:/Program Files/Epic Games/UE_5.5'
  local path = vim.fn.input('UE Engine path: ', default, 'dir')
  if path == '' then return nil end
  vim.g.ue_engine_path = path
  return path
end

local function run_in_terminal(args)
  vim.cmd 'botright new'
  vim.fn.termopen(args)
  vim.cmd 'startinsert'
end

local function save_all()
  vim.cmd 'wa'
end

-- Switch between .h and .cpp via clangd
local function switch_source_header()
  local params = { uri = vim.uri_from_bufnr(0) }
  vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params, function(err, result)
    if err or not result then
      vim.notify('No corresponding file found', vim.log.levels.WARN)
      return
    end
    vim.cmd('edit ' .. vim.uri_to_fname(result))
  end)
end

vim.api.nvim_create_user_command('UEGenerateLSP', function()
  local uproject = find_uproject()
  if not uproject then
    vim.notify('No .uproject found in ' .. vim.fn.getcwd(), vim.log.levels.ERROR)
    return
  end
  local engine = get_engine_path()
  if not engine then return end

  local project_dir = vim.fn.fnamemodify(uproject, ':h')
  -- UBT outputs compile_commands.json to the engine root; .clangd points clangd there
  local clangd_content = table.concat({
    'CompileFlags:',
    '  CompilationDatabase: ' .. engine:gsub('\\', '/'),
    '  Remove:',
    '    - -fdelayed-template-parsing',
    '    - /GR-',
    '    - /W4',
    '    - /WX',
    '    - /EHsc',
    '    - /Zm*',
    '    - -vctoolsdir*',      -- UBT sets this to "undefined"; let clangd auto-detect MSVC
    '    - -resource-dir*',    -- let clangd use its own resource dir (avoids builtin mismatches)
    '    - /clang:-MD',        -- dependency tracking flags confuse clangd
    '    - /clang:-MF*',
    '    - -fms-hotpatch',
    '    - /Zc:inline',
    '    - -fno-temp-file',
    '    - /Brepro',
    '    - /errorReport:*',
    'Diagnostics:',
    '  Suppress:',
    '    - drv_unknown_argument',
    '    - unknown_warning_option',
    '    - err_drv_unsupported_opt_with_suggestion',
  }, '\n') .. '\n'

  local f = io.open(project_dir .. '/.clangd', 'w')
  if f then
    f:write(clangd_content)
    f:close()
    vim.notify('Wrote .clangd to ' .. project_dir, vim.log.levels.INFO)
  end

  local target = find_editor_target(uproject)
  local ubt = engine .. '/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool.exe'
  run_in_terminal({ ubt, '-Mode=GenerateClangDatabase', '-Project=' .. uproject, target, 'Win64', 'Development' })
  vim.notify('When complete, run :LspRestart to reload clangd', vim.log.levels.INFO)
end, { desc = 'UE: Generate clangd compile database' })

vim.api.nvim_create_user_command('UEBuild', function()
  local uproject = find_uproject()
  if not uproject then vim.notify('No .uproject found', vim.log.levels.ERROR) return end
  local engine = get_engine_path()
  if not engine then return end
  save_all()
  local target = find_editor_target(uproject)
  local bat = engine .. '/Engine/Build/BatchFiles/Build.bat'
  run_in_terminal({ 'cmd', '/k', bat, target, 'Win64', 'Development', uproject, '-WaitMutex' })
end, { desc = 'UE: Build project' })

vim.api.nvim_create_user_command('UERebuild', function()
  local uproject = find_uproject()
  if not uproject then vim.notify('No .uproject found', vim.log.levels.ERROR) return end
  local engine = get_engine_path()
  if not engine then return end
  save_all()
  local target = find_editor_target(uproject)
  local bat = engine .. '/Engine/Build/BatchFiles/Build.bat'
  run_in_terminal({ 'cmd', '/k', bat, target, 'Win64', 'Development', uproject, '-WaitMutex', '-Clean' })
end, { desc = 'UE: Rebuild project (clean + build)' })

vim.api.nvim_create_user_command('UEClean', function()
  local uproject = find_uproject()
  if not uproject then vim.notify('No .uproject found', vim.log.levels.ERROR) return end
  local engine = get_engine_path()
  if not engine then return end
  local target = find_editor_target(uproject)
  local bat = engine .. '/Engine/Build/BatchFiles/Clean.bat'
  run_in_terminal({ 'cmd', '/k', bat, target, 'Win64', 'Development', uproject })
end, { desc = 'UE: Clean project' })

vim.api.nvim_create_user_command('UELaunch', function()
  local uproject = find_uproject()
  if not uproject then vim.notify('No .uproject found', vim.log.levels.ERROR) return end
  local engine = get_engine_path()
  if not engine then return end
  local editor = engine .. '/Engine/Binaries/Win64/UnrealEditor.exe'
  vim.fn.jobstart({ editor, uproject }, { detach = true })
  vim.notify('Launching Unreal Editor...', vim.log.levels.INFO)
end, { desc = 'UE: Launch Unreal Editor' })

vim.api.nvim_create_user_command('UELiveCoding', function()
  local uproject = find_uproject()
  if not uproject then vim.notify('No .uproject found', vim.log.levels.ERROR) return end
  local engine = get_engine_path()
  if not engine then return end
  save_all()
  local target = find_editor_target(uproject)
  -- -LiveCoding tells UBT to communicate with the running editor's live coding server
  -- Requires Live Coding enabled in Editor Preferences > Live Coding
  local ubt = engine .. '/Engine/Binaries/DotNET/UnrealBuildTool/UnrealBuildTool.exe'
  run_in_terminal({ ubt, target, 'Win64', 'Development', '-Project=' .. uproject, '-LiveCoding' })
end, { desc = 'UE: Trigger Live Coding compile (editor must be open with Live Coding enabled)' })

vim.keymap.set('n', '<leader>ul', '<cmd>UEGenerateLSP<cr>', { desc = '[U]E: Generate [L]SP' })
vim.keymap.set('n', '<leader>ub', '<cmd>UEBuild<cr>',       { desc = '[U]E: [B]uild' })
vim.keymap.set('n', '<leader>ur', '<cmd>UERebuild<cr>',     { desc = '[U]E: [R]ebuild' })
vim.keymap.set('n', '<leader>uc', '<cmd>UEClean<cr>',       { desc = '[U]E: [C]lean' })
vim.keymap.set('n', '<leader>ue', '<cmd>UELaunch<cr>',      { desc = '[U]E: Launch [E]ditor' })
vim.keymap.set('n', '<leader>uL', '<cmd>UELiveCoding<cr>',  { desc = '[U]E: [L]ive Coding compile' })
vim.keymap.set('n', '<leader>us', switch_source_header,     { desc = '[U]E: [S]witch .h/.cpp' })

return {}
