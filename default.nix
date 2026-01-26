{ lib ? (import <nixpkgs> {}).lib
, stdenv ? (import <nixpkgs> {}).stdenv
, makeWrapper ? (import <nixpkgs> {}).makeWrapper
, bash ? (import <nixpkgs> {}).bash
, git ? (import <nixpkgs> {}).git
, fzf ? (import <nixpkgs> {}).fzf
, coreutils ? (import <nixpkgs> {}).coreutils
, gnugrep ? (import <nixpkgs> {}).gnugrep
, gnused ? (import <nixpkgs> {}).gnused
, gawk ? (import <nixpkgs> {}).gawk
}:

stdenv.mkDerivation rec {
  pname = "git-branch-selector";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ git fzf ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp b.sh $out/bin/b
    chmod +x $out/bin/b

    wrapProgram $out/bin/b \
      --prefix PATH : ${lib.makeBinPath [ bash git fzf coreutils gnugrep gnused gawk ]}

    mkdir -p $out/share/man/man1
    cp b.1 $out/share/man/man1/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Interactive Git branch selector using fuzzy finding";
    longDescription = ''
      A Bash script that helps you select and checkout Git branches
      interactively using fzf (fuzzy finder). It uses git reflog to show
      recently used branches with preview of commit history.
    '';
    homepage = "https://github.com/meros/bash-b";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "b";
    platforms = platforms.unix;
  };
}
