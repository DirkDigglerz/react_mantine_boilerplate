RegisterNuiCallback('GET_SETTINGS', function(data, cb)
  cb({
    primaryColor = 'clean', 
    primaryShade = 9, 
    customTheme  = {
      "#f8edff",
      "#e9d9f6",
      "#d0b2e8",
      "#b588da",
      "#9e65cf",
      "#914ec8",
      "#8a43c6",
      "#7734af",
      "#692d9d",
      "#5c258b"
    },
     
    -- ADD YOUR SETTINGS HERE THEY WILL PULL WHEN THE UI INITIALIZES
  })

end)
