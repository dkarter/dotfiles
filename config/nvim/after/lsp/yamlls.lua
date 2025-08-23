local schemaStoreSchemas = require('schemastore').yaml.schemas()

local ownSchemas = {
  ['https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json'] = '/*.k8s.yaml',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/configmap.json'] = '*onfigma*.{yml,yaml}',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/deployment.json'] = '*eployment*.{yml,yaml}',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/service.json'] = '*ervic*.{yml,yaml}',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/ingress.json'] = '*ngres*.{yml,yaml}',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/secret.json'] = '*ecre*.{yml,yaml}',
  ['https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/master/statefulset.json'] = '*stateful*.{yml,yaml}',
  ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
  ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
  ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/*.{yml,yaml}',
  ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
  ['http://json.schemastore.org/ansible-playbook'] = '*play*.{yml,yaml}',
}

local schemas = vim.list_extend(ownSchemas, schemaStoreSchemas)

vim.lsp.config('yamlls', {
  setup = function()
    return {
      settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },

        yaml = {
          schemaStore = {
            -- Must disable built-in schemaStore support using the SchemaStore
            -- plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = '',
          },
          schemas = schemas,
          format = { enabled = false },
          validate = true,
          completion = true,
          hover = true,
        },
      },

      on_attach = function(client, bufnr)
        -- disable and reset diagnostics for helm files (because the LS can't
        -- read them properly)
        local client_name = client.config.name
        local ft = vim.bo[bufnr].filetype
        if client_name == 'yamlls' and ft == 'helm' then
          vim.lsp.stop_client(client.id)
          vim.lsp.buf_detach_client(bufnr, client.id)
        end

        if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
          vim.diagnostic.enable(false, { bufnr = bufnr })
          -- remove existing diagnostic messages that appear about a second after load
          -- (in the status bar). They do end up coming back though after awhile, not
          -- sure why
          vim.defer_fn(function()
            vim.diagnostic.reset(nil, bufnr)
          end, 1000)
        end
      end,
    }
  end,
})
