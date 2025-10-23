local M = setmetatable({}, require("clinic.Collector"))
local its = require("infra.its")
local ni = require("infra.ni")
local strlib = require("infra.strlib")

M.ns = ni.create_namespace("clinic.selene")

function M:cmd(outfile) return "selene", { "--no-summary", "--display-style=json", outfile } end

---@class clinic.selene.Check
---@field severity 'Warning'|'Error'
---@field code integer
---@field message string
---@field notes string[]
---@field secondary_labels string[]
---@field primary_label {filename: string, span: clinic.selene.Check.PrimaryLabelSpan, message: string}

---@class clinic.selene.Check.PrimaryLabelSpan
---@field start integer
---@field start_line integer
---@field start_column integer
---@field end integer
---@field end_line integer
---@field end_column integer

---@param plains string[]
---@return clinic.selene.Check[]
function M:populate_checks(plains)
  --selene outputs: 'check\ncheck\n'
  assert(#plains == 1)

  return its(strlib.iter_splits(plains[1], "\n")) --
    :filter(function(chunk) return chunk ~= "" end)
    :map(vim.json.decode)
    :tolist()
end

do
  local severities = {
    Warning = "WARN",
    Error = "ERROR",
  }

  ---@param check clinic.selene.Check
  ---@return vim.Diagnostic
  function M:check_to_diagnostic(bufnr, check)
    local severity = assert(severities[check.severity], check.severity)
    local lnum = check.primary_label.span.start_line
    local end_lnum = check.primary_label.span.end_line
    local col = check.primary_label.span.start_column
    local end_col = check.primary_label.span.end_column

    return { bufng = bufnr, lnum = lnum, end_lnum = end_lnum, col = col, end_col = end_col, severity = severity, message = check.message, code = check.code }
  end
end

return M

