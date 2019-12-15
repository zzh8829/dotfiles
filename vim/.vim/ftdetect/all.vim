" https://github.com/rafi/vim-config/blob/master/filetype.vim

autocmd BufNewFile,BufRead */playbooks/*.{yml,yaml} setfiletype yaml.ansible
autocmd BufNewFile,BufRead */inventory/*            setfiletype ansible_hosts
autocmd BufNewFile,BufRead */templates/*.{yaml,tpl} setfiletype yaml.gotexttmpl

autocmd BufNewFile,BufRead *.hcl                setfiletype terraform
autocmd BufNewFile,BufRead yarn.lock            setfiletype yaml
autocmd BufNewFile,BufRead */.kube/config       setfiletype yaml
autocmd BufNewFile,BufRead *.postman_collection setfiletype json
autocmd BufNewFile,BufRead .tern-{project,port} setfiletype json
autocmd BufNewFile,BufRead *.js.map             setfiletype json
autocmd BufNewFile,BufRead .jsbeautifyrc        setfiletype json
autocmd BufNewFile,BufRead .eslintrc            setfiletype json
autocmd BufNewFile,BufRead .jscsrc              setfiletype json
autocmd BufNewFile,BufRead .babelrc             setfiletype json
autocmd BufNewFile,BufRead .watchmanconfig      setfiletype json
autocmd BufNewFile,BufRead .buckconfig          setfiletype toml
autocmd BufNewFile,BufRead .flowconfig          setfiletype ini
autocmd BufNewFile,BufRead Jenkinsfile          setfiletype groovy
autocmd BufNewFile,BufRead Tmuxfile,tmux/config setfiletype tmux
autocmd BufNewFile,BufRead Brewfile             setfiletype ruby
