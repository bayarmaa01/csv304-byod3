#!/bin/bash
set -e
# run unit tests and write junit xml
pytest tests/unit --junitxml=tests/unit/unit-results.xml
