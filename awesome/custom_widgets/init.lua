---------------------------------------------------
-- Vicious widgets for the awesome window manager
---------------------------------------------------
-- Licensed under the GNU General Public License v2
---------------------------------------------------

-- {{{ Setup environment
local setmetatable = setmetatable
local wrequire = require("vicious.helpers").wrequire

-- Custom vicious widgets for the awesome window manager
local custom_widgets = { _NAME = "custom_widgets" }
-- }}}

-- Load modules at runtime as needed
return setmetatable(custom_widgets, { __index = wrequire })
