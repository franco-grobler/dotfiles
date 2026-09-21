# Dockerfiles and compose files.
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dockerfile-language-server
    docker-compose-language-service
    hadolint # linting, through nvim-lint
  ];
}
