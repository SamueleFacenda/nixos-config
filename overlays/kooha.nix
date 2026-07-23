final: prev: {
  # Add complete gstreamer plugin support
  kooha = prev.kooha.overrideAttrs (oldAttrs: {
    buildInputs = with final; oldAttrs.buildInputs ++ [
      gst_all_1.gst-plugins-bad   # AAC audio encoders for MP4
      gst_all_1.gst-libav         # Additional codec support
    ];
  });
}
