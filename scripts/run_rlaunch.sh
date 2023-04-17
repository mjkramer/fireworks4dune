#!/usr/bin/env bash

usage() {
    echo "Usage: $0 fworker_name rlaunch_mode rlaunch_args..."
    echo "fworker_name corresponds to _fworker in the DB"
    echo "rlaunch_mode should be singleshot or rapidfire"
    exit 1
}

fworker_name=$1; shift
if [[ -z "$fworker_name" ]]; then
    usage
fi

rlaunch_mode=$1; shift
if [[ "$rlaunch_mode" != "singleshot" &&
          "$rlaunch_mode" != "rapidfire" ]]; then
    usage
fi

rlaunch_args=("$@"); shift $#

fworker_yaml=$(mktemp --suffix=.yaml)
cat > "$fworker_yaml" <<EOF
name: '$fworker_name'
category: '$fworker_name'
query: '{}'
EOF

if [[ -n "$FW4DUNE_SLEEP_SEC" ]]; then
    sleep $((RANDOM % FW4DUNE_SLEEP_SEC))
fi

if [[ -z "$FW4DUNE_NO_SLEEP" ]]; then
    sleep $((RANDOM % 60))
fi

rlaunch -w "$fworker_yaml" "$rlaunch_mode" "${rlaunch_args[@]}"

rm $fworker_yaml
