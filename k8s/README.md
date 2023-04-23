
```
kubectl run -i --tty --rm --image ubuntu test-shell -- /bin/bash

KUBECONFIG=~/.kube/config:~/.kube/configprod kubectl config view --flatten

```
