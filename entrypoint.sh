#!/usr/bin/env bash

# https://elrey.casa/bash/scripting/harden
set -${-//[sc]/}eu${DEBUG:+xv}o pipefail

function main(){
  output_dir="${1:-./output}"
  mkdir -p "${output_dir}"
  tfsec terragoat/ |& tee "${output_dir}/tfsec_output.txt" || true
  find kube-goat/manifests/ -iname "*.y*ml" | xargs -t -I{} kubeaudit all -f {} | tee "${output_dir}/kubeaudit_output.txt" || true
  if [[ -n "${CI:-}" ]] ; then
    cat "${output_dir}/*"
  fi
}

# https://elrey.casa/bash/scripting/main
if [[ "${0}" = "${BASH_SOURCE[0]:-bash}" ]] ; then
  main "${@}"
fi