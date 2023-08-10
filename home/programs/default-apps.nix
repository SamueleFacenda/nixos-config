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
	        "text/html" = "brave.desktop";
	        "x-scheme-handler/http" = "brave.desktop";
	        "x-scheme-handler/https" = "brave.desktop";
	        "x-scheme-handler/ftp" = "brave.desktop";
	        "x-scheme-handler/chrome" = "brave.desktop";
	        "x-scheme-handler/about" = "brave.desktop";
	        "x-scheme-handler/unknown" = "brave.desktop";
	        "application/x-extension-htm" = "brave.desktop";
	        "application/x-extension-html" = "brave.desktop";
	        "application/x-extension-shtml" = "brave.desktop";
	        "application/xhtml+xml" = "brave.desktop";
	        "application/x-extension-xhtml" = "brave.desktop";
	        "application/x-extension-xht" = "brave.desktop";
	      };
	    };
	  };
}
