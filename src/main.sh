#!/bin/bash

function stripColors {
  echo "${1}" | sed 's/\x1b\[[0-9;]*m//g'
}

function hasPrefix {
  case ${2} in
    "${1}"*)
      true
      ;;
    *)
      false
      ;;
  esac
}

function parseInputs {
  # Required inputs
  if [ "${INPUT_TF_ACTIONS_VERSION}" != "" ]; then
    tfVersion=${INPUT_TF_ACTIONS_VERSION}
  else
    echo "Input terraform_version cannot be empty"
    exit 1
  fi

  if [ "${INPUT_TG_ACTIONS_VERSION}" != "" ]; then
    tgVersion=${INPUT_TG_ACTIONS_VERSION}
  else
    echo "Input terragrunt_version cannot be empty"
    exit 1
  fi

  if [ "${INPUT_TF_ACTIONS_SUBCOMMAND}" != "" ]; then
    if [[ "${INPUT_TF_ACTIONS_SUBCOMMAND}" = run-all* ]]; then
      tfSubcommand=$(echo $INPUT_TF_ACTIONS_SUBCOMMAND|cut -d ' ' -f 2 )
    else
      tfSubcommand=${INPUT_TF_ACTIONS_SUBCOMMAND}
    fi
  else
    echo "Input terraform_subcommand cannot be empty"
    exit 1
  fi

  # Optional inputs
  tfBinary="terragrunt"
  if [[ -n "${INPUT_TF_ACTIONS_BINARY}" ]]; then
    tfBinary=${INPUT_TF_ACTIONS_BINARY}
  fi

  tfComment=0
  if [ "${INPUT_TF_ACTIONS_COMMENT}" == "1" ] || [ "${INPUT_TF_ACTIONS_COMMENT}" == "true" ]; then
    tfComment=1
  fi

  tfCLICredentialsHostname=""
  if [ "${INPUT_TF_ACTIONS_CLI_CREDENTIALS_HOSTNAME}" != "" ]; then
    tfCLICredentialsHostname=${INPUT_TF_ACTIONS_CLI_CREDENTIALS_HOSTNAME}
  fi

  tfCLICredentialsToken=""
  if [ "${INPUT_TF_ACTIONS_CLI_CREDENTIALS_TOKEN}" != "" ]; then
    tfCLICredentialsToken=${INPUT_TF_ACTIONS_CLI_CREDENTIALS_TOKEN}
  fi

  tfFmtWrite=0
  if [ "${INPUT_TF_ACTIONS_FMT_WRITE}" == "1" ] || [ "${INPUT_TF_ACTIONS_FMT_WRITE}" == "true" ]; then
    tfFmtWrite=1
  fi

  tfWorkspace="default"
  if [ -n "${TF_WORKSPACE}" ]; then
    tfWorkspace="${TF_WORKSPACE}"
  fi

  if [ -n "${INPUT_TF_MULTI_ENV_DIR}" ]; then
    tfMultiEnvironmentDir="${INPUT_TF_MULTI_ENV_DIR}"
  fi
}

function configureCLICredentials {
  if [[ ! -f "${HOME}/.terraformrc" ]] && [[ "${tfCLICredentialsToken}" != "" ]]; then
    cat > ${HOME}/.terraformrc << EOF
credentials "${tfCLICredentialsHostname}" {
  token = "${tfCLICredentialsToken}"
}
EOF
  fi
}

function installTerraform {
  echo "::group::Install Terraform"
  if [[ "${tfVersion}" == "latest" ]]; then
    echo "Checking the latest version of Terraform"
    tfVersion=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].version' | grep -v '[-].*' | sort -rV | head -n 1)

    if [[ -z "${tfVersion}" ]]; then
      echo "Failed to fetch the latest version"
      exit 1
    fi
  fi

  url="https://releases.hashicorp.com/terraform/${tfVersion}/terraform_${tfVersion}_linux_amd64.zip"

  echo "Downloading Terraform v${tfVersion}"
  curl -s -S -L -o /tmp/terraform_${tfVersion} ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully downloaded Terraform v${tfVersion}"

  echo "Unzipping Terraform v${tfVersion}"
  unzip -d /usr/local/bin /tmp/terraform_${tfVersion} &> /dev/null
  if [ "${?}" -ne 0 ]; then
    echo "Failed to unzip Terraform v${tfVersion}"
    exit 1
  fi
  echo "Successfully unzipped Terraform v${tfVersion}"
  echo "::endgroup::"
}

function installTerragrunt {
  echo "::group::Install Terragrunt"
  if [[ "${tgVersion}" == "latest" ]]; then
    echo "Checking the latest version of Terragrunt"
    latestURL=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/gruntwork-io/terragrunt/releases/latest)
    tgVersion=${latestURL##*/}

    if [[ -z "${tgVersion}" ]]; then
      echo "Failed to fetch the latest version"
      exit 1
    fi
  fi

  url="https://github.com/gruntwork-io/terragrunt/releases/download/${tgVersion}/terragrunt_linux_amd64"

  echo "Downloading Terragrunt ${tgVersion}"
  curl -s -S -L -o /tmp/terragrunt ${url}
  if [ "${?}" -ne 0 ]; then
    echo "Failed to download Terragrunt ${tgVersion}"
    exit 1
  fi
  echo "Successfully downloaded Terragrunt ${tgVersion}"

  echo "Moving Terragrunt ${tgVersion} to PATH"
  chmod +x /tmp/terragrunt
  mv /tmp/terragrunt /usr/local/bin/terragrunt 
  if [ "${?}" -ne 0 ]; then
    echo "Failed to move Terragrunt ${tgVersion}"
    exit 1
  fi
  echo "Successfully moved Terragrunt ${tgVersion}"
  echo "::endgroup::"
}

