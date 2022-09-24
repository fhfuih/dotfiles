augroup packer_user_config
  autocmd!
  autocmd BufWritePost "*/plugins/init.lua" source <afile> | PackerCompile
augroup end
