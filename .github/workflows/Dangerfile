# Note that this DangerFile is for the gem configuration for CircleCI. When we switch to GitHub Actions we can use the
# DangerFile.df.kts file instead.
#
# Once we migrate, the following can be cleaned up:
#
#   1. This file (DangerFile) should be removed
#     * Port over any rules that we want to DangerFile.df.kts
#
#   2. Remove "gem 'danger'" from the gemfile
#

# PR size check
if git.insertions > 0 && git.lines_of_code > 500
  fail("PR has more than 500 line changes")
end