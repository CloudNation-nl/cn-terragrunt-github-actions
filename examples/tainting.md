# Terragrunt Tainting

Resources to taint can be specified using the `args` with option.

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
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
        env:
          TF_WORKSPACE: dev
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - name: 'Terraform Taint'
        uses: the-commons-project/terraform-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tg_actions_version: 'latest'
          tf_actions_subcommand: 'taint'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
          args: 'aws_instance.host'
        env:
          TF_WORKSPACE: dev
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Multiple resources can be specified by separating with spaces: `args: 'aws_instance.host1 aws_instance.host2'`.
