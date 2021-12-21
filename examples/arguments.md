# Arguments 

Arguments can be passed to each subcommand in two ways.

## Using Arguments

GitHub Actions supports an `args` attribute that will pass arguments to the Terragrunt subcommand. Using this `args` attribute will place the arguments at the end of the entire `terragrunt` command, even after all of the arguments defined in the source code. In this example, the argument `-var="env=dev"` will be appended to the `terragrunt init` command.

```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
jobs:
  terragrunt:
    name: 'Terragrunt'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terragrunt Init'
        uses: the-commons-project/terragrunt-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tg_actions_version: 'latest'
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
          args: '-var="env=dev"'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


## Using Environment Variables

Terragrunt supports environment variables named `TF_CLI_ARGS` and `TF_CLI_ARG_name` where `name` is the subcommand that is being executed. Using these environment variables will place the arguments after the subcommand but before any arguments defined in the source code. In this example, the argument `-var="env=dev"` will be appended to the `terragrunt init` command.

```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
jobs:
  terragrunt:
    name: 'Terragrunt'
    runs-on: ubuntu-latest
    steps:
      - name: 'Checkout'
        uses: actions/checkout@master
      - name: 'Terragrunt Init'
        uses: the-commons-project/terragrunt-github-actions@master
        with:
          tf_actions_version: 0.12.13
          tg_actions_version: 'latest'
          tf_actions_subcommand: 'init'
          tf_actions_working_dir: '.'
          tf_actions_comment: true
        env:
          TF_CLI_ARGS_init: '-var="env=dev"'
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
