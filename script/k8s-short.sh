#! /bim/bash
kw(){ kubectl --kubeconfig=/root/.kube/config $@ -n wmy; };
ks(){ kubectl --kubeconfig=/root/.kube/config $@ -n kube-system ; };
kb(){ kubectl --kubeconfig=/root/.kube/config $@; };
km(){ kubectl --kubeconfig=/root/.kube/config $@ -n middleware ; };
ka(){ kubectl --kubeconfig=/root/.kube/config $@ --all-namespaces ; };
