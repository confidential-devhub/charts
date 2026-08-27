# Confidential Computing Helm Charts

Helm charts for deploying confidential computing operators and workloads on Kubernetes/OpenShift.

> [!WARNING]
> **Important Notes**
>
> - Charts are **separated by design**: operator CRDs must be installed before operand CRs can be created
> - **OLM Lifecycle Conflicts:** These charts create OLM Subscriptions; using `helm install` can cause ownership conflicts during upgrades and rollbacks. Prefer `helm template` with manual coordination or ArgoCD.

> [!NOTE]
> This repository is in early development. In the future, these charts may be moved to their respective operator repositories.

## Charts

### Trustee
- **trustee-operator**: Deploys the Trustee operator via OLM
- **trustee-operands**: Deploys Trustee services (KBS, AS, RVPS)

### OpenShift Sandboxed Containers (OSC)
- **osc-operator**: Deploys the OSC operator via OLM
- **osc-operands**: Deploys OSC runtime configuration

## Installation

> [!NOTE]
> This is the general workflow for installing the charts. Always check each chart's `values.yaml` for available customizations and chart-specific instructions.

### Namespace

Each operator chart always creates the target namespace as part of the deployment. By default this is the Helm release namespace (`.Release.Namespace`). To deploy into a specific namespace, set `namespaceOverride`:

```bash
--set namespaceOverride=openshift-sandboxed-containers-operator   # for OSC
--set namespaceOverride=trustee-operator-system                   # for Trustee
```

The operand charts reference `namespaceOverride` the same way but do not create the namespace — they expect the operator chart to have created it already.

### Two-Stage Installation

```bash
# Use OPERATOR=trustee or OPERATOR=osc
OPERATOR=trustee
NS=trustee-operator-system  # optional: set a target namespace

# Stage 1: Deploy operator (creates the namespace)
helm template ${OPERATOR}-operator charts/${OPERATOR}-operator \
  --set namespaceOverride=${NS} | kubectl apply -f -

# Stage 2: Wait for operator ready (check operator deployment is available)

# Stage 3: Deploy operands (into the same namespace)
helm template ${OPERATOR}-operands charts/${OPERATOR}-operands \
  --set namespaceOverride=${NS} | kubectl apply -f -
```

### Using ArgoCD

Alternatively, if you would like to use a proper GitOps workflow, ArgoCD can coordinate the installation order automatically. See examples in the [coco-scenarios](https://github.com/beraldoleal/coco-scenarios) repository.

## Contributing

This project is evolving constantly. Issues and pull requests are welcome!
