#!/usr/bin/env bash

${NO_PARALLEL_BUILD:=}

# Check is Git exists
has_git() {
    command -v git >/dev/null
}

# Check is Docker exists
has_docker() {
    command -v docker >/dev/null
}

# Check is Docker Compose exists
has_docker_compose() {
    command -v docker-compose >/dev/null
}

# Check requirements
assert_git_exists() {
    if ! has_git; then
        echo "The Git is not found" >&2
        exit 2
    fi
}

# Check requirements
assert_docker_exists() {
    if ! has_docker; then
        echo "The Docker is not found" >&2
        exit 2
    fi
}

# Check requirements
assert_docker_compose_exists() {
    if ! has_docker_compose; then
        echo "The Docker is not found" >&2
        exit 2
    fi
}

# Get current branch
git_branch_name() {
    #git rev-parse --abbrev-ref HEAD
    git symbolic-ref --short HEAD 2>/dev/null || true
}

# Get latest commit hash
git_commit_hash() {
    git rev-parse --short=7 HEAD
}

# Get latest commit tag, sorted by name
git_commit_tag() {
    git for-each-ref refs/tags --sort=-refname --format='%(refname:short)' --count=1 --contain HEAD
}

# Test docker-compose parallel build feature
can_parallel_build() {
    if [[ -n "$NO_PARALLEL_BUILD" ]]; then
        return 1
    fi
    docker-compose build --help | grep -q ' --parallel '
}
