#!/bin/bash

planemo conda_init

exit_code="0"
sort -R "$1" | while read repository
do
    repo_dir=$(basename "$repository")
    git clone --depth=1 "$repository" "$repo_dir"
    cd "$repo_dir"
    planemo ci_find_repos  --exclude packages --exclude deprecated --exclude_from .tt_skip --output repository_list.txt
    while read tool_dir
    do
        planemo container_register --force_push --recursive "$tool_dir"
        exit_code=$(( "$exit_code" | "$?" ))
    done < repository_list.txt
    cd -
    rm -rf "$repo_dir"
done

exit $exit_code