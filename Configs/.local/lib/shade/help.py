#!/usr/bin/env python3
"""Metadata-driven help pages for shade-shell."""

from __future__ import annotations

import os
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
if str(HERE) not in sys.path:
    sys.path.insert(0, str(HERE))

import completions


def _sort_key(value: str):
    if value.startswith("--"):
        return (2, value)
    if value.startswith("-"):
        return (3, value)
    return (1, value)


def _print_kv(label: str, value: str) -> None:
    if value:
        print(f"{label:<12} {value}")


def _format_list(items: list[tuple[str, str]]) -> None:
    if not items:
        print("  (none)")
        return
    width = max(len(name) for name, _ in items)
    for name, desc in items:
        print(f"  {name:<{width}}  {desc}")


def _find_cmd(commands: dict, token: str):
    for cmd_name, info in commands.items():
        if token == cmd_name or token in info.get("aliases", []):
            return cmd_name, info
    return None, None


def _load_script_index():
    index = {}
    for file_name, meta in completions.scan_all().items():
        stem = Path(file_name).stem
        names = {file_name, stem}
        if meta.get("name"):
            names.add(meta["name"])
        for name in names:
            index[name] = (stem, meta)
    return index


def _print_script_help(script_name: str, meta: dict, subtopic: str = "") -> int:
    print(f"\nshade Help: {script_name}\n")
    _print_kv("Name", meta.get("name") or script_name)
    _print_kv("Version", meta.get("version", ""))
    _print_kv("Summary", meta.get("short", ""))
    usage = meta.get("usage", "").strip() or f"shade-shell {script_name} [subcommand]"
    _print_kv("Usage", usage)

    commands = meta.get("commands", {})
    if subtopic:
        cmd_name, cmd_info = _find_cmd(commands, subtopic)
        if not cmd_info:
            print(f"\nUnknown subcommand: {subtopic}")
            return 1
        print(f"\nSubcommand: {cmd_name}")
        _print_kv("Description", cmd_info.get("desc", ""))
        aliases = ", ".join(cmd_info.get("aliases", []))
        _print_kv("Aliases", aliases)

        print("\nOptions")
        _format_list([(o["opt"], o.get("desc", "Option")) for o in cmd_info.get("options", [])])

        print("\nFlags")
        _format_list([(f["flag"], f.get("desc", "Flag")) for f in cmd_info.get("flags", [])])
        return 0

    print("\nSubcommands")
    subcommands = []
    for cmd, info in commands.items():
        subcommands.append((cmd, info.get("desc", "Subcommand")))
        for alias in info.get("aliases", []):
            subcommands.append((alias, f"Alias for {cmd}"))
    _format_list(sorted(subcommands, key=lambda pair: _sort_key(pair[0])))

    if meta.get("global_flags"):
        print("\nGlobal flags")
        _format_list([(g["flag"], g.get("desc", "Global flag")) for g in meta["global_flags"]])

    return 0


def _print_shade_command_help(command: str, cmd_info: dict) -> int:
    print(f"\nshade Help: {command}\n")
    _print_kv("Name", f"shade-shell {command}")
    _print_kv("Description", cmd_info.get("desc", "shade command"))
    _print_kv("Aliases", ", ".join(cmd_info.get("aliases", [])))

    options = [(o["opt"], o.get("desc", "Option")) for o in cmd_info.get("options", [])]
    flags = [(f["flag"], f.get("desc", "Flag")) for f in cmd_info.get("flags", [])]

    if options:
        print("\nOptions")
        _format_list(options)
    if flags:
        print("\nFlags")
        _format_list(flags)

    return 0


def _print_root_help() -> int:
    shade_meta = completions.parse_new_style(str(completions.SHADE_SHELL_PATH))
    commands = shade_meta.get("commands", {})

    print("\nshade Help\n")
    _print_kv("Usage", shade_meta.get("usage", "shade-shell [command] [args]"))
    _print_kv("Summary", shade_meta.get("short", "shade command runner"))

    rows = []
    for cmd, info in commands.items():
        rows.append((cmd, info.get("desc", "shade command")))
    print("\nCommands")
    _format_list(sorted(rows, key=lambda pair: _sort_key(pair[0])))
    print("\nTip: shade-shell help <command-or-script> [subcommand]")
    return 0


def main(argv: list[str] | None = None) -> int:
    argv = argv if argv is not None else sys.argv[1:]

    if not argv:
        return _print_root_help()

    topic = argv[0]
    subtopic = argv[1] if len(argv) > 1 else ""

    script_index = _load_script_index()
    if topic in script_index:
        script_name, meta = script_index[topic]
        return _print_script_help(script_name, meta, subtopic)

    shade_meta = completions.parse_new_style(str(completions.SHADE_SHELL_PATH))
    cmd_name, cmd_info = _find_cmd(shade_meta.get("commands", {}), topic)
    if cmd_info:
        return _print_shade_command_help(cmd_name, cmd_info)

    print(f"Unknown help topic: {topic}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
