{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "markdavenport";
  home.homeDirectory = "/Users/markdavenport";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello
    (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
    pkgs.kubectx  # Adds kubectx and kubens for managing Kubernetes contexts and namespaces
    pkgs.asdf-vm  # Add ASDF version manager
    pkgs.docker   # Docker CLI and daemon
    pkgs.docker-compose  # Docker Compose
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/markdavenport/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_INSECURE = "1";
    NIXPKGS_ALLOW_UNFREE = "1";
    NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = "1";
    OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
    PATH = "/Users/markdavenport/.dotnet/tools:\${PATH}";
    DOTNET_ENVIRONMENT = "Development";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Enable and configure Starship prompt
  programs.starship = {
    enable = true;
    # Default configuration is pretty good, but you can customize it here
    settings = {
      # Add any custom settings here
      add_newline = true;
      command_timeout = 1000;
    };
  };

  # Enable and configure Zsh with Oh My Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initExtra = ''
      # ASDF setup
      . ${pkgs.asdf-vm}/share/asdf-vm/asdf.sh
      fpath=(${pkgs.asdf-vm}/share/asdf-vm/completions $fpath)
      autoload -Uz compinit && compinit
    '';

    # Add custom aliases
    shellAliases = {
      kc = "kubectl";
      k = "kubectl";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "macos"
        "kubectl"
        "history"
        "sudo"
      ];
    };
  };

  # Enable and configure direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Better integration with Nix
    enableZshIntegration = true; # Enable Zsh integration
  };

  # Enable and configure Git
  programs.git = {
    enable = true;
    
    # Your personal Git configuration
    userName = "Mark Davenport";
    userEmail = "markadavenport@gmail.com";  # Replace with your email

    # Default Git configurations
    extraConfig = {
      core = {
        editor = "vim";  # Default editor for commit messages
        autocrlf = "input";  # Line ending configuration
        whitespace = "trailing-space,space-before-tab";
      };
      init.defaultBranch = "master";
      pull.rebase = true;  # Rebase instead of merge on pull
      push.autoSetupRemote = true;  # Automatically set up remote on first push
      fetch.prune = true;  # Remove remote-tracking branches that were deleted remotely

      # Configure SSH authentication and signing
      commit.gpgsign = true;  # Enable signing of commits
      gpg.format = "ssh";  # Use SSH format for signing
      user.signingkey = "~/.ssh/id_ed25519.pub";  # Path to your SSH public key
      
      # SSH configuration for Git
      url."git@github.com:".insteadOf = "https://github.com/";  # Always use SSH for GitHub
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";  # Specify SSH key for Git operations
      
      # Helpful aliases
      alias = {
        # Shortcuts
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        
        # Pretty logging
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        
        # Show changes
        staged = "diff --cached";
        
        # Branch management
        recent-branches = "branch --sort=-committerdate --format='%(committerdate:relative)%09%(refname:short)'";
      };

      # Color configuration
      color = {
        ui = true;
        status = {
          added = "green";
          changed = "yellow";
          untracked = "red";
        };
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
      };
    };

    # Git ignore global settings
    ignores = [
      ".DS_Store"
      "*.swp"
      ".env"
      ".direnv"
      "node_modules"
      ".vscode"
      ".idea"
      "*.log"
      "*.pyc"
      "__pycache__"
      ".pytest_cache"
      "dist"
      "build"
    ];
  };

  # Enable and configure Vim
  programs.vim = {
    enable = true;
    
    # Enable default plugins
    defaultEditor = true;
    
    # Vim configuration
    extraConfig = ''
      " Basic Settings
      set nocompatible
      set number                     " Show line numbers
      set ruler                      " Show cursor position
      set incsearch                  " Show search matches as you type
      set hlsearch                   " Highlight search results
      set ignorecase                 " Ignore case when searching
      set smartcase                  " Override ignorecase when search includes uppercase
      set autoindent                 " Auto-indent new lines
      set smartindent                " Enable smart-indent
      set expandtab                  " Use spaces instead of tabs
      set softtabstop=2             " Number of spaces per Tab
      set shiftwidth=2              " Number of auto-indent spaces
      set showmatch                  " Highlight matching brackets
      set wildmenu                   " Enhanced command line completion
      set wildmode=longest:full,full " Complete till longest common string
      set clipboard=unnamed          " Use system clipboard
      set backspace=indent,eol,start " Make backspace work as expected
      set hidden                     " Enable background buffers
      set laststatus=2              " Always show status line
      set showcmd                    " Show partial commands
      set mouse=a                    " Enable mouse support
      set history=1000              " More command history
      set scrolloff=5               " Keep 5 lines above/below cursor visible
      set sidescrolloff=5           " Keep 5 columns left/right of cursor visible
      
      " Visual Settings
      syntax enable                  " Enable syntax highlighting
      set background=dark           " Use dark background
      set cursorline                " Highlight current line
      
      " File Type Settings
      filetype plugin indent on     " Enable file type detection
      
      " Key Mappings
      let mapleader = ","           " Set leader key to comma
      
      " Easy split navigation
      nnoremap <C-J> <C-W><C-J>
      nnoremap <C-K> <C-W><C-K>
      nnoremap <C-L> <C-W><C-L>
      nnoremap <C-H> <C-W><C-H>
      
      " Quick save
      nnoremap <leader>w :w<CR>
      
      " Clear search highlighting
      nnoremap <leader><space> :nohlsearch<CR>
      
      " Buffer navigation
      nnoremap <leader>l :bnext<CR>
      nnoremap <leader>h :bprevious<CR>
      
      " Strip trailing whitespace on save
      autocmd BufWritePre * :%s/\s\+$//e
    '';
    
    # Additional plugins can be added here if needed
    plugins = with pkgs.vimPlugins; [
      vim-surround           # Easily delete, change and add surroundings in pairs
      vim-commentary        # Comment stuff out
      vim-gitgutter        # Show git diff in the sign column
      vim-airline          # Status/tabline
      vim-airline-themes   # Themes for vim-airline
      vim-nix             # Nix syntax highlighting
    ];
  };

  # Enable and configure tmux
  programs.tmux = {
    enable = true;
    mouse = true;  # Enable mouse support
    terminal = "xterm-256color";  # Set default terminal
    extraConfig = ''
      # Make sure tmux doesn't interfere with terminal URL detection
      set -ga terminal-overrides ',xterm*:Tc'
    '';
  };
}

