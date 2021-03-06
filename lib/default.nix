{ inputs, ... }: base:
let
    inherit (base) recursiveUpdate;
in base.extend (self: super: let
    pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
    };

    f = path: import path {
        lib = self;
        inherit inputs pkgs;
    };
in recursiveUpdate super (rec {
    attrs = f ./attrs.nix;
    lists = f ./lists.nix;
    generators = f ./generators.nix;
    importers = f ./importers.nix;
    misc = f ./misc.nix;

    # custom stuff
    objects = {
        addrs = f ./objects/addrs.nix;
    };

    ansi = f ./ansi.nix;
    systemd = f ./systemd.nix;

    inherit (attrs) mapFilterAttrs genAttrs' attrCount defaultAttrs defaultSetAttrs
        imapAttrsToList recursiveMerge recursiveMergeAttrsWithNames recursiveMergeAttrsWith;
    inherit (lists) filterListNonEmpty;
    inherit (generators) mkProfileAttrs;
    inherit (importers) pathsToImportedAttrs recursiveModuleTraverse recImportFiles recImportDirs nixFilesIn;
    inherit (misc) optionalPath optionalPathImport isIPv6 tryEval';

    inherit (objects.addrs) addrOpts addrToString addrToOpts addrsToOpts;
}))
