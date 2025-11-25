#!/bin/bash
set -e
pytest tests/integration --junitxml=tests/integration/integration-results.xml
