#!/usr/bin/env python3
"""Move only conflicting Stow paths into a private backup; never follow links."""
import json
import os
from pathlib import Path
import sys
import tempfile


def conflicts(source, destination):
    if destination.is_symlink():
        if destination.resolve() != source.resolve():
            yield destination
    elif source.is_dir():
        if destination.exists() and not destination.is_dir():
            yield destination
        elif destination.is_dir():
            for child in sorted(source.iterdir()):
                yield from conflicts(child, destination / child.name)
    elif destination.exists():
        yield destination


def main():
    root, target = (Path(value).resolve(strict=True) for value in sys.argv[1:3])
    paths = set()
    for package in sys.argv[3:]:
        source = root / package
        if not source.is_dir() or source.parent != root:
            raise ValueError(f"Invalid Stow package: {package}")
        for child in sorted(source.iterdir()):
            paths.update(conflicts(child, target / child.name))
    # If packages overlap, moving a parent also preserves its descendants.
    paths = sorted(p for p in paths if not any(q in p.parents for q in paths))
    if not paths:
        print("  No link conflicts to back up.")
        return
    base = target / '.dotfiles-backups'
    if base.is_symlink():
        raise ValueError(f"Refusing symlinked backup directory: {base}")
    base.mkdir(mode=0o700, exist_ok=True)
    backup = Path(tempfile.mkdtemp(prefix='setup-', dir=base))
    records = []
    for index, path in enumerate(paths):
        saved = backup / str(index)
        records.append({'original': str(path), 'backup': str(saved)})
    # Write the complete map before any moves so even an interrupted run is recoverable.
    (backup / 'restore.json').write_text(json.dumps(records, indent=2) + '\n')
    for record in records:
        os.rename(record['original'], record['backup'])
        print(f"  Backed up {record['original']} -> {record['backup']}")
    print(f"  Restore map: {backup / 'restore.json'}")


if __name__ == '__main__':
    main()
