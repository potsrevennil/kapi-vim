-- Release-only plugin updates, run by .github/workflows/lazy-update.yml:
--
--   nvim --headless -c "luafile .github/scripts/lazy-update.lua"
--
-- `:Lazy sync` moves every plugin to whatever it resolves to upstream,
-- which for most plugins is the branch head. This instead updates only the
-- plugins whose target is a tagged semver release (defaults.version = "*"
-- in lua/config/lazy.lua) and holds the rest -- plugins with an explicit
-- branch, `version = false`, or no release tags at all -- at their locked
-- commit, since there's no release to tell a fix from a work in progress.
--
-- Forward only: a release that the locked commit already contains is
-- skipped. Plenty of plugins are locked past their last tag (plenary's is
-- years old), and "latest release" would otherwise mean a downgrade.
-- Releases cut from a separate branch (neo-tree's v3.x) aren't ancestors
-- either way, so those are compared by version instead.
--
-- Writes a markdown summary to $LAZY_UPDATE_REPORT (for the PR body) and
-- exits non-zero if the check or update fails.

local Config = require("lazy.core.config")
local Git = require("lazy.manage.git")
local Manage = require("lazy.manage")
local Semver = require("lazy.manage.semver")

local function fail(msg)
    io.stderr:write("lazy-update: " .. msg .. "\n")
    vim.cmd("cquit 1")
end

local function git(dir, args)
    local res = vim.system(vim.list_extend({ "git", "-C", dir }, args), { text = true }):wait()
    return res.code == 0 and vim.trim(res.stdout) or nil, res.code
end

-- Does `commit` already contain `target`?
local function contains(dir, commit, target)
    local _, code = git(dir, { "merge-base", "--is-ancestor", target, commit })
    return code == 0
end

-- Nearest release tag at or behind `commit`. Version-shaped tags only:
-- several plugins keep a floating `stable` tag that describe would pick.
local function base_version(dir, commit)
    local tag = git(dir, { "describe", "--tags", "--abbrev=0", "--match=v[0-9]*", "--match=[0-9]*", commit })
    return tag and Semver.version(tag)
end

local function level(from, to)
    if not from then
        return "release"
    elseif from.major ~= to.major then
        return "major"
    elseif from.minor ~= to.minor then
        return "minor"
    end
    return "patch"
end

local ok, err = pcall(function()
    Manage.check({ wait = true, show = false })
end)
if not ok then
    return fail("check failed: " .. tostring(err))
end

local bumps, held = {}, {}
for name, plugin in pairs(Config.plugins) do
    local updates = plugin._.updates
    if updates then
        local from = Git.info(plugin.dir, true)
        local to = updates.to
        local base = from and (from.version or base_version(plugin.dir, from.commit))
        if
            to.version
            and from
            and not contains(plugin.dir, from.commit, to.commit)
            and (not base or base < to.version)
        then
            bumps[#bumps + 1] = {
                name = name,
                from = from.tag or from.commit:sub(1, 7),
                to = to.tag,
                level = level(base, to.version),
            }
        else
            held[#held + 1] = name
        end
    end
end
table.sort(bumps, function(a, b)
    return a.name < b.name
end)
table.sort(held)

if #bumps > 0 then
    ok, err = pcall(function()
        Manage.update({
            wait = true,
            show = false,
            plugins = vim.tbl_map(function(b)
                return b.name
            end, bumps),
        })
    end)
    if not ok then
        return fail("update failed: " .. tostring(err))
    end
end

local lines = {}
if #bumps > 0 then
    vim.list_extend(lines, { "| Plugin | From | To | Change |", "|---|---|---|---|" })
    for _, b in ipairs(bumps) do
        local change = b.level == "major" and "**major**" or b.level
        lines[#lines + 1] = ("| %s | %s | %s | %s |"):format(b.name, b.from, b.to, change)
    end
else
    lines[#lines + 1] = "No new plugin releases."
end
if #held > 0 then
    lines[#lines + 1] = ""
    lines[#lines + 1] = "Held at their locked commit (no newer release to move to): "
        .. table.concat(held, ", ")
        .. "."
end

local report = os.getenv("LAZY_UPDATE_REPORT")
if report then
    vim.fn.writefile(lines, report)
else
    print(table.concat(lines, "\n"))
end
vim.cmd("qall!")
