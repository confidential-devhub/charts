# Trustee Operator Helm Chart

This Helm chart deploys the [Trustee
Operator](https://github.com/confidential-containers/trustee) on OpenShift
using the standard OLM (Operator Lifecycle Manager) flow.

**Note:** This chart only installs the operator-related resources. Operand
components (such as CRs, ConfigMaps, Secrets) must be deployed separately. We
deploy them separately to avoid conflict with missing CRDs during the
deployment of the operands.

## Installing

We recommend using `helm template` rather than `helm install`:

```bash
helm template trustee-operator -n trustee-operator-system ./charts/trustee-operator | oc apply -f -
```

This will create the following resources:

  * Namespace
  * OperatorGroup
  * Subscription
  * Mirrors (if devel mode is enabled)

We are not using "helm install" because this chart installs OLM-managed
resources like Subscription, using helm install would cause Helm to track their
lifecycle, potentially conflicting with OLM behavior. Rendering and applying
the YAML avoids this issue and fits well with declarative workflows.

### Wait for the Operator to Be Ready

Before applying any operand resources, make sure the operator is fully
installed. This can be verified by waiting for the CSV to reach the Succeeded
phase:

```bash
oc wait --for=jsonpath='{.status.phase}'=Succeeded csv/trustee-operator.v0.3.0 -n trustee-operator-system --timeout=300s
```

## Uninstalling

To remove the operator and all related resources:

```bash
helm template trustee-operator ./charts/trustee-operator | oc delete -f -
```
