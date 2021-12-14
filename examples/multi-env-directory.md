# Environments Directory

Terragrunt GitHub Actions supports mutliple environments stored in the multi environment directory. Only environments where files are changed will be updated. The multi environment directory is set using the `tf_multi_env_dir` input. By default, the working directory is set to `environments`.

## Example directory structure
```
└── environments/
    ├── example_env1_prod/
    └── example_env2_test/
```


## Example workflow
```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
jobs:
  root:
    name: 'Terragrunt (root)'
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
          tf_multi_env_dir: 'custom/path/to/environment/dir' # default: "environments"
          tf_actions_comment: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
