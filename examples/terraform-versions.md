# Terragrunt Versions

Specify the version of Terraform to be installed using the `tf_actions_version` input. Here, Terraform 0.12.13 is being used.

Specify the version of Terragrunt to be installed and executed using the `tg_actions_version` input. Here v0.22.3 will be used.

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
          tg_actions_version: 'v0.22.3'
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
