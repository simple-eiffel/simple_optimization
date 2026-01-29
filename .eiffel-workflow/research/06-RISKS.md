# RISKS: simple_optimization

## Risk Register

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| RISK-001 | Local minima instead of global | HIGH | MEDIUM | Document this limitation; Phase 2 adds global search |
| RISK-002 | Slow convergence on ill-conditioned problems | MEDIUM | MEDIUM | User-provided scaling/preconditioning; documentation |
| RISK-003 | Numerical gradient inaccuracy | MEDIUM | MEDIUM | Small step size tuning; user can provide analytical |
| RISK-004 | Users request constrained optimization immediately | HIGH | MEDIUM | Clear MVP scope; Phase 2 roadmap |
| RISK-005 | Performance on very high-dimensional problems | MEDIUM | LOW | Recommend < 100 variables for Phase 1 |

## Technical Risks

### RISK-001: Local Minima Problem
**Description:** Nelder-Mead and gradient descent are local search; may find wrong minimum
**Likelihood:** HIGH
**Impact:** MEDIUM (misleading results without user knowing)
**Indicators:** Found minimum looks wrong; objective value unexpected
**Mitigation:** Document clearly that MVP is local search; Phase 2 adds global methods
**Contingency:** Phase 2 adds multi-start and simulated annealing

### RISK-002: Poor Scaling on Ill-Conditioned Problems
**Description:** Gradient descent fails on problems with very different variable scales
**Likelihood:** MEDIUM
**Impact:** MEDIUM (convergence fails)
**Indicators:** Very slow convergence or oscillation
**Mitigation:** Document need for problem scaling; recommend precondition variables
**Contingency:** Phase 2 adds adaptive scaling or quasi-Newton methods

### RISK-003: Finite Difference Gradient Inaccuracy
**Description:** Numerical gradient via finite differences may be inaccurate
**Likelihood:** MEDIUM
**Impact:** MEDIUM (slow convergence, wrong directions)
**Indicators:** Convergence slower than expected; stepping perpendicular to gradient
**Mitigation:** Recommend analytical gradients where possible; tune step size
**Contingency:** User provides analytical gradient to recover performance

### RISK-004: API Mismatch with SciPy Expectations
**Description:** Users familiar with scipy.optimize.minimize may find differences confusing
**Likelihood:** MEDIUM
**Impact:** LOW (documentation clarifies)
**Indicators:** Support requests about API differences
**Mitigation:** Document differences clearly; provide scipy-like wrapper in Phase 2
**Contingency:** Phase 2 adds compatibility layer

## Ecosystem Risks

### RISK-005: Constrained Optimization Demand
**Description:** Users immediately request linear/nonlinear constraints
**Likelihood:** HIGH
**Impact:** MEDIUM (scope expansion)
**Mitigation:** Bounds only for MVP; clear roadmap for Phase 2
**Contingency:** Implement simple penalty method if needed; defer full SQP to Phase 2
