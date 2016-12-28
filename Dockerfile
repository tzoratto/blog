FROM publysher/hugo

CMD hugo server -b ${HUGO_BASE_URL} --appendPort=false --disableLiveReload=true --bind=0.0.0.0