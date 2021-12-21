# Terragrunt Workspaces

The workspace can be specified using the `TF_WORKSPACE` environment variable.

```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
jobs:
  terraform:
    name: 'Terragrunt'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terragrunt Init'
        uses: the-commons-project/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tg_actions_version: 'latest'
          tg_actions_subcommand: 'init'
          tg_actions_working_dir: '.'
          tg_actions_comment: true
        env:
          TF_WORKSPACE: dev
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

If using the `remote` backend with the `name` argument, the configured workspace will be created for you. If using the `remote` backend with the `prefix` argument, the configured workspace must already exist and will not be created for you.
