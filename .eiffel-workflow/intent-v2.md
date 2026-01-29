# Intent: simple_optimization

## What
A production-grade unconstrained optimization library for Eiffel supporting two complementary solvers: Nelder-Mead simplex (derivative-free) and gradient descent with Armijo line search (requires derivatives). Supports up to 50+ variables with bound constraints.

## Why
Eiffel lacks native optimization capability. Parameter estimation, model calibration, and design optimization require robust solvers. simple_optimization provides Design-by-Contract verified algorithms suitable for research, engineering, and machine learning applications.

## Users
- Parameter estimation researchers
- Machine learning practitioners
- Control systems designers
- Optimization engineers
- Data science applications

## Acceptance Criteria
- [ ] Nelder-Mead simplex method with n+1 vertices
- [ ] Reflection (α=1), expansion (γ=2), contraction (ρ=0.5), shrinkage (σ=0.5)
- [ ] Gradient descent with numerical central differences
- [ ] Optional analytical gradient support
- [ ] Armijo backtracking line search (c=1e-4)
- [ ] Bound constraints via projection
- [ ] Support for 50+ dimensional problems
- [ ] Convergence detection (simplex diameter + function value range for NM; gradient norm for GD)
- [ ] Optional iteration history tracking
- [ ] 100% Design by Contract coverage
- [ ] All tests passing (100% pass rate)

## Out of Scope
- Constrained optimization (linear/quadratic programming)
- Global optimization (simulated annealing, genetic algorithms Phase 2+)
- Second-order methods (Newton, quasi-Newton Phase 2+)
- Parallel ensemble optimization
- Surrogate model optimization

## Dependencies

| Need | Library | Justification |
|------|---------|---------------|
| Square root, exp, abs | simple_math | Essential for numerical computations |
| Data structures | ISE base | Fundamental types only |
| Testing framework | ISE testing | EQA_TEST_SET for unit tests |

**MML Decision:** YES-Required

Rationale: SIMPLEX maintains n+1 vertices as ARRAY [ARRAY [REAL_64]]. OPTIMIZATION_HISTORY tracks LIST of iterations. Frame conditions using MML model queries verify:
- Monotone decrease in objective function
- Dimension preservation through optimization
- Bounds enforcement (x_min ≤ x_i ≤ x_max)
- Convergence detection correctness

## Technical Constraints
- **void_safety="all"**: All potential null pointers handled
- **SCOOP compatible**: OPTIMIZATION_RESULT immutable for concurrent access
- **No external C bindings**: Pure Eiffel implementation
- **Local optimization Phase 1**: Global methods deferred to Phase 2

## Gaps Identified (Potential simple_* Libraries)

| Gap | Current Workaround | Proposed simple_* |
|-----|-------------------|-------------------|
| Constrained optimization | Not implemented (Phase 2+) | simple_constrained_opt |
| Global optimization | Not implemented (Phase 2+) | simple_global_opt |
| Surrogate models | Not needed Phase 1 | simple_surrogates |

**Recommendation:** After shipping Phase 1, consider simple_constrained_opt for engineering design (topology, parameter bounds).

## Phase Scope
**Phase 1 MVP:** 10 classes, Nelder-Mead + gradient descent, Armijo line search, bounds
**Phase 2:** Constrained optimization (penalty methods, SQP), second-order methods
**Phase 3+:** Global optimization, parallel ensemble methods

## Solver Comparison

| Solver | Best For | Convergence | Gradient | Robustness |
|--------|----------|-------------|----------|------------|
| Nelder-Mead | Noisy, non-smooth | Slow (linear) | Not needed | Excellent |
| Gradient Descent | Smooth, well-conditioned | Medium-fast (superlinear) | Required | Good |

## Line Search Strategy
**Armijo Backtracking (Phase 1):**
- Initial step: α = 1.0
- Parameter: c = 1e-4
- Backtracking: α → α/2 if condition not met
- Max backtracks: 10
- Ensures: f(x + α*d) ≤ f(x) + c*α*(∇f·d)

## Success Metrics
- Implementation passes all 10 task acceptance criteria
- Nelder-Mead converges on Rosenbrock, sphere, Rastrigin functions
- Gradient descent converges on quadratic and ill-conditioned problems
- Armijo condition verified in all line search steps
- Bounds enforced correctly through projection
- No external library dependencies beyond simple_math and ISE base
