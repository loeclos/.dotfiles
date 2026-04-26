{ pkgs, ... }:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		
		extraPackages = with pkgs; [
			nil
			pyright
			rust-analyzer
			lua-language-server
			nixfmt-rfc-style
			stylua
		];

		plugins = with pkgs.vimPlugins; [
			nvim-lspconfig
			nvim-treesitter.withAllGrammars
			plenary-nvim
			telescope-nvim
			which-key-nvim
		];
	};
}


