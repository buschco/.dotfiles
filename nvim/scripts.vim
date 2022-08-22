echo getline(1)
if getline(1) =~ '^\/\/\s\@flow'
  setfiletype typescript.txs
endif
