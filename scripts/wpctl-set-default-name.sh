#!/bin/sh

id=$(pw-dump Node | jq ".[] | select(.info.props[\"node.name\"] == \"$1\") | .id")
wpctl set-default ${id}
