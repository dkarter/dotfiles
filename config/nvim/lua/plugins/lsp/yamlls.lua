return {
  setup = function()
    return {
      settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },

        yaml = {
          schemaStore = {
            enable = true,
            url = 'https://www.schemastore.org/api/json/catalog.json',
          },
          schemas = {
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
          },
          format = { enabled = false },
          validate = true,
          completion = true,
          hover = true,
        },
      },

      on_attach = function(_client, bufnr)
        -- disable and reset diagnostics for helm files (because the LS can't
        -- read them properly)
        if vim.bo[bufnr].buftype ~= '' or vim.bo[bufnr].filetype == 'helm' then
          vim.diagnostic.disable(bufnr)
          vim.defer_fn(function()
            vim.diagnostic.reset(nil, bufnr)
          end, 1000)
        end
      end,
    }
  end,
}
