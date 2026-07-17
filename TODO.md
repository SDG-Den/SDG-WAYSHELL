# TODO — SDG-WAYSHELL

## Documentation
- [ ] Architecture doc matches current implementation
- [ ] Event sources documented (cursor zones, layout changes, focus)

## Testing
- [ ] Daemon starts and stays running
- [ ] Cursor zone detection
- [ ] Layout change detection
- [ ] Focus event detection
- [ ] Trailing-edge debouncing
- [ ] Matugen color integration
- [ ] Graceful shutdown

notes:
001 - direct installation does not work like that and should not be recommended. background running should be done using mmsg (`mmsg dispatch spawn_shell,wayshell`)
002 - usage should mention it uses the sdg-wayshell-conf package, and that without this package you will not have any functions.
003 - defaults are listed twice, once incorrectly and once correctly. 
004 - redundant.
302 - should be part of SDG-WAYSHELL-CONF repo and not be in this repo at all. 
401 and 402 - should also be documented under SDG-WAYSHELL-CONF repo and not be in this repo at all



