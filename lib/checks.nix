# Quality checks - mirrors the nix-darwin pattern.
# Single source of truth for pre-commit hooks and GitHub Actions.
{
  pkgs,
  src,
}:
{
  # Format check via nixfmt-rfc-style.
  formatting =
    pkgs.runCommand "check-formatting"
      {
        nativeBuildInputs = [ pkgs.nixfmt-rfc-style ];
      }
      ''
        cp -r ${src} $TMPDIR/src
        chmod -R u+w $TMPDIR/src
        cd $TMPDIR/src
        ${pkgs.lib.getExe pkgs.nixfmt-rfc-style} --check $(find . -name '*.nix' -not -path './.direnv/*')
        touch $out
      '';

  # Lint Nix files for anti-patterns.
  statix = pkgs.runCommand "check-statix" { } ''
    cd ${src}
    ${pkgs.lib.getExe pkgs.statix} check .
    touch $out
  '';

  # Detect dead Nix bindings.
  # -L ignores common lambda parameter names (config, lib, pkgs).
  deadnix = pkgs.runCommand "check-deadnix" { } ''
    cd ${src}
    ${pkgs.lib.getExe pkgs.deadnix} -L --fail .
    touch $out
  '';
}
