# Zellij session helper — names sessions after the git repo root (or cwd),
# mirroring the tmux `tms` convention. Source this from your .zshrc.
zj() {
    local dir="${1:-$PWD}"
    local name
    name=$(basename "$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || echo "$dir")")
    name=$(echo "$name" | tr '.' '_')   # zellij session names dislike dots

    if zellij list-sessions 2>/dev/null | grep -q "^${name}"; then
        zellij attach "$name"
    else
        zellij --session "$name" --new-session-with-layout default
    fi
}
