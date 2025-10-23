local M = setmetatable({}, require("clinic.Collector"))

local ni = require("infra.ni")

M.ns = ni.create_namespace("clinic.shellcheck")

function M:cmd(outfile) return "shellcheck", { "--format=json", outfile } end

do
  ---@class clinic.shellcheck.Check
  ---@field file string
  ---@field line integer
  ---@field endLine integer
  ---@field column integer
  ---@field endColumn integer
  ---@field level 'warning'|'error' @completeme
  ---@field code integer
  ---@field message string

  ---@param plains string[]
  ---@return clinic.shellcheck.Check[]
  function M:populate_checks(plains)
    --shellcheck outputs: '[check,check]'
    assert(#plains == 1)
    return vim.json.decode(plains[1])
  end
end

do
  local level_severity = {
    warning = "WARN",
    ["error"] = "ERROR",
    info = "INFO",
  }

  ---@param check clinic.shellcheck.Check
  ---@return vim.Diagnostic
  function M:check_to_diagnostic(bufnr, check)
    local lnum = check.line - 1
    local end_lnum = check.endLine and check.endLine - 1 or nil
    local severity = assert(level_severity[check.level], check.level)
    return { bufnr = bufnr, lnum = lnum, end_lnum = end_lnum, col = check.column, end_col = check.endColumn, severity = severity, message = check.message, code = check.code }
  end
end

return M
