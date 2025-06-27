#! /usr/bin/env python

import json
import re
from argparse import ArgumentParser
from pathlib import Path


def extract_all_sources_entries(text):
    entry_pattern = re.compile(
        r"""
        Types:\s*(?P<Types>[^\n]+)\s+
        URIs:\s*(?P<URIs>[^\n]+)\s+
        Suites:\s*(?P<Suites>[^\n]+)\s+
        Components:\s*(?P<Components>[^\n]+)
        (?:\s+Signed-By:\s*(?P<SignedBy>[^\n]+))?
        (?:\s+Architectures:\s*(?P<Architectures>[^\n]+))?
        """,
        re.VERBOSE,
    )

    entries = []
    for match in entry_pattern.finditer(text):
        entries.append(
            {
                "Types": match.group("Types").strip().split(" "),
                "URIs": match.group("URIs").strip().split(" "),
                "Suites": match.group("Suites").strip().split(" "),
                "Components": match.group("Components").strip().split(" "),
                "Architectures": match.group("Architectures").strip().split(",")
                if match.group("Architectures")
                else None,
                "SignedBy": match.group("SignedBy").strip() if match.group("SignedBy") else None,
            }
        )

    return entries


if __name__ == "__main__":
    parser = ArgumentParser()
    parser.add_argument("file", type=str, help="Path to the sources files", nargs="+")
    args = parser.parse_args()
    entries = []
    for file in args.file:
        with Path(file).open("r") as f:
            content = f.read()

    entries.extend(extract_all_sources_entries(content))
    print(json.dumps(entries, indent=2))

