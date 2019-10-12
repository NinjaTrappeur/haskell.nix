{ pkgs ? import ../. { inherit nixpkgs nixpkgsArgs; }
, nixpkgs ? <nixpkgs>
, nixpkgsArgs ? { }
}:

with pkgs;

let
  util = callPackage ./util.nix {};
in pkgs.recurseIntoAttrs {
  cabal-simple = haskell-nix.callPackage ./cabal-simple { inherit util; };
  cabal-simple-prof = haskell-nix.callPackage ./cabal-simple-prof { inherit util; };
  cabal-sublib = haskell-nix.callPackage ./cabal-sublib { inherit util; };
  cabal-22 = haskell-nix.callPackage ./cabal-22 { inherit util; };
  with-packages = haskell-nix.callPackage ./with-packages { inherit util; };
  builder-haddock = haskell-nix.callPackage ./builder-haddock {};
  stack-simple = haskell-nix.callPackage ./stack-simple {};
  snapshots = haskell-nix.callPackage ./snapshots {};
  shell-for = haskell-nix.callPackage ./shell-for {};
  callStackToNix = haskell-nix.callPackage ./call-stack-to-nix {};
  callCabalProjectToNix = haskell-nix.callPackage ./call-cabal-project-to-nix {};
  cabal-source-repo = haskell-nix.callPackage ./cabal-source-repo {};
  buildable = haskell-nix.callPackage ./buildable {};
  project-flags-cabal = haskell-nix.callPackage ./project-flags/cabal.nix {};
  project-flags-stack = haskell-nix.callPackage ./project-flags/stack.nix {};

  # Run unit tests with: nix-instantiate --eval --strict -A unit.tests
  # An empty list means success.
  unit = let
    tests = haskell-nix.callPackage ./unit.nix {};
  in runCommand "unit-tests" { passthru = { inherit tests; }; }
     (lib.concatMapStringsSep "\n" (t: "echo ${t.name} failed") tests +
      (if builtins.length tests == 0 then "\ntouch $out" else "\nexit 1"));
}

## more possible test cases
# 1. fully static linking
# 2. cabal 2.4 stuff
# 3. cross-compiling
