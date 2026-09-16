# Trustee Operator

Deploys the [Trustee
Operator](https://github.com/confidential-containers/trustee) via OLM on
OpenShift.

> [!NOTE]
> This chart only installs the operator. Operand resources (CRs, ConfigMaps,
> Secrets) are deployed separately via the `trustee-operands` chart.

## Requirements

- OpenShift Container Platform 4.16+
- Access to Red Hat Operator catalog (production) or custom catalog source (development)

## Installation

```bash
helm template trustee-operator charts/trustee-operator \
  | kubectl apply -f -
```

Wait for the operator to be ready before deploying operands.

## Configuration

| Value | Default | Description |
|---|---|---|
| `dev.enabled` | `true` | Create a custom `CatalogSource`, mirror sets, and subscribe to the dev catalog |
| `dev.image` | see `values.yaml` | FBC image to use for the dev catalog |
| `subscription.config.env` | `[]` | Extra env vars injected into the operator via the Subscription |

### Development mode (default)

By default (`dev.enabled=true`) the chart creates:

- A `trustee-operator-dev-catalog` `CatalogSource` pointing at a pre-release Konflux FBC image
- `ImageTagMirrorSet` and `ImageDigestMirrorSet` resources to redirect `registry.redhat.io` image pulls to `quay.io/redhat-user-workloads`
- A `Subscription` pointing at the dev catalog

### Production / CI mode

Set `dev.enabled=false` to skip `CatalogSource` and mirror set creation entirely. The
`Subscription` will point to `redhat-operators` instead.

```bash
# Example: prow CI install without creating a custom catalog
helm template trustee-operator charts/trustee-operator --set dev.enabled=false | kubectl apply -f -
```
- **namespaceOverride**: Target namespace for the operator. The chart always creates this namespace. Defaults to the Helm release namespace if not set.
- **Production mode**: Uses official Red Hat operators catalog
- **Development mode**: Uses custom catalog source with pre-release images and mirror sets

## Uninstalling

```bash
helm template trustee-operator charts/trustee-operator | kubectl delete -f -
```
