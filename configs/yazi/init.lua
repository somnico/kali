-- Plugins
if os.getenv("NVIM") then
	require("toggle-pane"):entry("min-preview")
end

require("full-border"):setup {
	type = ui.Border.ROUNDED,
}

require("smart-enter"):setup {
	open_multi = true,
}

require("zoxide"):setup {
	update_db = true,
}

th.git = th.git or {}
th.git.modified = ui.Style():fg("yellow")
th.git.added = ui.Style():fg("green")
th.git.untracked = ui.Style():fg("purple")
th.git.ignored = ui.Style():fg("red")
th.git.deleted = ui.Style():fg("red")
th.git.updated = ui.Style():fg("yellow")

th.git.modified_sign = "M"
th.git.added_sign = "A"
th.git.untracked_sign = "T"
th.git.ignored_sign = "I"
th.git.deleted_sign = "D"
th.git.updated_sign = "U"

require("git"):setup()

-- require("no-status"):setup()

-- require("folder-rules"):setup()


-- Show symlink in status bar
Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)

-- Show user and group in status bar
Status:children_add(function()
	local h = cx.active.current.hovered
	if not h or ya.target_family() ~= "unix" then
		return ""
	end

	return ui.Line {
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		":",
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		" ",
	}
end, 500, Status.RIGHT)

-- Show username and hostname in header
Header:children_add(function()
	if ya.target_family() ~= "unix" then
		return ""
	end
	-- return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
	return ui.Span("  ")
end, 500, Header.LEFT)
