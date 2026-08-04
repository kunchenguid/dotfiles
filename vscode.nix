# VSCode plus its extensions, installed from nixpkgs like every other package.
# Kept in its own file so editor/extension changes are easy to find and edit.
{ pkgs, ... }:

{
  home.packages = [
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        golang.go                 # Go language support
        rust-lang.rust-analyzer   # Rust language server
        ms-python.vscode-pylance  # Python language server (unfree)
        saoudrizwan.claude-dev # Cline for local agents
        shd101wyy.markdown-preview-enhanced
        jnoortheen.nix-ide # nix language server
      ];
    })
  ];
}
