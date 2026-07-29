#!/bin/sh
# Fake sha256sum for testing CodSpeed action pinned version
# Returns the expected hash for version 5.0.1 so hash verification passes
# with the fake installer content
echo "5d8abb100020c7968220ab856c776670abfdc77bb0fac532c56f695af4f4a098  $1"
