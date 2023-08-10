{config, pkgs, ...} : {
	xdg = {
	    enable = true;
	    mimeApps = {
	      enable = true;
	      defaultApplications = {
	        "text/plain" = "micro.desktop";
	        #"application/zip" = "org.gnome.FileRoller.desktop";
	        #"application/rar" = "org.gnome.FileRoller.desktop";
	        #"application/7z" = "org.gnome.FileRoller.desktop";
	        #"application/*tar" = "org.gnome.FileRoller.desktop";
	        #"inode/directory" = "pcmanfm.desktop";
	        #"application/pdf" = "okularApplication_pdf.desktop";
	        #"image/*" = "imv-folder.desktop";
	        #"video/*" = "umpv.desktop";
	        #"audio/*" = "org.gnome.Lollypop.desktop";
	        #"x-scheme-handler/tg" = "telegramdesktop.desktop";
	        "text/html" = "brave-browser.desktop";
	        "x-scheme-handler/http" = "brave-browser.desktop";
	        "x-scheme-handler/https" = "brave-browser.desktop";
	        "x-scheme-handler/ftp" = "brave-browser.desktop";
	        "x-scheme-handler/chrome" = "brave-browser.desktop";
	        "x-scheme-handler/about" = "brave-browser.desktop";
	        "x-scheme-handler/unknown" = "brave-browser.desktop";
	        "application/x-extension-htm" = "brave-browser.desktop";
	        "application/x-extension-html" = "brave-browser.desktop";
	        "application/x-extension-shtml" = "brave-browser.desktop";
	        "application/xhtml+xml" = "brave-browser.desktop";
	        "application/x-extension-xhtml" = "brave-browser.desktop";
	        "application/x-extension-xht" = "brave-browser.desktop";
	      };
	    };
	  };
}
