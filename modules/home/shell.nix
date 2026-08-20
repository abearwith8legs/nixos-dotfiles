{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      full-rebuild = "git -C /etc/nixos add -A; git -C /etc/nixos commit -m 'System update'; sudo nixos-rebuild switch --flake /etc/nixos#beenixos && git -C /etc/nixos push";
      rebuild = "git -C /etc/nixos add -A && sudo nixos-rebuild switch --flake /etc/nixos#beenixos";
      sync-rebuild = "git -C /etc/nixos pull && rebuild";
      git-status = "git -C /etc/nixos status";
      git-push = "git -C /etc/nixos push";
      git-pull = "git -C /etc/nixos pull";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username [>](bold green) [$time](dimmed green) [$directory](bold cyan) [$cmd_duration](dimmed yellow)\n$git_branch$git_status$character";

      username = {
        style_user = "bold green";
        style_root = "bold red";
        format = "[$user]($style)";
        show_always = true;
      };

      time = {
        disabled = false;
        format = "[$time](dimmed green)";
        time_format = "%H:%M:%S";
      };

      directory = {
        style = "bold cyan";
        read_only = " [RO]";
        read_only_style = "bold red";
        truncation_length = 3;
        truncation_symbol = ".../";
        format = "[$path]($style)[$read_only]($read_only_style)";
      };

      cmd_duration = {
        disabled = false;
        format = "[⏱ $duration](dimmed yellow)";
        min_time = 2000;
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[!](bold red)";
        vicmd_symbol = "[<](bold yellow)";
      };

      git_branch = {
        symbol = "git:";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      git_status = {
        format = "([\\$all_status$ahead_behind]($style)) ";
        style = "bold yellow";
        conflicted = "=";
        ahead = "^+$${count}";
        behind = "^-$${count}";
        diverged = "^<>";
        untracked = "?";
        stashed = "$";
        modified = "*";
        staged = "+";
        renamed = "r";
        deleted = "x";
      };
    };
  };
}
