#compdef shade-shell
# Zsh completion for shade-shell

_shade_shell() {
    setopt localoptions typesetsilent
    local -a cmds opts flags all described
    local curcontext="$curcontext" state line ret=1
    local cmd="${words[2]}"
    local subcmd="${words[3]}"

    # Helper: run completion backend with fallback to direct completions.py.
    __shade_shell_run() {
        local result
        result=$(shade-shell completion "$@" 2>/dev/null)
        if [[ -z "$result" ]]; then
            local shade_bin lib_dir
            shade_bin=$(command -v shade-shell 2>/dev/null)
            if [[ -n "$shade_bin" ]]; then
                lib_dir=$(python3 -c "
import os
bin_path = os.path.realpath('$shade_bin')
print(os.path.realpath(os.path.join(os.path.dirname(bin_path), '..', 'lib', 'shade')))
" 2>/dev/null)
                if [[ -n "$lib_dir" && -f "$lib_dir/completions.py" ]]; then
                    result=$(python3 "$lib_dir/completions.py" "$@" 2>/dev/null)
                fi
            fi
        fi
        echo "$result"
    }

    # 1st argument: dynamically fetch all commands and scripts.
    if [[ $CURRENT -eq 2 ]]; then
        described=()
        local line name desc
        for line in ${(f)"$(__shade_shell_run --list-all-desc)"}; do
            name="${line%%$'\t'*}"
            [[ -z "$name" ]] && continue
            desc="${line#*$'\t'}"
            [[ "$name" == "$line" ]] && desc="shade command"
            described+=("${name}:${desc}")
        done
        _describe 'shade-shell command' described
        return 0
    fi

    # 2nd argument: subcommand-specific completions.
    if [[ $CURRENT -eq 3 ]]; then
        case "$cmd" in
            wallbash)
                described=()
                local line name desc
                for line in ${(f)"$(__shade_shell_run --list-script-desc)"}; do
                    name="${line%%$'\t'*}"
                    [[ -z "$name" ]] && continue
                    desc="${line#*$'\t'}"
                    [[ "$name" == "$line" ]] && desc="Script"
                    described+=("${name}:${desc}")
                done
                _describe 'script' described && ret=0
                ;;
            completion|completions)
                local -a subs=(
                    '--list-builtins:List built-in commands'
                    '--list-script:List available script names'
                    '--list-script-path:List script paths'
                    '--list-all:List all autocomplete options'
                    'bash:Output bash completion'
                    'zsh:Output zsh completion'
                    'fish:Output fish completion'
                    '--help:Show completion help'
                )
                _describe -t subcommands 'subcommand' subs && ret=0
                ;;
            *)
                described=()
                local line name desc
                for line in ${(f)"$(__shade_shell_run --list-commands-desc "$cmd")"}; do
                    name="${line%%$'\t'*}"
                    [[ -z "$name" ]] && continue
                    desc="${line#*$'\t'}"
                    [[ "$name" == "$line" ]] && desc="Subcommand"
                    described+=("${name}:${desc}")
                done
                if [[ ${#described} -gt 0 ]]; then
                    _describe -t subcommands "${cmd} subcommand" described && ret=0
                fi
                ;;
        esac
        return ret
    fi

    # 3rd+ argument: dynamic options and flags.
    if [[ $CURRENT -ge 4 ]]; then
        described=()
        local line name desc
        for line in ${(f)"$(__shade_shell_run --list-options-desc "$cmd" "$subcmd")"}; do
            name="${line%%$'\t'*}"
            [[ -z "$name" ]] && continue
            desc="${line#*$'\t'}"
            [[ "$name" == "$line" ]] && desc="Option"
            described+=("${name}:${desc}")
        done
        for line in ${(f)"$(__shade_shell_run --list-flags-desc "$cmd" "$subcmd")"}; do
            name="${line%%$'\t'*}"
            [[ -z "$name" ]] && continue
            desc="${line#*$'\t'}"
            [[ "$name" == "$line" ]] && desc="Flag"
            described+=("${name}:${desc}")
        done
        if [[ ${#described} -gt 0 ]]; then
            _describe -t opts "${subcmd} options" described && ret=0
        fi
        return ret
    fi

    return 1
}

compdef _shade_shell shade-shell
