# OffensiveHaskell
This is a repository containing examples of offensive Haskell.

## Contents:
- CreateRemoteThreadInjection: Reads raw shellcode from a file on disk and performs VirtualAllocEx -> WriteProcessMemory -> CreateRemoteThread injection on the PID provided as an argument
- BlockDLL: Spawns a child process with the Microsoft Signed Only mitigation to prevent non-Microsoft signed DLLs from being loaded

### Why Haskell? 
I learned about Haskell from a functional programming language course in college and thought it'd be interesting to implement some offensive tooling this way. After finding the Win32 Haskell package, I decided to convert some examples of common offensive tooling to Haskell. 

#### So what are the benefits of Haskell?
Honestly, I'm not sure if there are any. Developing tooling in Haskell is much more cumbersome than any of the mainstream languages used for tooling development. Ironically we have to defeat one of the primary benefits of Haskell, the limitation of side effects, in order to perform many of the tasks accomplished by modern tooling.

#### How about drawbacks?
Large binaries, easy to get into dependency hell, functional languages are not as forgiving as their imperical counterparts.

### Dependencies
This relies on my fork of the Haskell Win32 package which adds certain Windows API calls to the existing repository.
