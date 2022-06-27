local lsp_status = require('lsp-status')

lsp_status.config({
    diagnostics = false,
})

lsp_status.register_progress()