function executeSubcommand {
  case "${tfSubcommand}" in
    fmt)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntFmt ${*}
      echo "::endgroup::"
      ;;
    init)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntInit ${*}
      echo "::endgroup::"
      ;;
    validate)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntValidate ${*}
      echo "::endgroup::"
      ;;
    plan)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntPlan ${*}
      echo "::endgroup::"
      ;;
    apply)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntApply ${*}
      echo "::endgroup::"
      ;;
    output)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntOutput ${*}
      echo "::endgroup::"
      ;;
    import)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntImport ${*}
      echo "::endgroup::"
      ;;
    taint)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntTaint ${*}
      echo "::endgroup::"
      ;;
    destroy)
      installTerragrunt
      echo "::group::Executing subcommand \"${tfSubcommand}\" for environment: \"${envDir}\""
      terragruntDestroy ${*}
      echo "::endgroup::"
      ;;
    *)
      echo "::error::Must provide a valid value for terragrunt_subcommand"
      exit 1
      ;;
  esac
}


function main {
  # Source the other files to gain access to their functions
  scriptDir=$(dirname ${0})
  source ${scriptDir}/terragrunt_fmt.sh
  source ${scriptDir}/terragrunt_init.sh
  source ${scriptDir}/terragrunt_validate.sh
  source ${scriptDir}/terragrunt_plan.sh
  source ${scriptDir}/terragrunt_apply.sh
  source ${scriptDir}/terragrunt_output.sh
  source ${scriptDir}/terragrunt_import.sh
  source ${scriptDir}/terragrunt_taint.sh
  source ${scriptDir}/terragrunt_destroy.sh

  parseInputs
  configureCLICredentials
  installTerraform
  cd ${GITHUB_WORKSPACE}

  if [[ ! -d "$tfMultiEnvironmentDir" ]]
  then
      echo "::error::Multi environment directory doesn't exist: $(pwd)/${tfMultiEnvironmentDir}"
      exit 1
  fi

  # array with enviroments where files are changed
  envDirsWithChanges=()

  # set to true to update all environments
  updateAllEnvironments=false

  echo "::group::Locate environments"

  # get changed files
  changedFiles=$(git diff --name-only origin/main...)
  if [ ${#changedFiles[@]} -eq 0 ]; then
      echo "::warning Nothing to do, no changes detected."
      exit 0
  fi

  # get all directories inside the environments directory
  environmentDirs=$(find "$tfMultiEnvironmentDir" -maxdepth 1 -mindepth 1 -type d -printf '%f\n')
  if [ ${#environmentDirs[@]} -eq 0 ]; then
    echo "::warning No directories found."
    exit 0
  else
    echo "Found the following environment directories:"
    for envDir in ${environmentDirs[@]}; do
      envDirPath="$tfMultiEnvironmentDir/$envDir"
      echo "- $envDirPath"
    done
  fi

  echo "::endgroup::"

  echo "::group::Environments that will be updated"

  globalHclFiles=$(find "$tfMultiEnvironmentDir" -maxdepth 1 -mindepth 1 -type f -name \*.hcl -printf '%f\n')

  # check if any global .hcl files are changed
  for changedFile in $changedFiles; do

    for globalHclFile in $globalHclFiles; do
      if [[ "$changedFile" == "$tfMultiEnvironmentDir/$globalHclFile" ]]; then
        updateAllEnvironments=true
        break
      fi
    done

    if [ "$updateAllEnvironments" = true ]; then
      break
    fi

  done

  if [ "$updateAllEnvironments" = false ]; then
    for changedFile in $changedFiles; do

      # get environments with changed files
      for envDir in $environmentDirs; do

        # example: "environment/prod"
        envDirPath="$tfMultiEnvironmentDir/$envDir"

        # check if changed file is inside the environment dir
        if hasPrefix "$envDirPath" "${changedFile}"; then

            # add envDir to array if not already present
            if [[ ! "${envDirsWithChanges[*]}" =~ "${envDirPath}" ]]; then
                envDirsWithChanges+=("$envDirPath")
            fi

            # found, no reason to check leftovers
            break
        fi
      done
    done

  elif [ "$updateAllEnvironments" = true ]; then

    echo "All environments will be updated because a global .hcl file is changed."

    for envDir in $environmentDirs; do

      envDirPath="$tfMultiEnvironmentDir/$envDir"
      envDirsWithChanges+=("$envDirPath")
    done
  fi


  echo "The subcommand will be executed for the following environments with changes:"
  for envDir in ${envDirsWithChanges[@]}; do
    echo "- $envDir"
  done
  echo "::endgroup::"

  for envDir in ${envDirsWithChanges[@]}; do
    cd "$envDir"
    executeSubcommand
  done
}

main "${*}"
