# TargetCompare

This is a simple map application that allows you to quickly compare two targets 
of a Xcode project.

## Planned features

Currently two targets are only compared for missing members (code) and resources.

We would like to add some more functions to inspect targets:

* Check for absolute paths (these usually work well on yours and not so
well on your team mates' machines)
* Check for missing @2x resources
* Compare localizations: maybe one is missing a resources 
(for localizable strings there is the excellent [Linguan app][linguan])

[linguan]: http://www.cocoanetics.com/apps/linguan/
