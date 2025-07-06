return {
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas({
                select = {
                  "GitHub Workflow",
                  "GitHub Action",
                  "CircleCI config.yml",
                  "gitlab-ci",
                  "Azure Pipelines",
                  "docker-compose.yml",
                  "Hadolint",
                  ".eslintrc",
                  "prettierrc.json",
                  "Stylelint (.stylelintrc)",
                  "Renovate",
                  "dependabot.json",
                  "dependabot-v2.json",
                  "Vercel",
                  "Netlify config",
                  "sqlc configuration",
                  "Golangci-lint Configuration",
                  "Golangci-lint Custom Plugins Configuration",
                  "GraphQL Mesh",
                  "GraphQL Config",
                  "GraphQL Code Generator",
                  "Jenkins X Pipelines",
                  "Jenkins X Requirements",
                  "Jest",
                  "k3d.yaml",
                  ".sops.yaml",
                  "Kubernetes",
                },
                extra = {
                  {
                    description = ".sops.yaml",
                    fileMatch = { ".sops.yaml" },
                    name = ".sops.yaml",
                    url = "file://" .. vim.fn.stdpath("config") .. "/schemas/sops.schema.json",
                  },
                  {
                    name = "Kubernetes",
                    description = "Kubernetes v1.32.2 Strict Schema",
                    url = "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.32.2-standalone-strict/all.json",
                    fileMatch = {
                      -- top-level common filenames
                      "deployment.yaml",
                      "service.yaml",
                      "configmap.yaml",
                      "secret.yaml",
                      "ingress.yaml",
                      "statefulset.yaml",
                      "daemonset.yaml",
                      "job.yaml",
                      "cronjob.yaml",
                      "persistentvolume.yaml",
                      "persistentvolumeclaim.yaml",
                      "namespace.yaml",
                      "role.yaml",
                      "rolebinding.yaml",
                      "clusterrole.yaml",
                      "clusterrolebinding.yaml",
                      "serviceaccount.yaml",

                      -- suffix-style naming
                      "**/*.k8s.yaml",
                      "**/*.kubernetes.yaml",

                      -- k8s-related folders
                      "**/k8s/*.yaml",
                      "**/k8s/**/*.yaml",
                      "**/kubernetes/*.yaml",
                      "**/kubernetes/**/*.yaml",
                      "**/manifests/*.yaml",
                      "**/manifests/**/*.yaml",
                      "**/infra/*.yaml",
                      "**/infra/**/*.yaml",
                      "**/deployments/**/*.yaml",
                      "**/apps/**/k8s/*.yaml",
                      "**/apps/**/k8s/**/*.yaml",
                    },
                  },
                },
              }),
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
            },
          },
        },
      },
    },
  },
}
