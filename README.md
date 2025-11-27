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

### Two-Stage Installation

```bash
# Use OPERATOR=trustee or OPERATOR=osc
OPERATOR=trustee

# Stage 1: Deploy operator
helm template ${OPERATOR}-operator charts/${OPERATOR}-operator | kubectl apply -f -

# Stage 2: Wait for operator ready (check operator deployment is available)

# Stage 3: Deploy operands
helm template ${OPERATOR}-operands charts/${OPERATOR}-operands | kubectl apply -f -
```

### Using ArgoCD

Alternatively, if you would like to use a proper GitOps workflow, ArgoCD can coordinate the installation order automatically. See examples in the [coco-scenarios](https://github.com/beraldoleal/coco-scenarios) repository.

## Contributing

This project is evolving constantly. Issues and pull requests are welcome!
