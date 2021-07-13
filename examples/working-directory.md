# Working Directory

Terragrunt GitHub Actions only supports running in a single working directory at a time. The working directory is set using the `tf_actions_working_dir` input. By default, the working directory is set to `.` which refers to the root of the GitHub repository.

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
          tf_actions_working_dir: '.'
          tf_actions_comment: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

If you need to run the Terragrunt Actions in multiple directories, you have to create separate jobs for each working directory.

```yaml
name: 'Terragrunt GitHub Actions'
on:
  - pull_request
jobs:
  directory1:
    name: 'Terragrunt (directory1)'
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
          tf_actions_working_dir: 'directory1'
          tf_actions_comment: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  directory2:
    name: 'Terragrunt (directory2)'
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
          tf_actions_working_dir: 'directory2'
          tf_actions_comment: true
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```
