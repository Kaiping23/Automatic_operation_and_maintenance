drc(){ rancher -c /etc/rancher/cli_dev.json $@ ;}
urc(){ rancher -c /etc/rancher/cli_uat.json $@ ;}
src(){ rancher -c /etc/rancher/cli_sit.json $@ ;}
prc(){ rancher -c /etc/rancher/cli.json $@ ;}
